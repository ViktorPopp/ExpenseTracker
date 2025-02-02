import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/expense.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  List<Expense> get allExpenses => _allExpenses;

  /* CRUD Operations */

  // Create
  Future<void> createNewExpense(Expense newExpense) async {
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    await readExpenses();
  }

  // Read
  Future<void> readExpenses() async {
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    notifyListeners();
  }

  // Update
  Future<void> updateExpense(int id, Expense updateExpense) async {
    updateExpense.id = id;
    await isar.writeTxn(() => isar.expenses.put(updateExpense));
    await readExpenses();
  }

  // Delete
  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));
    await readExpenses();
  }
}