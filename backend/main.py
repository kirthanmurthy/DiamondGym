from api.spoonacular_api import get_clean_recipes
from ranking.ranking_engine import rank_recipes
from user.user_profile import update_profile, load_profile
from pantry.pantry_manager import load_pantry, add_ingredient, remove_ingredient
from history.history_manager import add_to_history, get_history

def setup_user():
    update_profile(
        name="John",
        age=25,
        weight=180,
        height_cm=178,
        diet="vegetarian",
        intolerances=[],
        preferred_cuisines=["indian","italian","asian"]
    )

    profile=load_profile()

    print("\nUser profile loaded:")
    print(profile)

    return profile

def setup_pantry():
    pantry_items=[
        "pasta","garlic","tomato","olive oil",
        "onion","spinach","cheese","mushroom",
        "bell pepper","basil","rice","beans",
        "potato","carrot"
    ]

    for item in pantry_items:
        add_ingredient(item)

    pantry=load_pantry()

    print("\nPantry loaded:")
    print(pantry)

    return pantry

def run_recommendation(profile,pantry):
    user_preferences={
        "time_available":60,
        "calorie_goal":600,
        "cuisine_preference":",".join(profile.get("preferred_cuisines",[]))
    }

    history=get_history()
    favorites=[]

    print("\nFetching recipes from API...\n")

    recipes=get_clean_recipes(
        diet=profile.get("diet"),
        intolerances=profile.get("intolerances"),
        cuisine_preference=user_preferences["cuisine_preference"],
        time_available=user_preferences["time_available"],
        number=40
    )

    if len(recipes)<10:
        print("Few recipes found. Relaxing cuisine filter...")
        recipes+=get_clean_recipes(
            diet=profile.get("diet"),
            intolerances=profile.get("intolerances"),
            time_available=user_preferences["time_available"],
            number=40
        )

    if len(recipes)<10:
        print("Still few recipes. Relaxing time filter...")
        recipes+=get_clean_recipes(
            diet=profile.get("diet"),
            intolerances=profile.get("intolerances"),
            number=40
        )

    if len(recipes)<10:
        print("Still few recipes. Expanding search further...")
        recipes+=get_clean_recipes(
            number=40
        )

    unique={}
    for r in recipes:
        unique[r["id"]]=r

    recipes=list(unique.values())

    print("Recipes retrieved:",len(recipes))

    ranked=rank_recipes(
        recipes,
        pantry["ingredients"],
        user_preferences,
        history,
        favorites
    )

    print("\nTop 10 Recommendations:\n")

    for i,r in enumerate(ranked[:10], start=1):
        cuisines=r.get("cuisines",[])
        cuisines=", ".join(cuisines) if cuisines else "Unknown"

        print(
            i,"|",
            r["title"],"|",
            r["cook_time"],"min |",
            r["calories"],"cal |",
            cuisines,"| score:",
            round(r["score"],3)
        )

    return ranked

def simulate_recipe_selection(ranked):
    choice=int(input("\nSelect recipe number to cook: "))

    selected=ranked[choice-1]

    print("\nCooking:",selected["title"])

    add_to_history(selected)

    used=selected.get("usedIngredients",[])

    for ingredient in used:
        remove_ingredient(ingredient)

    print("\nPantry updated.")


def show_final_state():
    pantry=load_pantry()
    history=get_history()

    print("\nUpdated Pantry:")
    print(pantry)

    print("\nHistory:")

    for r in history:
        print("-",r["title"])


def main():
    profile=setup_user()
    pantry=setup_pantry()
    ranked=run_recommendation(profile,pantry)
    simulate_recipe_selection(ranked)
    show_final_state()


if __name__=="__main__":
    main()