import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import '../viewmodel/fetchpokemon.dart';
import 'pokemon_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController =
  TextEditingController();

  late Future<List<Pokemon>> pokemonFuture;
  String searchQuery = '';

  static const List<Color> cardColors = [
    Color(0xFFFFE0E6),
    Color(0xFFDDF4FF),
    Color(0xFFE5F5DA),
    Color(0xFFFFEBC8),
    Color(0xFFEAE2FF),
    Color(0xFFFFE5CD),
  ];

  @override
  void initState() {
    super.initState();
    pokemonFuture = FetchPokemon.fetchPokemonList();
  }

  void retryLoading() {
    setState(() {
      pokemonFuture = FetchPokemon.fetchPokemonList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC345A),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.catching_pokemon, size: 30),
            SizedBox(width: 8),
            Text(
              'PokéDex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            decoration: const BoxDecoration(
              color: Color(0xFFDC345A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Temukan Pokémon Favoritmu!',
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Jelajahi 151 Pokémon generasi pertama.',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Pokémon...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: 'Hapus pencarian',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Pokémon',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pokemon>>(
              future: pokemonFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
                            Icons.wifi_off,
                            size: 50,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat Pokémon.\n'
                                '${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: retryLoading,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final allPokemon = snapshot.data ?? [];

                final filteredPokemon = allPokemon.where((pokemon) {
                  return pokemon.name.contains(searchQuery) ||
                      pokemon.id.toString() == searchQuery;
                }).toList();

                if (filteredPokemon.isEmpty) {
                  return const Center(
                    child: Text('Pokémon tidak ditemukan.'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: filteredPokemon.length,
                  itemBuilder: (context, index) {
                    final pokemon = filteredPokemon[index];
                    final cardColor = cardColors[
                    pokemon.id % cardColors.length];

                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PokemonDetailPage(
                              pokemon: pokemon,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '#${pokemon.id.toString().padLeft(3, '0')}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Image.network(
                                pokemon.imageUrl,
                                fit: BoxFit.contain,
                                loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                    ) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }

                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                                errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {
                                  return const Icon(
                                    Icons.catching_pokemon,
                                    size: 70,
                                    color: Colors.black38,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pokemon.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Lihat detail',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}