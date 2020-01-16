import 'package:Expenseye/Components/EditAdd/add_expense_dialog.dart';
import 'package:Expenseye/Components/EditAdd/add_income_dialog.dart';
import 'package:Expenseye/Models/Item.dart';
import 'package:Expenseye/Pages/EditAdd/edit_expense_page.dart';
import 'package:Expenseye/Resources/Strings.dart';
import 'package:Expenseye/Utils/database_helper.dart';
import 'package:Expenseye/google_firebase_helper.dart';
import 'package:flutter/material.dart';

class ItemModel extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  ItemModel() {
    initConnectedUser();
  }

  void initConnectedUser() async {
    await GoogleFirebaseHelper.initConnectedUser();
  }

  void loginWithGoogle() async {
    List<Item> localItems = await dbHelper.queryAllItems();

    bool isLoggedIn = await GoogleFirebaseHelper.loginWithGoogle();

    if (isLoggedIn && localItems.length > 0) {
      for (Item item in localItems) {
        await dbHelper.insertItem(item);
      }
    }

    notifyListeners();
  }

  void logOutFromGoogle() async {
    await GoogleFirebaseHelper.uploadDbFile();
    await GoogleFirebaseHelper.logOut();
    await dbHelper.deleteAll();
    notifyListeners();
  }

  void addItem(Item newItem) async {
    await dbHelper.insertItem(newItem);
    notifyListeners();
  }

  void editItem(Item newItem) async {
    await dbHelper.updateItem(newItem);
    notifyListeners();
  }

  void deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    notifyListeners();
  }

  void showAddExpense(BuildContext context, DateTime initialDate) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (_) => AddExpenseDialog(initialDate),
    );

    // TODO: make this a func
    if (confirmed != null && confirmed) {
      final snackBar = SnackBar(
        content: Text(Strings.succAdded),
        backgroundColor: Colors.grey.withOpacity(0.5),
      );

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void showAddIncome(BuildContext context, DateTime initialDate) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (_) => AddIncomeDialog(initialDate),
    );

    if (confirmed != null && confirmed) {
      final snackBar = SnackBar(
        content: Text(Strings.succAdded),
        backgroundColor: Colors.grey.withOpacity(0.5),
      );

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void openEditItem(BuildContext context, Item item) async {
    int action = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditExpensePage(item)),
    );

    if (action != null) {
      final snackBar = SnackBar(
        content:
            action == 1 ? Text(Strings.succEdited) : Text(Strings.succDeleted),
        backgroundColor: Colors.grey.withOpacity(0.5),
      );

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  double calcTotal(List<Item> items) {
    double total = 0;
    for (Item item in items) {
      switch (item.type) {
        case 0:
          total -= item.value;
          break;
        case 1:
          total += item.value;
          break;
      }
    }
    return total;
  }

  // * may move out of this provider
  String totalString(List<Item> items) {
    return '${calcTotal(items).toStringAsFixed(2)} \$';
  }
}
