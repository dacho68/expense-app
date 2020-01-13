import 'package:expense_app/Components/Global/calendar_flat_button.dart';
import 'package:expense_app/Components/Global/my_bottom_nav_bar.dart';
import 'package:expense_app/Components/Global/my_drawer.dart';
import 'package:expense_app/Pages/Yearly/yearly_expenses_page.dart';
import 'package:expense_app/Pages/stats_page.dart';
import 'package:expense_app/Providers/Global/expense_model.dart';
import 'package:expense_app/Providers/yearly_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearlyHomePage extends StatefulWidget {
  @override
  _YearlyHomePageState createState() => _YearlyHomePageState();
}

class _YearlyHomePageState extends State<YearlyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _expenseModel = Provider.of<ExpenseModel>(context);

    return ChangeNotifierProvider(
      create: (_) => YearlyModel(),
      child: Consumer<YearlyModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text(model.year),
            actions: <Widget>[
              CalendarFlatButton(
                onPressed: () => showYearPicker(model),
              ),
            ],
          ),
          drawer: MyDrawer(),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                YearlyExpensesPage(),
                StatsPage(
                  localModel: model,
                  future: () =>
                      _expenseModel.dbHelper.queryExpensesInYear(model.year),
                ),
              ],
            ),
          ),
          bottomNavigationBar: MyBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  void showYearPicker(YearlyModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: YearPicker(
            selectedDate: model.currentDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2030),
            onChanged: (date) {
              model.updateCurrentDate(date);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}