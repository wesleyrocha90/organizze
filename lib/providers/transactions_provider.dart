import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:organizze/models/transaction_enum.dart';
import 'package:organizze/models/transaction_model.dart';

class TransactionsProvider extends ChangeNotifier {
  final List<TransactionModel> _transactions = [
    TransactionModel(DateTime.now(), TransactionType.INCOME, 'Salário', 'Salário', 3233.0, true),
    TransactionModel(DateTime.now(), TransactionType.EXPENSE, 'Casa', 'Moradia', 110.0, true),
    TransactionModel(DateTime.now(), TransactionType.EXPENSE, 'Internet', 'Lazer', 99.99, false),
  ];

  UnmodifiableListView<TransactionModel> get transactions => UnmodifiableListView(_transactions);

  void addItem(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void updateItem(TransactionModel transaction) {
    _transactions.removeWhere((item) => item.uuid == transaction.uuid);
    _transactions.add(transaction);
    notifyListeners();
  }

  void deleteItem(TransactionModel transaction) {
    _transactions.remove(transaction);
    notifyListeners();
  }

  void updateIsDone(TransactionModel transaction, bool newIsDone) {
    _transactions.forEach((element) {
      if (element.uuid == transaction.uuid) element.isDone = newIsDone;
    });
    notifyListeners();
  }

  double foreseeBalance() {
    return _transactions.fold<double>(0.0, (value, element) {
      return (element.type == TransactionType.INCOME) ? value + element.value : value - element.value;
    });
  }

  double actualBalance() {
    return _transactions.where((item) => item.isDone).fold<double>(0.0, (value, element) {
      return (element.type == TransactionType.INCOME) ? value + element.value : value - element.value;
    });
  }
}