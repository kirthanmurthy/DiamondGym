import json
import os

DATA_PATH = os.path.join(os.path.dirname(__file__), "..", "data", "pantry.json")

def load_pantry():
    with open(DATA_PATH, "r") as file:
        return json.load(file)

def save_pantry(pantry):
    with open(DATA_PATH, "w") as file:
        json.dump(pantry, file, indent=4)

def get_pantry():
    pantry = load_pantry()
    return pantry["ingredients"]

def add_ingredient(ingredient):
    pantry = load_pantry()
    ingredient = ingredient.lower()

    if ingredient not in pantry["ingredients"]:
        pantry["ingredients"].append(ingredient)

    save_pantry(pantry)

def remove_ingredient(ingredient):
    pantry = load_pantry()
    ingredient = ingredient.lower()

    if ingredient in pantry["ingredients"]:
        pantry["ingredients"].remove(ingredient)

    save_pantry(pantry)

def clear_pantry():
    pantry = {"ingredients": []}
    save_pantry(pantry)

def subtract_recipe_ingredients(recipe_ingredients):
    pantry = load_pantry()
    pantry_items = pantry["ingredients"]
    
    for ingredient in recipe_ingredients:
        ingredient_name = ingredient.lower()
        if ingredient_name in pantry_items:
            pantry_items.remove(ingredient_name)

    save_pantry(pantry)