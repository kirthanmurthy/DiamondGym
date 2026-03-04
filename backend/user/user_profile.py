import json

PROFILE_PATH = "data/user_profile.json"


def load_profile():
    with open(PROFILE_PATH, "r") as f:
        return json.load(f)


def save_profile(profile):
    with open(PROFILE_PATH, "w") as f:
        json.dump(profile, f, indent=4)


def update_profile(name=None,
                   age=None,
                   weight=None,
                   height_cm=None,
                   diet=None,
                   intolerances=None,
                   preferred_cuisines=None):

    profile = load_profile()

    if name:
        profile["name"] = name

    if age:
        profile["age"] = age

    if weight:
        profile["weight"] = weight

    if height_cm:
        profile["height_cm"] = height_cm

    if diet:
        profile["diet"] = diet

    if intolerances:
        profile["intolerances"] = intolerances

    if preferred_cuisines:
        profile["preferred_cuisines"] = preferred_cuisines

    save_profile(profile)