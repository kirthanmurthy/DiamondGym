import requests 
from dotenv import load_dotenv
import os


load_dotenv()

API_KEY = os.getenv('API_KEY')
if not API_KEY:
    raise ValueError("API_KEY not found!")
base_url = "https://api.spoonacular.com/recipes/complexSearch"

def search_recipe(ingredients, restrictions, cuisine_preference, time_available):
    params = {
        'apiKey': API_KEY,
        'number': 15,
        'addRecipeInformation': True,
        'addRecipeNutrition': True
    }

    if ingredients:
        params['includeIngredients'] = ingredients
    if restrictions:
        params['intolerances'] = restrictions
    if cuisine_preference:
        params['cuisine'] = cuisine_preference
    if time_available:
        params['maxReadyTime'] = int(time_available)
    
    response = requests.get(base_url, params=params)
    data = response.json()
    return data.get('results', [])

def score_recipe(recipe, context, user_preference):
    ingredients = context["ingredients"]
    restrictions = user_preference["restrictions"]
    cuisine_preference = user_preference["cuisine_preference"]
    time_available = context["time_available"]
    calorie_goal = user_preference["calorie_goal"]

    recipe_ingredients = recipe.get('extendedIngredients', [])
    recipe_cuisines = recipe.get('cuisines', [])
    recipe_time = int(recipe.get('readyInMinutes', 999))
    recipe_calories = None
    for nutrient in recipe.get('nutrition', {}).get('nutrients', []):
        if nutrient['name'] == 'Calories':
            recipe_calories = int(nutrient['amount'])
            break 
    
    score = 0 

    if cuisine_preference:
        recipe_cuisines_list = []
        for recipe in recipe_cuisines:
            recipe_cuisines_list.append(recipe.lower())
        user_cuisine = cuisine_preference.lower()

        if (user_cuisine in recipe_cuisines_list):
            score += 50
            if (len(recipe_cuisines_list) == 1):
                score += 25
        else:
            score -= 50

    if time_available:
        max_time = int(time_available)

        if recipe_time > max_time:
            score -= 50
        else:
            score += 50 * (1 - (recipe_time / max_time))

    if calorie_goal and recipe_calories:
        target = int(calorie_goal)
        difference = abs(recipe_calories - target)
        proximity = max(0, 1 - (difference / target))
        score += 50 * proximity

    return score
    

def rank_recipes(recipes, context, user_preferences):
    for recipe in recipes: 
        recipe["score"] = score_recipe(recipe, context, user_preferences)

    return sorted(recipes, key=lambda x: x["score"], reverse=True)

if __name__ == "__main__":
    ingredients = input("List on hand ingredients: ")
    restrictions = input("List restrictions: ")
    cuisine_preference = input("List Cuisine Preference: ")
    time_available = input("List time available to cook: ")
    calorie_goal = input("List calorie goal: ")

    print(" ")

    context = {
        "ingredients": ingredients,
        "time_available": time_available
    }

    user_preferences = {
        'restrictions': restrictions,
        'cuisine_preference': cuisine_preference,
        'calorie_goal': calorie_goal
    }
    
    recipes = search_recipe(ingredients, restrictions, cuisine_preference, time_available)
    ranked = rank_recipes(recipes, context, user_preferences)
    for recipe in ranked:
        cuisines = ', '.join(recipe.get('cuisines', ['N/A']))
        diets = ', '.join(recipe.get('diets', ['None']))
        
        calories = None
        nutrition = recipe.get('nutrition', {})
        for nutrient in nutrition.get('nutrients', []):
            if nutrient['name'] == 'Calories':
                calories = f"{nutrient['amount']:.0f}"
                break
        
        print(f"{recipe['title']} | {recipe['readyInMinutes']} min | {cuisines} | {calories} cal | Score: {round(score_recipe(recipe, context, user_preferences), 2)}")