import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizze/models/transaction_enum.dart';
import 'package:organizze/models/transaction_model.dart';
import 'package:organizze/providers/transactions_provider.dart';
import 'package:provider/provider.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({Key? key}) : super(key: key);

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _categories = [
    {'id': 0, 'title': 'Salário'},
    {'id': 1, 'title': 'Moradia'},
    {'id': 2, 'title': 'Lazer'},
  ];

  TransactionModel? _transactionModel;
  final _transactionTypeSelection = [true, false];
  final _descriptionController = TextEditingController(text: '');
  var _categorySelected;
  DateTime _datetime = DateTime.now();
  final _valueController = TextEditingController(text: '');

  _onSaveClicked() {
    var transactionType = (_transactionTypeSelection[0]) ? TransactionType.EXPENSE : TransactionType.INCOME;
    String category = _categories[_categorySelected]['title'].toString();

    Provider.of<TransactionsProvider>(context, listen: false).addItem(
      TransactionModel(
        _datetime,
        transactionType,
        _descriptionController.text,
        category,
        double.parse(_valueController.text),
        false,
      ),
    );
    Navigator.pop(context);
  }

  _onUpdateClicked() {
    if (_transactionModel != null) {
      _transactionModel!.type = (_transactionTypeSelection[0]) ? TransactionType.EXPENSE : TransactionType.INCOME;
      _transactionModel!.date = _datetime;
      _transactionModel!.title = _descriptionController.text;
      _transactionModel!.description = _categories[_categorySelected]['title'].toString();
      _transactionModel!.value = double.parse(_valueController.text);
      Provider.of<TransactionsProvider>(context, listen: false).updateItem(_transactionModel!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Object? argModel = ModalRoute.of(context)!.settings.arguments;
    if (argModel != null) {
      _transactionModel = argModel as TransactionModel;
      _transactionTypeSelection.fillRange(0, _transactionTypeSelection.length, false);
      _transactionTypeSelection[_transactionModel!.type == TransactionType.EXPENSE ? 0 : 1] = true;
      _datetime = _transactionModel!.date;
      _descriptionController.text = _transactionModel!.title;
      _categorySelected = _categories.indexWhere((item) => item['title'] == _transactionModel!.description);
      _valueController.text = _transactionModel!.value.toStringAsFixed(0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Lançamento'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  return ToggleButtons(
                    children: [
                      Container(
                        child: Text('Despesa', style: TextStyle(color: Colors.white)),
                        color: Colors.red.withOpacity(_transactionTypeSelection[0] ? 1 : .5),
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                      ),
                      Container(
                        child: Text('Receita', style: TextStyle(color: Colors.white)),
                        color: Colors.green.withOpacity(_transactionTypeSelection[1] ? 1 : .5),
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                      ),
                    ],
                    isSelected: _transactionTypeSelection,
                    onPressed: (index) {
                      setState(() {
                        _transactionTypeSelection.fillRange(0, _transactionTypeSelection.length, false);
                        _transactionTypeSelection[index] = true;
                      });
                    },
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth / 2,
                      maxWidth: constraints.maxWidth / 2,
                      minHeight: 40,
                      maxHeight: 40,
                    ),
                    renderBorder: false,
                    borderRadius: BorderRadius.circular(5),
                  );
                }),
                SizedBox(height: 20),
                Text('Data'),
                Container(
                  height: 40,
                  width: double.infinity,
                  child: OutlinedButton(
                    child: Text(DateFormat('dd/MM/yyyy').format(_datetime)),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: _datetime,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      ).then((date) {
                        if (date != null) setState(() => _datetime = date);
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!.withOpacity(1), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Descrição'),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!.withOpacity(1), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!.withOpacity(1), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                    constraints: BoxConstraints.loose(Size(double.infinity, 40)),
                  ),
                ),
                SizedBox(height: 20),
                Text('Categoria'),
                Container(
                  height: 40,
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!.withOpacity(1), width: 2), borderRadius: BorderRadius.circular(5.0)),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        isExpanded: true,
                        isDense: true,
                        value: _categorySelected,
                        items: [
                          ..._categories.map((item) {
                            return DropdownMenuItem(child: Text(item['title'].toString()), value: item['id']);
                          })
                        ],
                        onChanged: (value) => setState(() => _categorySelected = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Valor'),
                TextField(
                  controller: _valueController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!.withOpacity(1), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!.withOpacity(1), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                    constraints: BoxConstraints.loose(Size(double.infinity, 40)),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 40,
                  width: double.infinity,
                  child: (argModel == null)
                      ? ElevatedButton(
                          onPressed: _onSaveClicked,
                          child: Text('Adicionar'),
                        )
                      : ElevatedButton(
                          onPressed: _onUpdateClicked,
                          child: Text('Atualizar'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
