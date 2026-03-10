class ApiRecipe {
  const ApiRecipe({
    required this.title,
    required this.image,
    required this.time,
    required this.calories,
    required this.score,
    required this.steps,
  });

  final String title;
  final String image;
  final int? time;
  final int? calories;
  final double score;
  final List<String> steps;

  factory ApiRecipe.fromMap(Map<String, dynamic> map) {
    final rawSteps = map['steps'] as List<dynamic>? ?? [];

    return ApiRecipe(
      title: map['title'] as String? ?? '',
      image: map['image'] as String? ?? '',
      time: map['readyInMinutes'] as int?,
      calories: map['calories'] as int?,
      score: (map['score'] as num?)?.toDouble() ?? 0,
      steps: rawSteps.map((item) => item.toString()).toList(),
    );
  }
}
