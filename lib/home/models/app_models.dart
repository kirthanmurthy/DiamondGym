class RecipeData {
  const RecipeData({
    required this.name,
    required this.time,
    required this.budget,
    required this.macros,
  });

  final String name;
  final String time;
  final String budget;
  final String macros;
}

class FavoriteEntry {
  const FavoriteEntry({required this.name, required this.notes});

  final String name;
  final String notes;
}

class HistoryEntry {
  const HistoryEntry({required this.name, required this.details});

  final String name;
  final String details;
}

class ProfileData {
  const ProfileData({
    required this.name,
    required this.restrictions,
    required this.height,
    required this.weight,
  });

  const ProfileData.empty()
    : name = '',
      restrictions = '',
      height = '',
      weight = '';

  final String name;
  final String restrictions;
  final String height;
  final String weight;

  bool get isEmpty {
    return name.isEmpty &&
        restrictions.isEmpty &&
        height.isEmpty &&
        weight.isEmpty;
  }
}
