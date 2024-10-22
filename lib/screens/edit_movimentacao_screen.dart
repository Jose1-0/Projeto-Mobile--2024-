import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/movimentacao.dart';
import 'package:meu_estoque_app/services/movimentacao_service.dart';

class EditMovimentacaoScreen extends StatefulWidget {
  final Movimentacao movimentacao;

  EditMovimentacaoScreen({required this.movimentacao});

  @override
  _EditMovimentacaoScreenState createState() => _EditMovimentacaoScreenState();
}

class _EditMovimentacaoScreenState extends State<EditMovimentacaoScreen> {
  final MovimentacaoService _movimentacaoService = MovimentacaoService();
  late TextEditingController _quantidadeController;
  late TextEditingController _valorTotalController;
  late String _tipoMovimentacao;

  @override
  void initState() {
    super.initState();
    _quantidadeController =
        TextEditingController(text: widget.movimentacao.quantidade.toString());
    _valorTotalController =
        TextEditingController(text: widget.movimentacao.valorTotal.toString());
    _tipoMovimentacao = widget.movimentacao.tipoMovimentacao;
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _valorTotalController.dispose();
    super.dispose();
  }

  Future<void> _updateMovimentacao() async {
    final updatedMovimentacao = Movimentacao(
      id: widget.movimentacao.id,
      idProduto: widget.movimentacao.idProduto,
      tipoMovimentacao: _tipoMovimentacao,
      quantidade: int.parse(_quantidadeController.text),
      dataMovimentacao: widget.movimentacao.dataMovimentacao,
      valorTotal: double.parse(_valorTotalController.text),
    );
    await _movimentacaoService.updateMovimentacao(updatedMovimentacao);
    Navigator.pop(context, true); // Retorna true para indicar que a edição foi concluída
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Movimentação',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple, // Cor do AppBar
        centerTitle: true, // Centraliza o título
        elevation: 4, // Sombra
        iconTheme: const IconThemeData(color: Colors.white), // Ícone da seta de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _tipoMovimentacao,
              items: ['entrada', 'saida'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _tipoMovimentacao = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'Tipo de Movimentação'),
            ),
            const SizedBox(height: 16), // Espaçamento
            TextField(
              controller: _quantidadeController,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16), // Espaçamento
            TextField(
              controller: _valorTotalController,
              decoration: const InputDecoration(
                labelText: 'Valor Total',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20), // Espaçamento antes do botão
            ElevatedButton.icon(
              onPressed: _updateMovimentacao,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Salvar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Cor do texto do botão
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Cor do botão
                minimumSize: const Size(double.infinity, 50), // Largura máxima
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
