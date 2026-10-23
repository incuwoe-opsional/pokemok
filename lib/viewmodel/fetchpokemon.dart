import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/pokemon.dart';

class FetchPokemon {
  static const Duration _timeout = Duration(seconds: 20);

  static Future<List<Pokemon>> fetchPokemonList() async {
    final uri = Uri.https(
      'pokeapi.co',
      '/api/v2/pokemon/',
      {
        'limit': '151',
        'offset': '0',
      },
    );

    try {
      final response = await http
          .get(uri)
          .timeout(_timeout);

      debugPrint('POKEMON LIST STATUS: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil daftar Pokémon: '
              'HTTP ${response.statusCode}',
        );
      }

      final data =
      jsonDecode(response.body) as Map<String, dynamic>;

      final results = data['results'] as List? ?? [];

      final pokemonList = results
          .whereType<Map<String, dynamic>>()
          .map((item) => Pokemon.fromJson(item))
          .where((pokemon) => pokemon.id > 0)
          .toList();

      debugPrint('JUMLAH POKEMON: ${pokemonList.length}');

      return pokemonList;
    } catch (e) {
      debugPrint('ERROR POKEMON LIST: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchPokemonDetail(
      int id,
      ) async {
    final uri = Uri.https(
      'pokeapi.co',
      '/api/v2/pokemon/$id/',
    );

    final response = await http
        .get(uri)
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil detail Pokémon: '
            'HTTP ${response.statusCode}',
      );
    }

    return jsonDecode(response.body)
    as Map<String, dynamic>;
  }
}