class Estoque {
  final int? id;
  final String nome;
  final String dataCriacao;
  final String dataAtualizacao;

  Estoque({
    this.id,
    required this.nome,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  factory Estoque.fromMap(Map<String, dynamic> json) => Estoque(
    id: json['id_estoque'],
    nome: json['nome'],
    dataCriacao: json['data_criacao'],
    dataAtualizacao: json['data_atualizacao'],
  );

  Map<String, dynamic> toMap() => {
    'id_estoque': id,
    'nome': nome,
    'data_criacao': dataCriacao,
    'data_atualizacao': dataAtualizacao,
  };
}
