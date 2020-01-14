import 'package:Expenseye/Components/Global/add_expense_fab.dart';
import 'package:Expenseye/Components/Expenses/expense_list_tile.dart';
import 'package:Expenseye/Models/Expense.dart';
import 'package:Expenseye/Providers/daily_model.dart';
import 'package:Expenseye/Resources/Strings.dart';
import 'package:Expenseye/Resources/Themes/Colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Expenseye/Providers/Global/expense_model.dart';

class DailyExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _expenseModel = Provider.of<ExpenseModel>(context, listen: false);
    final _dailyModel = Provider.of<DailyModel>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<List<Expense>>(
        future:
            _expenseModel.dbHelper.queryExpensesInDate(_dailyModel.currentDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data.length > 0) {
              _dailyModel.currentTotal = _expenseModel.calcTotal(snapshot.data);
              return Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${Strings.total}: ${_expenseModel.totalString(snapshot.data)}',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: snapshot.data.map(
                        (expense) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            color: MyColors.black02dp,
                            child: ExpenseListTile(
                              expense,
                              onTap: () => _expenseModel.openEditExpense(
                                  context, expense),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              );
            } else {
              return const Align(
                alignment: Alignment.center,
                child: const Text(Strings.addAnExpense),
              );
            }
          } else {
            return const Align(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: AddExpenseFab(
        onPressed: () =>
            _expenseModel.showAddExpense(context, _dailyModel.currentDate),
      ),
    );
  }
}
