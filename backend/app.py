from flask import Flask, jsonify, request
from datetime import datetime
from zoneinfo import ZoneInfo

from api.spoonacular_api import get_clean_recipes
from ranking.ranking_engine import rank_recipes
from pantry.pantry_manager import load_pantry
from history.history_manager import get_history, get_favorites
from user.user_profile import load_profile

app = Flask(__name__)


def calories(recipe):
    for item in recipe.get("nutrition", {}).get("nutrients", []):
        if item.get("name") == "Calories":
            return int(item.get("amount", 0))
    return None

@app.get("/search")
def search():
    timezone = request.args.get("timezone", "America/Los_Angeles")
    ingredients = request.args.get("ingredients", "")
    restrictions = request.args.get("restrictions", "")
    cuisine = request.args.get("cuisine_preference", "")
    time = request.args.get("time_available", "")
    cal = request.args.get("calorie_goal", "")

    profile = load_profile()
    pantry = load_pantry()
    history = get_history()

    favorites = get_favorites()
    favorite_ids = []
    for item in favorites:
        if (item.get("recipe_id") is not None):
            favorite_ids.append(item.get("recipe_id"))

    user_preferences = {
        "time_available": time,
        "calorie_goal": cal,
        "cuisine_preference": cuisine
    }

    try:
        current_hour = datetime.now(ZoneInfo(timezone)).hour
    except Exception:
        current_hour = datetime.now().hour

    recipes = get_clean_recipes(ingredients, profile.get("diet"), profile.get("intolerances", []), cuisine, time, 30)
    ranked = rank_recipes(recipes,  pantry.get("ingredients", []), user_preferences, history, favorite_ids, current_hour)

    out = []
    for recipe in ranked:
        out.append(
            {
                "title": recipe.get("title", ""),
                "readyInMinutes": recipe.get("cook_time"),
                "calories": recipe.get("calories"),
                "score": round(recipe.get("score", 0), 2),
                "image": recipe.get("image", ""),
                "steps": recipe.get("steps", []),
            }
        )

    return jsonify(out)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)
