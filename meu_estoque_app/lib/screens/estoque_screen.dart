import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/estoque.dart';
import 'package:meu_estoque_app/services/estoque_service.dart';
import 'edit_estoque_screen.dart';

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

  Future<void> _createEstoque() async {
    final currentDateTime = DateTime.now().toIso8601String();
    final newEstoque = Estoque(
      nome: 'Novo Estoque',
      dataCriacao: currentDateTime,
      dataAtualizacao: currentDateTime,
    );
    await _estoqueService.createEstoque(newEstoque);
    _fetchEstoques();
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
            onPressed: _createEstoque,
            child: Text('Adicionar Estoque'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _estoques.length,
              itemBuilder: (context, index) {
                final estoque = _estoques[index];
                return ListTile(
                  title: Text(estoque.nome),
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
