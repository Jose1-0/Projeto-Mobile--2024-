class Produto {
  final int? id;
  final int idEstoque;
  final int? idCategoria;
  final String codigoBarras;
  final String nome;
  final int quantidade;
  final int quantidadeMinima;
  final String? dataValidade;
  final String dataCadastro;
  final double valorPago;

  Produto({
    this.id,
    required this.idEstoque,
    this.idCategoria,
    required this.codigoBarras,
    required this.nome,
    required this.quantidade,
    required this.quantidadeMinima,
    this.dataValidade,
    required this.dataCadastro,
    required this.valorPago,
  });

  factory Produto.fromMap(Map<String, dynamic> json) => Produto(
        id: json['id_produto'],
        idEstoque: json['id_estoque'],
        idCategoria: json['id_categoria'],
        codigoBarras: json['codigo_barras'],
        nome: json['nome'],
        quantidade: json['quantidade'],
        quantidadeMinima: json['quantidade_minima'],
        dataValidade: json['data_validade'],
        dataCadastro: json['data_cadastro'],
        valorPago: json['valor_pago'],
      );

  Map<String, dynamic> toMap() => {
        'id_produto': id,
        'id_estoque': idEstoque,
        'id_categoria': idCategoria,
        'codigo_barras': codigoBarras,
        'nome': nome,
        'quantidade': quantidade,
        'quantidade_minima': quantidadeMinima,
        'data_validade': dataValidade,
        'data_cadastro': dataCadastro,
        'valor_pago': valorPago,
      };
}
