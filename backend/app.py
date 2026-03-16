from flask import Flask, jsonify, request
from datetime import datetime
from zoneinfo import ZoneInfo

from api.spoonacular_api import get_clean_recipes
from history.history_manager import (
    add_favorite,
    add_to_history,
    get_favorites,
    get_history,
    remove_favorite,
)
from pantry.pantry_manager import add_ingredient, load_pantry, subtract_recipe_ingredients
from ranking.ranking_engine import rank_recipes
from user.user_profile import load_profile

app = Flask(__name__)


def calories(recipe):
    for item in recipe.get("nutrition", {}).get("nutrients", []):
        if item.get("name") == "Calories":
            return int(item.get("amount", 0))
    return None


def cuisine_matches(recipe, preferred_cuisine):
    if not preferred_cuisine:
        return False

    preferred = preferred_cuisine.strip().lower()
    if not preferred:
        return False

    for item in recipe.get("cuisines", []):
        if preferred in str(item).lower():
            return True

    return False


def _recipe_from_payload(data):
    return {
        "id": data.get("id"),
        "title": data.get("title", ""),
        "ingredients": data.get("ingredients", []),
        "cuisines": data.get("cuisines", []),
        "cook_time": data.get("readyInMinutes"),
        "calories": data.get("calories"),
        "image": data.get("image", ""),
        "steps": data.get("steps", []),
    }


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

    ranking_pantry = list(pantry.get("ingredients", []))
    if ingredients:
        for item in ingredients.split(","):
            text = item.strip().lower()
            if text and text not in ranking_pantry:
                ranking_pantry.append(text)

    try:
        current_hour = datetime.now(ZoneInfo(timezone)).hour
    except Exception:
        current_hour = datetime.now().hour

    try:
        diet = profile.get("diet")
        intolerances = profile.get("intolerances", [])

        recipes = get_clean_recipes(
            ingredients,
            diet,
            intolerances,
            cuisine,
            time,
            30,
        )

        if len(recipes) < 10 and cuisine:
            recipes += get_clean_recipes(
                ingredients,
                diet,
                intolerances,
                None,
                time,
                30,
            )

        if len(recipes) < 10 and time:
            recipes += get_clean_recipes(
                ingredients,
                diet,
                intolerances,
                None,
                None,
                30,
            )

        if len(recipes) < 10 and diet:
            recipes += get_clean_recipes(
                ingredients,
                None,
                intolerances,
                None,
                None,
                30,
            )

        if cuisine:
            recipes += get_clean_recipes(
                None,
                diet,
                intolerances,
                cuisine,
                None,
                20,
            )

        unique = {}
        for item in recipes:
            recipe_id = item.get("id")
            if recipe_id is not None:
                unique[recipe_id] = item
        recipes = list(unique.values())
    except RuntimeError as error:
        return jsonify({"error": str(error)}), 502

    ranked = rank_recipes(
        recipes,
        ranking_pantry,
        user_preferences,
        history,
        favorite_ids,
        current_hour,
    )

    # Keep fallback behavior, but prioritize results that match the chosen cuisine.
    if cuisine:
        matching = []
        non_matching = []
        for recipe in ranked:
            if cuisine_matches(recipe, cuisine):
                matching.append(recipe)
            else:
                non_matching.append(recipe)
        ranked = matching + non_matching

    out = []
    for recipe in ranked[:10]:
        out.append(
            {
                "id": recipe.get("id"),
                "title": recipe.get("title", ""),
                "ingredients": recipe.get("ingredients", []),
                "cuisines": recipe.get("cuisines", []),
                "readyInMinutes": recipe.get("cook_time"),
                "calories": recipe.get("calories"),
                "score": round(recipe.get("score", 0), 2),
                "image": recipe.get("image", ""),
                "steps": recipe.get("steps", []),
            }
        )

    return jsonify(out)


@app.post("/pantry/add")
def add_pantry_item():
    payload = request.get_json(silent=True) or {}
    ingredient = (payload.get("ingredient") or "").strip().lower()
    if ingredient:
        add_ingredient(ingredient)

    return jsonify({"ingredients": load_pantry().get("ingredients", [])})


@app.post("/favorites")
def save_favorite():
    payload = request.get_json(silent=True) or {}
    recipe = _recipe_from_payload(payload)
    add_favorite(recipe)
    return jsonify({"favorites": get_favorites()})


@app.delete("/favorites/<int:recipe_id>")
def delete_favorite(recipe_id):
    remove_favorite(recipe_id)
    return jsonify({"favorites": get_favorites()})


@app.post("/recipes/select")
def select_recipe():
    payload = request.get_json(silent=True) or {}
    recipe = _recipe_from_payload(payload)
    add_to_history(recipe)
    subtract_recipe_ingredients(recipe.get("ingredients", []))
    return jsonify(
        {
            "history": get_history(),
            "ingredients": load_pantry().get("ingredients", []),
        }
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)
