class Categoria {
  final int? id;
  final String nome;

  Categoria({this.id, required this.nome});

  factory Categoria.fromMap(Map<String, dynamic> json) => Categoria(
        id: json['id_categoria'],
        nome: json['nome'],
      );

  Map<String, dynamic> toMap() => {
        'id_categoria': id,
        'nome': nome,
      };
} // cometario pika
