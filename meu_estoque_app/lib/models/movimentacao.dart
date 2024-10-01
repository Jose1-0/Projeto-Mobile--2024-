class Movimentacao {
  final int? id;
  final int idProduto;
  final String tipoMovimentacao;
  final int quantidade;
  final String dataMovimentacao;
  final double valorTotal;

  Movimentacao({
    this.id,
    required this.idProduto,
    required this.tipoMovimentacao,
    required this.quantidade,
    required this.dataMovimentacao,
    required this.valorTotal,
  });

  factory Movimentacao.fromMap(Map<String, dynamic> json) => Movimentacao(
    id: json['id_movimentacao'],
    idProduto: json['id_produto'],
    tipoMovimentacao: json['tipo_movimentacao'],
    quantidade: json['quantidade'],
    dataMovimentacao: json['data_movimentacao'],
    valorTotal: json['valor_total'],
  );

  Map<String, dynamic> toMap() => {
    'id_movimentacao': id,
    'id_produto': idProduto,
    'tipo_movimentacao': tipoMovimentacao,
    'quantidade': quantidade,
    'data_movimentacao': dataMovimentacao,
    'valor_total': valorTotal,
  };
}
