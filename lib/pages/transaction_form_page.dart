import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizze/models/transaction_enum.dart';
import 'package:organizze/models/transaction_model.dart';
import 'package:organizze/providers/transactions_provider.dart';
import 'package:provider/provider.dart';

class TransactionFormPage extends StatefulWidget {
  final bool _isUpdate;
  final TransactionModel _transaction;

  TransactionFormPage({Key? key, Object? transaction})
      : _transaction = transaction != null ? transaction as TransactionModel : TransactionModel.empty(),
        _isUpdate = transaction != null,
        super(key: key);

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState(_transaction, _isUpdate);
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  var _categories = [
    {'id': 0, 'title': 'Salário'},
    {'id': 1, 'title': 'Moradia'},
    {'id': 2, 'title': 'Lazer'},
  ];

  var _isUpdate;
  var _typeSelection;
  var _descriptionController;
  var _categorySelected;
  var _datetime;
  var _valueController;

  _TransactionFormPageState(TransactionModel _transaction, bool _isUpdate) {
    this._isUpdate = _isUpdate;
    _typeSelection = _transaction.type == TransactionType.EXPENSE ? [true, false] : [false, true];
    _descriptionController = TextEditingController(text: _transaction.title);
    _categorySelected = _transaction.description.isNotEmpty ? _categories.indexWhere((item) => item['title'] == _transaction.description) : null;
    _datetime = _transaction.date;
    _valueController = TextEditingController(text: _transaction.value > 0 ? _transaction.value.toString() : '');
  }

  _onSaveClicked() {
    Provider.of<TransactionsProvider>(context, listen: false).addItem(
      TransactionModel(
        _datetime,
        _typeSelection[0] ? TransactionType.EXPENSE : TransactionType.INCOME,
        _descriptionController.text,
        _categories[_categorySelected]['title'].toString(),
        double.parse(_valueController.text),
        false,
      ),
    );
    Navigator.pop(context);
  }

  _onUpdateClicked() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                        color: Colors.red.withOpacity(_typeSelection[0] ? 1 : .5),
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                      ),
                      Container(
                        child: Text('Receita', style: TextStyle(color: Colors.white)),
                        color: Colors.green.withOpacity(_typeSelection[1] ? 1 : .5),
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                      ),
                    ],
                    isSelected: _typeSelection,
                    onPressed: (index) {
                      setState(() {
                        _typeSelection.fillRange(0, _typeSelection.length, false);
                        _typeSelection[index] = true;
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
                  child: _isUpdate
                      ? ElevatedButton(
                          onPressed: _onUpdateClicked,
                          child: Text('Atualizar'),
                        )
                      : ElevatedButton(
                          onPressed: _onSaveClicked,
                          child: Text('Adicionar'),
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
