import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import '../viewmodel/fetchpokemon.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({
    super.key,
    required this.pokemon,
  });

  @override
  State<PokemonDetailPage> createState() =>
      _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late Future<Map<String, dynamic>> detailFuture;

  @override
  void initState() {
    super.initState();
    detailFuture = FetchPokemon.fetchPokemonDetail(
      widget.pokemon.id,
    );
  }

  String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget infoCard(String label, String value, IconData icon) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF7F8FC),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFDC345A), size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statRow(Map<String, dynamic> item) {
    final statInfo =
        item['stat'] as Map<String, dynamic>? ?? {};
    final statName = capitalize(
      (statInfo['name'] ?? 'Stat').toString().replaceAll('-', ' '),
    );
    final baseStat = item['base_stat'] as num? ?? 0;
    final progress =
    (baseStat.toDouble() / 150).clamp(0.0, 1.0).toDouble();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(statName),
              Text(
                '$baseStat',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFFDC345A),
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: Text(widget.pokemon.displayName),
        backgroundColor: const Color(0xFFDC345A),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFDC345A),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat detail Pokémon.\n'
                          '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          detailFuture =
                              FetchPokemon.fetchPokemonDetail(
                                widget.pokemon.id,
                              );
                        });
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Data Pokémon tidak tersedia.'),
            );
          }

          final data = snapshot.data!;
          final sprites =
              data['sprites'] as Map<String, dynamic>? ?? {};
          final other =
              sprites['other'] as Map<String, dynamic>? ?? {};
          final artwork =
              other['official-artwork'] as Map<String, dynamic>? ?? {};

          final imageUrl =
          artwork['front_default']?.toString().isNotEmpty == true
              ? artwork['front_default'].toString()
              : widget.pokemon.imageUrl;

          final typeItems = data['types'] as List? ?? [];
          final typeNames = typeItems.map((item) {
            final map = item as Map<String, dynamic>;
            final type = map['type'] as Map<String, dynamic>? ?? {};
            return capitalize((type['name'] ?? '').toString());
          }).toList();

          final abilityItems = data['abilities'] as List? ?? [];
          final abilities = abilityItems.map((item) {
            final map = item as Map<String, dynamic>;
            final ability =
                map['ability'] as Map<String, dynamic>? ?? {};
            return capitalize((ability['name'] ?? '').toString());
          }).join(', ');

          final stats = data['stats'] as List? ?? [];
          final height = (data['height'] as num? ?? 0) / 10;
          final weight = (data['weight'] as num? ?? 0) / 10;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0E6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '#${widget.pokemon.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.network(
                        imageUrl,
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 220,
                            child: Icon(
                              Icons.catching_pokemon,
                              size: 100,
                              color: Colors.black38,
                            ),
                          );
                        },
                      ),
                      Text(
                        capitalize(
                          (data['name'] ?? widget.pokemon.name).toString(),
                        ),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: typeNames.map((type) {
                          return Chip(
                            label: Text(
                              type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFFDC345A),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Informasi Pokémon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: infoCard(
                        'Tinggi',
                        '${height.toStringAsFixed(1)} m',
                        Icons.height,
                      ),
                    ),
                    Expanded(
                      child: infoCard(
                        'Berat',
                        '${weight.toStringAsFixed(1)} kg',
                        Icons.monitor_weight_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kemampuan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      abilities.isEmpty
                          ? 'Data kemampuan tidak tersedia.'
                          : abilities,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Statistik Dasar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: stats.map((item) {
                        return statRow(
                          item as Map<String, dynamic>,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}