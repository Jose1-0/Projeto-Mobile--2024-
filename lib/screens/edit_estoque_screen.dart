import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/estoque.dart';
import 'package:meu_estoque_app/services/estoque_service.dart';

class EditEstoqueScreen extends StatefulWidget {
  final Estoque estoque;

  EditEstoqueScreen({required this.estoque});

  @override
  _EditEstoqueScreenState createState() => _EditEstoqueScreenState();
}

class _EditEstoqueScreenState extends State<EditEstoqueScreen> {
  final EstoqueService _estoqueService = EstoqueService();
  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.estoque.nome);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _updateEstoque() async {
    final updatedEstoque = Estoque(
      id: widget.estoque.id,
      nome: _nomeController.text,
      dataCriacao: widget.estoque.dataCriacao,
      dataAtualizacao: DateTime.now().toIso8601String(),
    );
    await _estoqueService.updateEstoque(updatedEstoque);
    Navigator.pop(
        context, true); // Retorna true para indicar que a edição foi concluída
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEstoque,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
