import "package:flutter/material.dart";

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

  void save() {}

  void cancel() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNewExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
