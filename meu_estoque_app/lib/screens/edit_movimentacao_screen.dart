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
    Navigator.pop(
        context, true); // Retorna true para indicar que a edição foi concluída
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Movimentação'),
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
              decoration: InputDecoration(labelText: 'Tipo de Movimentação'),
            ),
            TextField(
              controller: _quantidadeController,
              decoration: InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _valorTotalController,
              decoration: InputDecoration(labelText: 'Valor Total'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateMovimentacao,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
