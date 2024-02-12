import 'package:expenses_tracker/components/expense_summary.dart';
import 'package:expenses_tracker/components/expense_tile.dart';
import 'package:expenses_tracker/data/expense_data.dart';
import 'package:expenses_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final expenseNameController = TextEditingController();
  final expenseDollarController = TextEditingController();
  final expenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).preprareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add new expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //expense name
                  TextField(
                    controller: expenseNameController,
                    decoration: const InputDecoration(
                      hintText: 'Expense name',
                    ),
                  ),
                  //expense amount
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expenseDollarController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Dollars',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: expenseCentsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'cents',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                )
              ],
            ));
  }

  //save
  void save() {
    if (expenseNameController.text.isNotEmpty &&
        expenseDollarController.text.isNotEmpty &&
        expenseCentsController.text.isNotEmpty) {
      String amount =
          '${expenseDollarController.text}.${expenseCentsController.text}';
      //create expense item

      ExpenseItem newExpense = ExpenseItem(
        name: expenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      //add the new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      Navigator.pop(context);
      clear();
    }
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    expenseDollarController.clear();
    expenseCentsController.clear();
    expenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(builder: (context, value, child) {
      return Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfTheWeek()),

              const SizedBox(
                height: 20,
              ),

              //expenses list
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) {
                    return ExpenseTile(
                      name: value.getAllExpenseList()[index].name,
                      amount: value.getAllExpenseList()[index].amount,
                      dateTime: value.getAllExpenseList()[index].dateTime,
                      deleteTapped: (p0) =>
                          deleteExpense(value.getAllExpenseList()[index]),
                    );
                  }),
            ],
          ));
    });
  }
}
