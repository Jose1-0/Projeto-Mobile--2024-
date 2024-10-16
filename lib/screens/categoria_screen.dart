import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/categoria.dart';
import 'package:meu_estoque_app/services/categoria_service.dart';
import 'edit_categoria_screen.dart'; // Import da tela de edição

class CategoriaScreen extends StatefulWidget {
  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaService _categoriaService = CategoriaService();
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    final categorias = await _categoriaService.getCategorias();
    setState(() {
      _categorias = categorias;
    });
  }

  void _navigateToEditScreen(Categoria categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditCategoriaScreen(categoria: categoria)),
    ).then((value) {
      if (value != null && value == true) {
        _fetchCategorias(); // Atualiza a lista após editar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await _categoriaService
                  .createCategoria(Categoria(nome: 'Nova Categoria'));
              _fetchCategorias();
            },
            child: Text('Adicionar Categoria'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                return ListTile(
                  title: Text(categoria.nome),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditScreen(categoria);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _categoriaService
                              .deleteCategoria(categoria.id!);
                          _fetchCategorias();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
