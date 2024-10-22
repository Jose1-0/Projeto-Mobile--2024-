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
        title: const Text(
          'Categorias',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Cor do AppBar
        centerTitle: true, // Centraliza o título
        elevation: 4, // Sombra
        iconTheme: const IconThemeData(color: Colors.white), // Seta de voltar branca
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                await _categoriaService
                    .createCategoria(Categoria(nome: 'Nova Categoria'));
                _fetchCategorias();
              },
              icon: const Icon(Icons.add, color: Colors.white), // Ícone de adicionar
              label: const Text(
                'Adicionar Categoria',
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
            const SizedBox(height: 20), // Espaçamento entre botão e lista
            Expanded(
              child: _categorias.isNotEmpty
                  ? ListView.builder(
                      itemCount: _categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = _categorias[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Bordas arredondadas
                          ),
                          elevation: 3, // Elevação do Card
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              categoria.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                  onPressed: () {
                                    _navigateToEditScreen(categoria);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _categoriaService
                                        .deleteCategoria(categoria.id!);
                                    _fetchCategorias();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Nenhuma categoria encontrada',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
