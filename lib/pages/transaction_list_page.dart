import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:organizze/models/transaction_enum.dart';
import 'package:organizze/models/transaction_model.dart';
import 'package:organizze/providers/transactions_provider.dart';
import 'package:provider/provider.dart';

class TransactionListPage extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    debugPrint('building');
    return Scaffold(
      appBar: AppBar(
        title: Text('Lançamentos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Consumer<TransactionsProvider>(builder: (context, value, child) {
                return Column(
                  children: [...value.transactions.map((item) => buildTransactionTile(context, item))],
                );
              }),
            ),
          ),
          buildFooter(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/form'),
      ),
    );
  }

  Widget buildTransactionTile(BuildContext context, TransactionModel item) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => Provider.of<TransactionsProvider>(context, listen: false).deleteItem(item),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
          SlidableAction(
            onPressed: (context) => Provider.of<TransactionsProvider>(context, listen: false).updateIsDone(item, !item.isDone),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: item.isDone ? Icons.thumb_up : Icons.thumb_down,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, '/form', arguments: item),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.type == TransactionType.INCOME ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.type == TransactionType.INCOME ? Icons.add : Icons.remove,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(NumberFormat.currency(locale: 'pt-BR', decimalDigits: 2, symbol: 'R\$').format(item.value)),
            SizedBox(height: 5),
            Text(
              (item.type == TransactionType.INCOME)
                  ? item.isDone
                      ? 'recebido'
                      : 'não recebido'
                  : item.isDone
                      ? 'pago'
                      : 'não pago',
              style: TextStyle(
                color: Color(0x8a000000),
                fontSize: 12,
              ),
            )
          ],
        ),
        dense: true,
      ),
    );
  }
}

Widget buildFooter() {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 5,
        ),
      ],
    ),
    child: Row(
      children: [
        SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo Atual'),
            SizedBox(height: 5),
            Text('Saldo previsto'),
          ],
        ),
        Expanded(child: Container()),
        Consumer<TransactionsProvider>(
          builder: (context, value, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(NumberFormat.currency(locale: 'pt-BR', decimalDigits: 2, symbol: 'R\$').format(value.actualBalance()),
                    style: TextStyle(
                      color: value.actualBalance() < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 5),
                Text(NumberFormat.currency(locale: 'pt-BR', decimalDigits: 2, symbol: 'R\$').format(value.foreseeBalance()),
                    style: TextStyle(
                      color: value.foreseeBalance() < 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            );
          },
        ),
        SizedBox(width: 20),
      ],
    ),
  );
}
