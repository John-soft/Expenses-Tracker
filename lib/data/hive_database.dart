import 'package:expenses_tracker/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  //reference our box declared in main

  final _myBox = Hive.box("expenses_database");
  //write data
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expensesFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expensesFormatted);
      _myBox.put("ALL_EXPENSES", allExpensesFormatted);
    }
  }

  //read data
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (var i = 0; i < savedExpenses.length; i++) {
      //collect individual expenses data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
