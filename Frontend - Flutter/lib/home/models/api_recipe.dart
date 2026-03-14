class ApiRecipe {
  const ApiRecipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.cuisines,
    required this.image,
    required this.time,
    required this.calories,
    required this.score,
    required this.steps,
  });

  final int? id;
  final String title;
  final List<String> ingredients;
  final List<String> cuisines;
  final String image;
  final int? time;
  final int? calories;
  final double score;
  final List<String> steps;

  factory ApiRecipe.fromMap(Map<String, dynamic> map) {
    final rawSteps = map['steps'] as List<dynamic>? ?? [];

    return ApiRecipe(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      ingredients: (map['ingredients'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      cuisines: (map['cuisines'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      image: map['image'] as String? ?? '',
      time: map['readyInMinutes'] as int?,
      calories: map['calories'] as int?,
      score: (map['score'] as num?)?.toDouble() ?? 0,
      steps: rawSteps.map((item) => item.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'cuisines': cuisines,
      'image': image,
      'readyInMinutes': time,
      'calories': calories,
      'score': score,
      'steps': steps,
    };
  }
}
