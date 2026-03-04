from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

def compute_pantry_matches(recipes, pantry_ingredients):
    pantry_set=set(pantry_ingredients)

    for recipe in recipes:
        used=[]
        missed=[]

        for ingredient in recipe.get("ingredients",[]):
            if ingredient in pantry_set:
                used.append(ingredient)
            else:
                missed.append(ingredient)

        recipe["usedIngredients"]=used
        recipe["missedIngredients"]=missed

    return recipes


def ingredient_similarity(pantry_ingredients,recipes):
    if not recipes:
        return []

    recipe_docs=[]

    for recipe in recipes:
        ingredient_string=" ".join(recipe.get("ingredients",[]))
        recipe_docs.append(ingredient_string)

    pantry_doc=" ".join(pantry_ingredients)

    corpus=[pantry_doc]+recipe_docs

    vectorizer=TfidfVectorizer()
    tfidf_matrix=vectorizer.fit_transform(corpus)

    pantry_vector=tfidf_matrix[0]
    recipe_vectors=tfidf_matrix[1:]

    similarities=cosine_similarity(pantry_vector,recipe_vectors)[0]

    return similarities


def ingredient_coverage(recipe):
    used=len(recipe.get("usedIngredients",[]))
    missed=len(recipe.get("missedIngredients",[]))
    total=used+missed

    if total==0:
        return 0

    return used/total

def time_score(recipe_time,time_available):
    if not time_available or not recipe_time:
        return 0

    recipe_time=int(recipe_time)
    time_available=int(time_available)

    if recipe_time>time_available:
        return 0

    return 1-(recipe_time/time_available)

def calorie_score(recipe_calories,calorie_goal):
    if not calorie_goal or not recipe_calories:
        return 0

    calorie_goal=int(calorie_goal)
    diff=abs(recipe_calories-calorie_goal)

    score=max(0,1-diff/calorie_goal)

    return score

def cuisine_score(recipe_cuisines,preferred_cuisine):
    if not preferred_cuisine:
        return 0

    preferred_cuisine=preferred_cuisine.lower()

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

    recipe_set=set(recipe.get("ingredients",[]))
    best_score=0

    for past in history:
        past_set=set(past.get("ingredients",[]))

        intersection=recipe_set.intersection(past_set)
        union=recipe_set.union(past_set)

        if len(union)==0:
            continue

        similarity=len(intersection)/len(union)
        best_score=max(best_score,similarity)

    return best_score

def score_recipe(recipe,
                 pantry,
                 user_preferences,
                 history,
                 favorites,
                 ingredient_sim):

    score=0

    coverage=ingredient_coverage(recipe)
    score+=4*coverage

    score+=2*ingredient_sim

    score+=1.5*time_score(
        recipe.get("cook_time"),
        user_preferences.get("time_available")
    )

    score+=1.5*calorie_score(
        recipe.get("calories"),
        user_preferences.get("calorie_goal")
    )

    score+=cuisine_score(
        recipe.get("cuisines",[]),
        user_preferences.get("cuisine_preference")
    )

    score+=favorite_boost(recipe.get("id"),favorites)

    score+=1.5*history_similarity(recipe,history)

    return score

def rank_recipes(recipes,
                 pantry_ingredients,
                 user_preferences,
                 history,
                 favorites):

    if not recipes:
        return []

    recipes=compute_pantry_matches(recipes,pantry_ingredients)

    similarities=ingredient_similarity(pantry_ingredients,recipes)

    scored_recipes=[]

    for i,recipe in enumerate(recipes):

        score=score_recipe(
            recipe,
            pantry_ingredients,
            user_preferences,
            history,
            favorites,
            similarities[i]
        )

        recipe["score"]=score
        scored_recipes.append(recipe)

    ranked=sorted(
        scored_recipes,
        key=lambda x:x["score"],
        reverse=True
    )

    return ranked
