import 'package:Expenseye/Helpers/database_helper.dart';
import 'package:Expenseye/Helpers/google_firebase_helper.dart';
import 'package:Expenseye/Models/Category.dart';
import 'package:Expenseye/Models/Item.dart';
import 'package:Expenseye/Utils/date_time_util.dart';
import 'package:flutter/material.dart';

class DbModel extends ChangeNotifier {
  // TODO: make this a private variable
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  static Map<String, Category> catMap = new Map();

  DbModel() {
    initConnectedUser();
    initCategoriesMap();
  }

  void initConnectedUser() async {
    await GoogleFirebaseHelper.initConnectedUser();
  }

  Future<bool> loginWithGoogle() async {
    return await GoogleFirebaseHelper.loginWithGoogle();
  }

  Future<void> logOutFromGoogle() async {
    await GoogleFirebaseHelper.uploadDbFile();
    await GoogleFirebaseHelper.logOut();
    await _deleteAllItems();
    await _resetCategories();
  }

  Future<void> addLocalItems(List<Item> localItems,
      List<Category> localCategories, List<Category> accCategories) async {
    List<String> accCategoriesId =
        accCategories.map((category) => category.id).toList();

    for (var localCategory in localCategories) {
      if (!accCategoriesId.contains(localCategory.id)) {
        await dbHelper.insertCategory(localCategory);
        catMap[localCategory.id] = localCategory;
      }
    }

    if (localItems.length > 0) {
      for (Item item in localItems) {
        await dbHelper.insertItem(item);
      }
    }
    notifyListeners();
  }

  Future<void> initCategoriesMap() async {
    List<Category> categories = await dbHelper.queryCategories();
    catMap.clear();
    for (var category in categories) {
      catMap[category.id] = category;
    }
  }

  Future<List<Category>> queryCategories() async {
    return await dbHelper.queryCategories();
  }

  Future<void> addItem(Item newItem) async {
    await dbHelper.insertItem(newItem);
    notifyListeners();
  }

  Future<void> editItem(Item newItem) async {
    await dbHelper.updateItem(newItem);
    notifyListeners();
  }

  Future<void> deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    notifyListeners();
  }

  Future<void> _deleteAllItems() async {
    await dbHelper.deleteAllItems();
    notifyListeners();
  }

  Future<List<Item>> queryItemsByDay(DateTime day) async {
    DateTime dayClean = DateTimeUtil.timeToZeroInDate(day);
    return await dbHelper.queryItemsInDate(dayClean);
  }

  Future<List<Item>> queryItemsByMonth(String yearMonth) async {
    return await dbHelper.queryItemsByMonth(yearMonth);
  }

  Future<void> deleteCategory(String categoryId) async {
    await dbHelper.deleteCategory(categoryId);
    await initCategoriesMap();
    notifyListeners();
  }

  Future<void> deleteItemsByCategory(String categoryId) async {
    await dbHelper.deleteItemsByCategory(categoryId);
    notifyListeners();
  }

  Future<void> _resetCategories() async {
    await dbHelper.deleteAllCategories();
    await dbHelper.insertDefaultCategories();
    await initCategoriesMap();
    notifyListeners();
  }
}
