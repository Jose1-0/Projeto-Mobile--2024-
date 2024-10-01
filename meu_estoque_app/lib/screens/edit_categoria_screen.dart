import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/categoria.dart';
import 'package:meu_estoque_app/services/categoria_service.dart';

class EditCategoriaScreen extends StatefulWidget {
  final Categoria categoria;

  EditCategoriaScreen({required this.categoria});

  @override
  _EditCategoriaScreenState createState() => _EditCategoriaScreenState();
}

class _EditCategoriaScreenState extends State<EditCategoriaScreen> {
  final CategoriaService _categoriaService = CategoriaService();
  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.categoria.nome);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _updateCategoria() async {
    final updatedCategoria = Categoria(
      id: widget.categoria.id,
      nome: _nomeController.text,
    );
    await _categoriaService.updateCategoria(updatedCategoria);
    Navigator.pop(
        context, true); // Retorna true para indicar que a edição foi concluída
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Categoria'),
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
              onPressed: _updateCategoria,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
