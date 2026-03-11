from datetime import datetime
from zoneinfo import ZoneInfo

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

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

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


class PantryItemPayload(BaseModel):
    ingredient: str


class RecipePayload(BaseModel):
    id: int | None = None
    title: str = ""
    ingredients: list[str] = []
    cuisines: list[str] = []
    readyInMinutes: int | None = None
    calories: int | None = None
    image: str = ""
    steps: list[str] = []


@app.get("/search")
def search(
    timezone: str = "America/Los_Angeles",
    ingredients: str = "",
    restrictions: str = "",
    cuisine_preference: str = "",
    time_available: str = "",
    calorie_goal: str = "",
):
    cuisine = cuisine_preference
    time = time_available
    cal = calorie_goal

    profile = load_profile()
    pantry = load_pantry()
    history = get_history()

    favorites = get_favorites()
    favorite_ids = []
    for item in favorites:
        if item.get("recipe_id") is not None:
            favorite_ids.append(item.get("recipe_id"))

    user_preferences = {
        "time_available": time,
        "calorie_goal": cal,
        "cuisine_preference": cuisine,
    }

    query_intolerances = []
    if restrictions.strip():
        for item in restrictions.split(","):
            text = item.strip()
            if text:
                query_intolerances.append(text)

    intolerances = profile.get("intolerances", [])
    for item in query_intolerances:
        if item not in intolerances:
            intolerances.append(item)

    diet = profile.get("diet")

    try:
        current_hour = datetime.now(ZoneInfo(timezone)).hour
    except Exception:
        current_hour = datetime.now().hour

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

    unique = {}
    for item in recipes:
        recipe_id = item.get("id")
        if recipe_id is not None:
            unique[recipe_id] = item
    recipes = list(unique.values())
    ranked = rank_recipes(
        recipes,
        pantry.get("ingredients", []),
        user_preferences,
        history,
        favorite_ids,
        current_hour,
    )

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

    return out


@app.post("/pantry/add")
def add_pantry_item(payload: PantryItemPayload):
    ingredient = payload.ingredient.strip().lower()
    if ingredient:
        add_ingredient(ingredient)

    return {"ingredients": load_pantry().get("ingredients", [])}


@app.post("/favorites")
def save_favorite(payload: RecipePayload):
    add_favorite(
        {
            "id": payload.id,
            "title": payload.title,
            "ingredients": payload.ingredients,
            "cuisines": payload.cuisines,
            "image": payload.image,
        }
    )
    return {"favorites": get_favorites()}


@app.delete("/favorites/{recipe_id}")
def delete_favorite(recipe_id: int):
    remove_favorite(recipe_id)
    return {"favorites": get_favorites()}


@app.post("/recipes/select")
def select_recipe(payload: RecipePayload):
    recipe = {
        "id": payload.id,
        "title": payload.title,
        "ingredients": payload.ingredients,
        "cuisines": payload.cuisines,
        "cook_time": payload.readyInMinutes,
        "calories": payload.calories,
        "image": payload.image,
        "steps": payload.steps,
    }

    add_to_history(recipe)
    subtract_recipe_ingredients(payload.ingredients)

    return {
        "history": get_history(),
        "ingredients": load_pantry().get("ingredients", []),
    }
