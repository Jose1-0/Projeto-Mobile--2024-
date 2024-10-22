import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/estoque.dart';
import 'package:meu_estoque_app/services/estoque_service.dart';
import 'edit_estoque_screen.dart';
import 'produto_screen.dart'; // Importar a tela de produtos

class EstoqueScreen extends StatefulWidget {
  @override
  _EstoqueScreenState createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  final EstoqueService _estoqueService = EstoqueService();
  List<Estoque> _estoques = [];

  @override
  void initState() {
    super.initState();
    _fetchEstoques();
  }

  Future<void> _fetchEstoques() async {
    final estoques = await _estoqueService.getEstoques();
    setState(() {
      _estoques = estoques;
    });
  }

  void _navigateToEditScreen(Estoque estoque) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditEstoqueScreen(estoque: estoque)),
    ).then((value) {
      if (value != null && value == true) {
        _fetchEstoques(); // Atualiza a lista após editar
      }
    });
  }

  void _navigateToProdutoScreen(Estoque estoque) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProdutoScreen(estoque: estoque)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estoques',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final currentDateTime = DateTime.now().toIso8601String();
                await _estoqueService.createEstoque(
                  Estoque(
                    nome: 'Novo Estoque',
                    dataCriacao: currentDateTime,
                    dataAtualizacao: currentDateTime,
                  ),
                );
                _fetchEstoques();
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Adicionar Estoque',
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
            const SizedBox(height: 20),
            Expanded(
              child: _estoques.isNotEmpty
                  ? ListView.builder(
                      itemCount: _estoques.length,
                      itemBuilder: (context, index) {
                        final estoque = _estoques[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              estoque.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              _navigateToProdutoScreen(estoque);
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                  onPressed: () {
                                    _navigateToEditScreen(estoque);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _estoqueService.deleteEstoque(estoque.id!);
                                    _fetchEstoques();
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
                        'Nenhum estoque encontrado',
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
