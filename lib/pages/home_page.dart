import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../data/expense_data.dart';
import '../models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new expense"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            // expense name
            TextField(controller: newExpenseNameController),

            // expense amount
            TextField(controller: newExpenseAmountController)
          ]),
          actions: [
            MaterialButton(
              onPressed: save,
              child: const Text("Save"),
            ),
            MaterialButton(
              onPressed: cancel,
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void save() {
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );
    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey.shade300,
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(value.getAllExpenseList()[index].name),
                )),
      ),
    );
  }
}
