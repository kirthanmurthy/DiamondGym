import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_query.dart';
import '../models/api_recipe.dart';

class ApiClient {
  ApiClient({required this.baseUrl});

  final String baseUrl;

  Future<List<ApiRecipe>> search(ApiQuery query) async {
    final uri = Uri.parse(
      '$baseUrl/search',
    ).replace(queryParameters: query.toMap());

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Request failed');
    }

    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((item) => ApiRecipe.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addPantryItem(String ingredient) async {
    final uri = Uri.parse('$baseUrl/pantry/add');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ingredient': ingredient}),
    );

    if (res.statusCode != 200) {
      throw Exception('Unable to save pantry item');
    }
  }

  Future<void> saveFavorite(ApiRecipe recipe) async {
    final uri = Uri.parse('$baseUrl/favorites');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toMap()),
    );

    if (res.statusCode != 200) {
      throw Exception('Unable to save favorite');
    }
  }

  Future<void> removeFavorite(int recipeId) async {
    final uri = Uri.parse('$baseUrl/favorites/$recipeId');
    final res = await http.delete(uri);

    if (res.statusCode != 200) {
      throw Exception('Unable to remove favorite');
    }
  }

  Future<void> selectRecipe(ApiRecipe recipe) async {
    final uri = Uri.parse('$baseUrl/recipes/select');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toMap()),
    );

    if (res.statusCode != 200) {
      throw Exception('Unable to select recipe');
    }
  }
}
