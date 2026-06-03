class LoginResponse {
  final String token;
  final String tipo;
  final int id;
  final String nome;
  final String email;
  final String perfil;

  LoginResponse({
    required this.token,
    required this.tipo,
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      tipo: json['tipo'] ?? '',
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      perfil: json['perfil'] ?? '',
    );
  }
}
