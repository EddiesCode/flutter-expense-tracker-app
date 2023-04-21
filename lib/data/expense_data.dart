import 'package:flutter_expense_tracker/datetime/date_time_helper.dart';

import '../models/expense_item.dart';

class ExpenseData {
  // list ALL expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
  }

  // get weekday (mon, tues, etc) from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  // get the date of the start of the week ( sunday )
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    // go backwards from today to find nearest sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == "Sun") {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  //

  /* 
  
    convert overall list of expenses to daily expense summary

    e.g.

    overallExpanseList = 

    [

      [ food, 2023/01/30, $10 ],
      [ hat, 2023/01/30, $15 ],
      [ drinks, 2023/01/31, $1 ],
      [ food, 2023/02/01, $5 ],
      [ food, 2023/02/01, $6 ],
      [ food, 2023/02/03, $7 ],
      [ food, 2023/02/05, $10 ],
      [ food, 2023/02/05, $11 ],


    ]

    ->

    DailyExpenseSummary = 

    [

      [ 2023/01/30, $25 ],
      [ 2023/01/31, $1 ],
      [ 2023/02/01, $11 ],
      [ 2023/02/03, $7 ],
      [ 2023/02/05, $21 ],

    ]
  
   */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}
