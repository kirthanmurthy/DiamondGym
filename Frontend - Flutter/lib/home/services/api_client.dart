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
      final body = res.body.trim();
      throw Exception(body.isEmpty ? 'Request failed' : body);
    }

    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((item) => ApiRecipe.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
