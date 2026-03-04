import json
import os
from datetime import datetime

DATA_DIR=os.path.join(os.path.dirname(__file__),"..","data")
HISTORY_PATH=os.path.join(DATA_DIR,"history.json")
FAVORITES_PATH=os.path.join(DATA_DIR,"favorites.json")

def ensure_files():
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)
    if not os.path.exists(HISTORY_PATH):
        with open(HISTORY_PATH,"w") as f:
            json.dump({"history":[]},f,indent=4)
    if not os.path.exists(FAVORITES_PATH):
        with open(FAVORITES_PATH,"w") as f:
            json.dump({"favorites":[]},f,indent=4)

def load_history():
    ensure_files()
    with open(HISTORY_PATH,"r") as file:
        return json.load(file)

def save_history(data):
    with open(HISTORY_PATH,"w") as file:
        json.dump(data,file,indent=4)

def load_favorites():
    ensure_files()
    with open(FAVORITES_PATH,"r") as file:
        return json.load(file)

def save_favorites(data):
    with open(FAVORITES_PATH,"w") as file:
        json.dump(data,file,indent=4)

def add_to_history(recipe):
    history_data=load_history()
    today=datetime.now().strftime("%Y-%m-%d")

    recipe_id=recipe.get("id")
    title=recipe.get("title","Unknown")

    entry={
        "recipe_id":recipe_id,
        "title":title,
        "timestamp":today,
        "ingredients":recipe.get("ingredients",[]),
        "usedIngredients":recipe.get("usedIngredients",[]),
        "missedIngredients":recipe.get("missedIngredients",[]),
        "cook_time":recipe.get("cook_time",None),
        "calories":recipe.get("calories",None),
        "cuisines":recipe.get("cuisines",[]),
        "image":recipe.get("image",None)
    }

    for item in history_data["history"]:
        if item.get("recipe_id")==recipe_id:
            item.update(entry)
            save_history(history_data)
            return

    history_data["history"].append(entry)
    save_history(history_data)

def get_history():
    history_data=load_history()
    return history_data["history"]

def clear_history():
    save_history({"history":[]})

def add_favorite(recipe):
    favorites_data=load_favorites()
    recipe_id=recipe.get("id")
    title=recipe.get("title","Unknown")

    for item in favorites_data["favorites"]:
        if item.get("recipe_id")==recipe_id:
            return

    favorites_data["favorites"].append({
        "recipe_id":recipe_id,
        "title":title,
        "ingredients":recipe.get("ingredients",[]),
        "cuisines":recipe.get("cuisines",[]),
        "image":recipe.get("image",None)
    })
    save_favorites(favorites_data)

def remove_favorite(recipe_id):
    favorites_data=load_favorites()
    favorites_data["favorites"]=[
        item for item in favorites_data["favorites"]
        if item.get("recipe_id")!=recipe_id
    ]
    save_favorites(favorites_data)

def get_favorites():
    favorites_data=load_favorites()
    return favorites_data["favorites"]