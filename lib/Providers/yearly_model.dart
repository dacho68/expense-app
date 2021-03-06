import 'package:Expenseye/Models/Item.dart';
import 'package:Expenseye/Utils/date_time_util.dart';
import 'package:flutter/material.dart';

class YearlyModel extends ChangeNotifier {
  DateTime currentDate = DateTime.now(); // to be changed in the year picker
  String year = getYearString(DateTime.now());
  double currentTotal = 0;
  double currentExpenseTotal = 0;
  double currentIncomeTotal = 0;
  int pageIndex = 0;

  static String getYearString(DateTime newYear) {
    String temp = newYear.toIso8601String().split('T')[0];
    return temp.substring(0, temp.length - 6);
  }

  String getYearMonthString(DateTime newMonth) {
    String temp = newMonth.toIso8601String().split('T')[0];
    return temp.substring(0, temp.length - 3);
  }

  List<List<Item>> splitItemByMonth(List<Item> expenses) {
    List<List<Item>> expensesSplitByMonth = new List();

    String currentMonth = getYearMonthString(expenses[0].date);
    int index = 0;
    expensesSplitByMonth.add(new List());

    for (Item expense in expenses) {
      if (getYearMonthString(expense.date) == currentMonth) {
        expensesSplitByMonth[index].add(expense);
      } else {
        index++;
        currentMonth = getYearMonthString(expense.date);
        expensesSplitByMonth.add(new List());
        expensesSplitByMonth[index].add(expense);
      }
    }

    return expensesSplitByMonth;
  }

  void updateCurrentDate(BuildContext context, DateTime newDate) {
    if (newDate != null) {
      currentDate = newDate;
      year = getYearString(newDate);
      notifyListeners();
    }
  }

  String getTitle() {
    return year;
  }

  Future<void> calendarFunc(BuildContext context) async {
    final DateTime newDate =
        await DateTimeUtil.chooseYear(context, currentDate);

    updateCurrentDate(context, newDate);
  }

  void resetTotals() {
    currentTotal = 0;
    currentIncomeTotal = 0;
    currentExpenseTotal = 0;

    notifyListeners();
  }
}
