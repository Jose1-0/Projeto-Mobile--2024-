import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meu_estoque_app/models/produto.dart';
import 'package:meu_estoque_app/services/produto_service.dart';
import 'package:intl/intl.dart';

class EditProdutoScreen extends StatefulWidget {
  final Produto produto;

  EditProdutoScreen({required this.produto});

  @override
  _EditProdutoScreenState createState() => _EditProdutoScreenState();
}

class _EditProdutoScreenState extends State<EditProdutoScreen> {
  final ProdutoService _produtoService = ProdutoService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _precoController;
  late TextEditingController _quantidadeController;
  late TextEditingController _codigoBarrasController;
  late TextEditingController _quantidadeMinimaController;
  late TextEditingController _dataValidadeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto.nome);
    _quantidadeController =
        TextEditingController(text: widget.produto.quantidade.toString());
    _quantidadeMinimaController =
        TextEditingController(text: widget.produto.quantidadeMinima.toString());
    _codigoBarrasController =
        TextEditingController(text: widget.produto.codigoBarras);
    _precoController = TextEditingController(
        text: widget.produto.valorPago != null
            ? _formatCurrency(widget.produto.valorPago!)
            : 'R\$ 0,00');
    _dataValidadeController =
        TextEditingController(text: widget.produto.dataValidade ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    _quantidadeMinimaController.dispose();
    _codigoBarrasController.dispose();
    _precoController.dispose();
    _dataValidadeController.dispose();
    super.dispose();
  }

  String _formatCurrency(double value) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatter.format(value);
  }

  Future<void> _updateProduto() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProduto = Produto(
        id: widget.produto.id,
        idEstoque: widget.produto.idEstoque,
        codigoBarras: _codigoBarrasController.text,
        nome: _nomeController.text,
        quantidade: int.parse(_quantidadeController.text),
        quantidadeMinima: int.parse(_quantidadeMinimaController.text),
        dataValidade: _dataValidadeController.text.isNotEmpty
            ? _dataValidadeController.text
            : null,
        dataCadastro: widget.produto.dataCadastro,
        valorPago: double.parse(
                _precoController.text.replaceAll(RegExp(r'[^\d]'), '')) /
            100,
      );
      await _produtoService.updateProduto(updatedProduto);
      Navigator.pop(context,
          true); // Retorna true para indicar que a edição foi concluída
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem certeza que deseja salvar as alterações?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateProduto();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _codigoBarrasController,
                decoration: InputDecoration(labelText: 'Código de Barras'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o código de barras';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null) {
                    return 'Por favor, insira um número válido';
                  }
                  if (intValue < 0) {
                    return 'A quantidade não pode ser negativa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantidadeMinimaController,
                decoration: InputDecoration(labelText: 'Quantidade Mínima'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade mínima';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null) {
                    return 'Por favor, insira um número válido';
                  }
                  if (intValue < 0) {
                    return 'A quantidade mínima não pode ser negativa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(
                  labelText: 'Valor Pago',
                  hintText: 'R\$ 0,00',
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor pago';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataValidadeController,
                decoration: InputDecoration(
                  labelText: 'Data de Validade',
                  hintText: 'DD/MM/YYYY',
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                        _dataValidadeController.text = formattedDate;
                      }
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                  DateInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de validade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showConfirmationDialog();
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length > 10) return oldValue; // Limita a 10 caracteres
    final buffer = StringBuffer();
    var count = 0;
    for (int i = 0; i < text.length; i++) {
      if (count == 2 || count == 4) {
        buffer.write('/');
      }
      buffer.write(text[i]);
      count++;
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (newText.isEmpty) {
      newText = '0';
    }
    double value = double.parse(newText);
    final formatter =
        NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);
    String newFormattedText = formatter.format(value / 100);
    return TextEditingValue(
      text: newFormattedText,
      selection: TextSelection.collapsed(offset: newFormattedText.length),
    );
  }
}
