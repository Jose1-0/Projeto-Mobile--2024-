import 'package:flutter/material.dart';
import 'categoria_screen.dart';
import 'estoque_screen.dart';
import 'movimentacao_screen.dart';
import 'produto_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Estoque'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriaScreen()),
                );
              },
              child: const Text('Categorias'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstoqueScreen()),
                );
              },
              child: const Text('Estoques'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovimentacaoScreen()),
                );
              },
              child: const Text('Movimentações'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdutoScreen()),
                );
              },
              child: const Text('Produtos'),
            ),
          ],
        ),
      ),
    );
  }
}
