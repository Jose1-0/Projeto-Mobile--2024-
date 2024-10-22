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
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Categoria',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple, // Cor do AppBar
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.deepPurple), // Cor do label
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCategoria,
              child: const Text(
                'Salvar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
