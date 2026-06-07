class PrestadorFoto {
  final int id;
  final String url;

  const PrestadorFoto({required this.id, required this.url});

  factory PrestadorFoto.fromJson(Map<String, dynamic> json) {
    return PrestadorFoto(
      id: json['id'] as int,
      url: json['url'] as String,
    );
  }
}
