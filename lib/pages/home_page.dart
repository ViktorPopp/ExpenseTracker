import 'package:expense_tracker/components/expense_list_tile.dart';
import 'package:expense_tracker/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/expense_database.dart';
import '../models/expense.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();
  }

  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: "Amount"),
            )
          ],
        ),
        actions: [
          _cancelButton(),
          _createNewExpenseButton(),
        ],
      ),
    );
  }

  void openEditBox(Expense expense) {
    nameController.text = expense.name;
    amountController.text = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(),
            ),
          ],
        ),
        actions: [
          _cancelButton(),
          _editExpenseButton(expense),
        ],
      ),
    );
  }

  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Expense"),
        actions: [
          _cancelButton(),
          _deleteExpenseButton(expense.id),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => openNewExpenseBox(),
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.allExpenses.length,
          itemBuilder: (context, index) {
            return ExpenseListTile(
              title: value.allExpenses[index].name,
              trailing: formatAmount(value.allExpenses[index].amount),
              onEditPressed: (context) => openEditBox(value.allExpenses[index]),
              onDeletePressed: (context) =>
                  openDeleteBox(value.allExpenses[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).pop();
        nameController.clear();
        amountController.clear();
      },
      child: const Text('cancel'),
    );
  }

  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense newExpense = Expense(
            name: nameController.text,
            amount: convertStringToDouble(amountController.text),
            date: DateTime.now(),
          );

          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Create'),
    );
  }

  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : context.read<ExpenseDatabase>().allExpenses.last.name,
            amount: amountController.text.isNotEmpty
                ? convertStringToDouble(amountController.text)
                : context.read<ExpenseDatabase>().allExpenses.last.amount,
            date: DateTime.now(),
          );

          int existingID = expense.id;

          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingID, updatedExpense);

          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);
        await context.read<ExpenseDatabase>().deleteExpense(id);
      },
      child: const Text('Delete'),
    );
  }
}
