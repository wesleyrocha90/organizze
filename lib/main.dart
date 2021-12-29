import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lançamentos'),
    );
  }
}

enum TransactionType {
  INCOME,
  EXPENSE,
}

class Transaction {
  TransactionType type;
  String title;
  String description;
  double value;
  bool isDone;

  Transaction(this.type, this.title, this.description, this.value, this.isDone);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> transactions = [
    Transaction(TransactionType.INCOME, 'Salário', 'Salário', 16233.0, true),
    Transaction(TransactionType.EXPENSE, 'Casa', 'Moradia', 110.0, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...transactions.map((item) {
            return ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: item.type == TransactionType.INCOME ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(item.title),
              subtitle: Text(item.description),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
            );
          })
        ],
      ),
    );
  }
}
