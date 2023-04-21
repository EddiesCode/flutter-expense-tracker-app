import "package:flutter/material.dart";
import 'package:flutter_expense_tracker/components/expense_summary.dart';
import 'package:flutter_expense_tracker/components/expense_tile.dart';
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
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new expense"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            // expense name
            TextField(
                controller: newExpenseNameController,
                decoration: const InputDecoration(hintText: "Expense name")),

            Row(
              children: [
                // dollars amount
                Flexible(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: newExpenseDollarController,
                      decoration: const InputDecoration(hintText: "Dollars"),
                    )),
                // cents amount
                Flexible(
                    flex: 1,
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: newExpenseCentsController,
                        decoration: const InputDecoration(hintText: "Cents")))
              ],
            )
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
    // put dollars and cents together
    String amount =
        "${newExpenseDollarController.text}.${newExpenseCentsController.text}";

    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: amount,
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
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey.shade300,
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.black,
              child: const Icon(Icons.add),
            ),
            body: SizedBox(
              height: double.infinity,
              child: Container(
                color: Colors.grey,
                child: ListView(
                  children: [
                    // weekly summary
                    ExpenseSummary(startOfWeek: value.startOfWeekDate()),

                    //expense list
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.getAllExpenseList().length,
                        itemBuilder: (context, index) => ExpenseTile(
                            name: value.getAllExpenseList()[index].name,
                            amount: value.getAllExpenseList()[index].amount,
                            dateTime:
                                value.getAllExpenseList()[index].dateTime)),
                  ],
                ),
              ),
            )));
  }
}
