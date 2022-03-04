import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Lançamento'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<TransactionsProvider>(context, listen: false).addItem(
                  TransactionModel(TransactionType.EXPENSE, 'Teste', 'Teste', 31.31, false),
                );
                Navigator.pop(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
