import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/data/expense_data.dart';
import 'package:flutter_expense_tracker/pages/home_page.dart';
import "package:provider/provider.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          home: const HomePage(),
        );
      },
    );
  }
}
