import 'package:Expenseye/Resources/Strings.dart';
import 'package:Expenseye/Resources/Themes/Colors.dart';
import 'package:flutter/material.dart';

class ItemsHeader extends StatelessWidget {
  final pageModel; // DailyModel, MonthlyModel or YearlyModel

  ItemsHeader({this.pageModel});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: Text(
                pageModel.getTitle(),
                style: Theme.of(context).textTheme.display2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.incomeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        const Text(Strings.income),
                        const SizedBox(height: 5),
                        Text(
                          '${pageModel.currentIncomeTotal.toStringAsFixed(2)} \$',
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.expenseColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        const Text(Strings.expense),
                        const SizedBox(height: 5),
                        Text(
                          '${pageModel.currentExpenseTotal.toStringAsFixed(2)} \$',
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.balanceColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        const Text(Strings.balance),
                        const SizedBox(height: 5),
                        Text(
                          '${pageModel.currentTotal.toStringAsFixed(2)} \$',
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
