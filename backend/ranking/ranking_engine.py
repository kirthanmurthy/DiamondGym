from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from datetime import datetime 

def ingredient_matches(pantry_item, recipe_item):
    pantry_text = pantry_item.strip().lower()
    recipe_text = recipe_item.strip().lower()

    if not pantry_text or not recipe_text:
        return False

    return pantry_text in recipe_text or recipe_text in pantry_text

def compute_pantry_matches(recipes, pantry_ingredients):
    pantry_list = [item.strip().lower() for item in pantry_ingredients if item and item.strip()]

    for recipe in recipes:
        used = []
        missed = []

        for ingredient in recipe.get("ingredients",[]):
            matched = False
            for pantry_item in pantry_list:
                if ingredient_matches(pantry_item, ingredient):
                    matched = True
                    break

            if matched:
                used.append(ingredient)
            else:
                missed.append(ingredient)

        recipe["usedIngredients"] = used
        recipe["missedIngredients"] = missed

    return recipes

def ingredient_similarity(pantry_ingredients, recipes):
    if not recipes:
        return []

    recipe_docs=[]

    for recipe in recipes:
        ingredient_string = " ".join(recipe.get("ingredients",[]))
        recipe_docs.append(ingredient_string)

    pantry_doc = " ".join(pantry_ingredients)

    corpus = [pantry_doc] + recipe_docs

    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(corpus)

    pantry_vector = tfidf_matrix[0]
    recipe_vectors = tfidf_matrix[1:]

    similarities = cosine_similarity(pantry_vector,recipe_vectors)[0]

    return similarities


def ingredient_coverage(recipe):
    used = len(recipe.get("usedIngredients",[]))
    missed = len(recipe.get("missedIngredients",[]))
    total = used + missed

    if (total == 0):
        return 0

    return used / total

def time_score(recipe_time, time_available):
    if not time_available or not recipe_time:
        return 0

    recipe_time = int(recipe_time)
    time_available = int(time_available)

    if (recipe_time > time_available):
        return 0

    return 1 - (recipe_time / time_available)

def calorie_score(recipe_calories, calorie_goal):
    if not calorie_goal or not recipe_calories:
        return 0

    calorie_goal = int(calorie_goal)
    diff = abs(recipe_calories - calorie_goal)
    ratio = diff / calorie_goal

    if ratio <= 0.15:
        return 1.0
    if ratio <= 0.30:
        return 0.6
    if ratio <= 0.45:
        return 0.2
    if ratio <= 0.60:
        return -0.2
    return -0.8

def cuisine_score(recipe_cuisines,preferred_cuisine):
    if not preferred_cuisine:
        return 0

    preferred_cuisine = preferred_cuisine.lower()

    for c in recipe_cuisines:
        if preferred_cuisine in c.lower():
            return 1

    return 0

def favorite_boost(recipe_id,favorites):
    if recipe_id in favorites:
        return 0.75
    return 0

def history_similarity(recipe,history):
    if not history:
        return 0

    recipe_set = set(recipe.get("ingredients",[]))
    best_score = 0

    for past in history:
        past_set = set(past.get("ingredients",[]))

        intersection = recipe_set.intersection(past_set)
        union = recipe_set.union(past_set)

        if len(union) == 0:
            continue

        similarity= len(intersection) / len(union)
        best_score = max(best_score, similarity)

    return best_score

def time_of_meal_bonus(recipe, current_hour):
    if (current_hour is None):
        current_hour = datetime.now().hour
    current_meal = ""  
    if (current_hour >= 5 and current_hour < 11):
        current_meal = "breakfast"
    elif (current_hour >= 11 and current_hour < 16):
        current_meal = "lunch"
    else: 
        current_meal = "dinner"

    types = [] 
    for i in recipe.get("dishTypes", []):
        types.append(i.lower())

    if "breakfast" in types and current_meal == "breakfast":
        return 1
    if "lunch" in types and current_meal == "lunch":
        return 1
    if "dinner" in types and current_meal == "dinner":
        return 1
    if (("main course" in types or "main dish" in types) and (current_meal == "lunch" or current_meal == "dinner")):
        return 1
    
    return 0

def score_recipe(recipe, pantry, user_preferences, history, favorites, ingredient_sim, current_hour):
    score = 0

    coverage = ingredient_coverage(recipe)

    score += 4 * coverage

    score += 2 * ingredient_sim

    used_count = len(recipe.get("usedIngredients", []))
    if pantry:
        if used_count > 0:
            score += 1
        else:
            score -= 1.5

    score += 1.5 * time_score(recipe.get("cook_time"), user_preferences.get("time_available"))

    score += 2.5 * calorie_score(recipe.get("calories"), user_preferences.get("calorie_goal"))

    if user_preferences.get("calorie_goal") and recipe.get("calories") is None:
        score -= 1.2

    score += cuisine_score(recipe.get("cuisines",[]), user_preferences.get("cuisine_preference"))

    score += favorite_boost(recipe.get("id"), favorites)

    score += 1.5 * history_similarity(recipe, history)
    
    score += 0.8 * time_of_meal_bonus(recipe, current_hour)

    return score

def rank_recipes(recipes, pantry_ingredients, user_preferences, history, favorites, current_hour):
    if not recipes:
        return []

    recipes = compute_pantry_matches(recipes, pantry_ingredients)

    similarities = ingredient_similarity(pantry_ingredients, recipes)

    scored_recipes = []

    for i, recipe in enumerate(recipes):
        score = score_recipe(recipe, pantry_ingredients, user_preferences, history, favorites, similarities[i], current_hour)
        recipe["score"] = score
        scored_recipes.append(recipe)

    if pantry_ingredients:
        ranked = sorted(
            scored_recipes,
            key=lambda x: (len(x.get("usedIngredients", [])) > 0, x["score"]),
            reverse=True,
        )
    else:
        ranked = sorted(scored_recipes, key=lambda x:x["score"], reverse=True)

    return ranked