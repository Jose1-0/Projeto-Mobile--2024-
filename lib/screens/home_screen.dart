import 'package:flutter/material.dart';
import 'categoria_screen.dart';
import 'estoque_screen.dart';
import 'movimentacao_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestão de Estoque',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple, // Cor de fundo do AppBar
        centerTitle: true, // Centraliza o título
        elevation: 4, // Sombra no AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Ícones brancos
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EstoqueScreen()),
                  );
                },
                icon: const Icon(Icons.inventory, color: Colors.white), // Ícone de estoque
                label: const Text(
                  'Estoques',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Cor do botão
                  minimumSize: const Size(double.infinity, 50), // Botão largura máxima
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaçamento entre botões
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoriaScreen()),
                  );
                },
                icon: const Icon(Icons.category, color: Colors.white), // Ícone de categorias
                label: const Text(
                  'Categorias',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Cor do botão
                  minimumSize: const Size(double.infinity, 50), // Largura máxima
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaçamento entre botões
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MovimentacaoScreen()),
                  );
                },
                icon: const Icon(Icons.swap_horiz, color: Colors.white), // Ícone de movimentações
                label: const Text(
                  'Movimentações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Cor do botão
                  minimumSize: const Size(double.infinity, 50), // Largura máxima
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
