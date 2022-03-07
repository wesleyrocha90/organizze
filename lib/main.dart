import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:organizze/pages/transaction_form_page.dart';
import 'package:organizze/pages/transaction_list_page.dart';
import 'package:organizze/providers/transactions_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [Locale('pt', 'BR')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TransactionListPage(),
        '/form': (context) => TransactionFormPage(transaction: ModalRoute.of(context)?.settings.arguments),
      },
    );
  }
}
