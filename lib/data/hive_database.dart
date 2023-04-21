import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_item.dart';

class HiveDataBase {
  // reference our box
  final _myBox = Hive.box("expense_database");

  // write data
  void saveData(List<ExpenseItem> allExpenses) {
    _myBox.put("ALL_EXPENSES", allExpenses);
  }

  // read data
  List<ExpenseItem> readData() {
    List<ExpenseItem> savedExpenses =
        (_myBox.get("ALL_EXPENSES") ?? []).cast<ExpenseItem>();

    return savedExpenses;
  }
}
