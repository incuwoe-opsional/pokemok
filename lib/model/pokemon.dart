class Pokemon {
  final int id;
  final String name;
  final String url;

  const Pokemon({
    required this.id,
    required this.name,
    required this.url,
  });

  String get displayName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/'
          'sprites/pokemon/other/official-artwork/$id.png';

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = (json['url'] ?? '').toString();
    final parts = url
        .split('/')
        .where((part) => part.isNotEmpty)
        .toList();

    final id = parts.isNotEmpty
        ? int.tryParse(parts.last) ?? 0
        : 0;

    return Pokemon(
      id: id,
      name: (json['name'] ?? 'unknown').toString(),
      url: url,
    );
  }
}