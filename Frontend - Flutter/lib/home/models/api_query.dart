class ApiQuery {
  const ApiQuery({
    required this.ingredients,
    required this.restrictions,
    required this.cuisine,
    required this.time,
    required this.calories,
  });

  final String ingredients;
  final String restrictions;
  final String cuisine;
  final String time;
  final String calories;

  Map<String, String> toMap() {
    return {
      'ingredients': ingredients,
      'restrictions': restrictions,
      'cuisine_preference': cuisine,
      'time_available': time,
      'calorie_goal': calories,
    }..removeWhere((key, value) => value.trim().isEmpty);
  }
}
