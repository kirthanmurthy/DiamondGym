import requests
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("API_KEY")

BASE_URL = "https://api.spoonacular.com/recipes/complexSearch"

def search_recipes(ingredients=None,
                   diet=None,
                   intolerances=None,
                   cuisine_preference=None,
                   time_available=None,
                   number=20):

    params = {
        "apiKey": API_KEY,
        "number": number,
        "addRecipeInformation": True,
        "addRecipeNutrition": True,
        "fillIngredients": True,
        "addRecipeInstructions": True
    }

    if ingredients:
        params["includeIngredients"] = ingredients

    if diet:
        params["diet"] = diet

    if intolerances:
        params["intolerances"] = ",".join(intolerances)

    if cuisine_preference:
        params["cuisine"] = cuisine_preference

    if time_available:
        params["maxReadyTime"] = int(time_available)

    try:
        response = requests.get(BASE_URL, params=params)
        response.raise_for_status()
        data = response.json()
    except Exception as e:
        print("API request failed:", e)
        return []

    return data.get("results", [])

def gather_instructions(recipe):
    num = 1 
    steps = []
    for block in recipe.get("analyzedInstructions", []):
        for step in block.get("steps", []):
            text = step["step"].replace("\xa0", " ").strip()
            steps.append(f"{num}. {text}")
            num += 1

    return steps

def format_recipe(recipe):
    ingredients=[]

    for item in recipe.get("extendedIngredients",[]):
        name=item.get("name","")
        if name:
            ingredients.append(name.lower())

    used=[]
    for item in recipe.get("usedIngredients",[]):
        name=item.get("name","")
        if name:
            used.append(name.lower())

    missed=[]
    for item in recipe.get("missedIngredients",[]):
        name=item.get("name","")
        if name:
            missed.append(name.lower())

    calories=None
    for nutrient in recipe.get("nutrition",{}).get("nutrients",[]):
        if nutrient.get("name")=="Calories":
            calories=int(nutrient.get("amount",0))
            break

    return{
        "id":recipe.get("id"),
        "title":recipe.get("title","Unknown"),
        "ingredients":ingredients,
        "usedIngredients":used,
        "missedIngredients":missed,
        "cuisines":recipe.get("cuisines",[]),
        "dishTypes": recipe.get("dishTypes", []), 
        "cook_time":recipe.get("readyInMinutes",None),
        "calories":calories,
        "image":recipe.get("image",None),
        "steps": gather_instructions(recipe) 
    }

def get_clean_recipes(ingredients=None,
                   diet=None,
                   intolerances=None,
                   cuisine_preference=None,
                   time_available=None,
                   number=20):

    raw_recipes = search_recipes(
        ingredients=ingredients,
        diet=diet,
        intolerances=intolerances,
        cuisine_preference=cuisine_preference,
        time_available=time_available,
        number=number
    )

    clean_recipes = []

    for recipe in raw_recipes:
        clean_recipes.append(format_recipe(recipe))

    return clean_recipes