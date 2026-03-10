from flask import Flask, jsonify, request

from spoonacular import gather_instructions, get_image, rank_recipes, score_recipe, search_recipe

app = Flask(__name__)


def calories(recipe):
    for item in recipe.get("nutrition", {}).get("nutrients", []):
        if item.get("name") == "Calories":
            return int(item.get("amount", 0))
    return None


@app.get("/search")
def search():
    ingredients = request.args.get("ingredients", "")
    restrictions = request.args.get("restrictions", "")
    cuisine = request.args.get("cuisine_preference", "")
    time = request.args.get("time_available", "")
    cal = request.args.get("calorie_goal", "")

    ctx = {
        "ingredients": ingredients,
        "time_available": time,
    }
    prefs = {
        "restrictions": restrictions,
        "cuisine_preference": cuisine,
        "calorie_goal": cal,
    }

    recipes = search_recipe(ingredients, restrictions, cuisine, time)
    ranked = rank_recipes(recipes, ctx, prefs)

    out = []
    for recipe in ranked:
        out.append(
            {
                "title": recipe.get("title", ""),
                "readyInMinutes": recipe.get("readyInMinutes"),
                "calories": calories(recipe),
                "score": round(score_recipe(recipe, ctx, prefs), 2),
                "image": get_image(recipe),
                "steps": gather_instructions(recipe),
            }
        )

    return jsonify(out)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)
