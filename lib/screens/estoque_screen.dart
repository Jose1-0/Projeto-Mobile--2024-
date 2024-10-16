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
        title: Text('Estoques'),
      ),
      body: Column(
        children: [
          ElevatedButton(
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
            child: Text('Adicionar Estoque'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _estoques.length,
              itemBuilder: (context, index) {
                final estoque = _estoques[index];
                return ListTile(
                  title: Text(estoque.nome),
                  onTap: () {
                    _navigateToProdutoScreen(estoque);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditScreen(estoque);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _estoqueService.deleteEstoque(estoque.id!);
                          _fetchEstoques();
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
