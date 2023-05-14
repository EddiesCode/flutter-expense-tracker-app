import 'dart:developer';

import 'package:flutter/services.dart';

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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                ],
                keyboardType: TextInputType.name,
                controller: newExpenseNameController,
                decoration: const InputDecoration(hintText: "Expense name")),

            Row(
              children: [
                // dollars amount
                Flexible(
                    flex: 2,
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: newExpenseDollarController,
                      decoration: const InputDecoration(hintText: "Dollars"),
                    )),
                // cents amount
                Flexible(
                    flex: 1,
                    child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    // only save expense if all fields are filled
    if (newExpenseNameController.text.isEmpty ||
        newExpenseDollarController.text.isEmpty ||
        newExpenseCentsController.text.isEmpty) {
      // put dollars and cents together
      String amount =
          "${newExpenseDollarController.text}.${newExpenseCentsController.text}";

      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      // add the new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

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
        // backgroundColor: Colors.grey.shade300,
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          // backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                onSubmitted: (value) {
                  List<String> stringList = value.split(" ");

                  String expenseName = stringList[0];

                  late String amount;

                  try {
                    amount = stringList[1];
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        content: const Text(
                            "Invalid input (must follow format: expenseName amount)"),
                        action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {},
                        ),
                      ),
                    );
                    clear();
                    return;
                  }

                  if (stringList.length < 2 ||
                      !RegExp(r'^[0-9]+$').hasMatch(amount)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        content: const Text(
                            "Invalid input (must follow format: expenseName amount)"),
                        action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {},
                        ),
                      ),
                    );
                  } else {
                    ExpenseItem newExpense = ExpenseItem(
                      name: expenseName,
                      amount: amount,
                      dateTime: DateTime.now(),
                    );

                    Provider.of<ExpenseData>(context, listen: false)
                        .addNewExpense(newExpense);

                    log(value);
                    clear();
                  }
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Color.fromARGB(255, 49, 49, 49),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  hintText: "Expense Name + Amount (e.g. food 10)",
                ),
                controller: newExpenseNameController,
              ),
            ),

            //expense list
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) =>
                      deleteExpense(value.getAllExpenseList()[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
