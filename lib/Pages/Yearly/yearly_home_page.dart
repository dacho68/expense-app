import 'package:Expenseye/Components/Global/my_bottom_nav_bar.dart';
import 'package:Expenseye/Pages/Yearly/yearly_items_page.dart';
import 'package:Expenseye/Pages/stats_page.dart';
import 'package:Expenseye/Providers/Global/db_model.dart';
import 'package:Expenseye/Providers/yearly_model.dart';
import 'package:Expenseye/Resources/Strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearlyHomePage extends StatefulWidget {
  @override
  _YearlyHomePageState createState() => _YearlyHomePageState();
}

class _YearlyHomePageState extends State<YearlyHomePage>{
  @override
  Widget build(BuildContext context) {
    final _dbModel = Provider.of<DbModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => YearlyModel(),
      child: Consumer<YearlyModel>(
        builder: (context, yearlyModel, child) => Scaffold(
          appBar: AppBar(
            title: Text(Strings.yearly),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                onPressed: () => yearlyModel.calendarFunc(context),
                child: const Icon(Icons.calendar_today),
                shape: const CircleBorder(
                  side: const BorderSide(color: Colors.transparent),
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: yearlyModel.pageIndex,
              children: <Widget>[
                YearlyItemsPage(),
                StatsPage(
                  localModel: yearlyModel,
                  future: () =>
                      _dbModel.dbHelper.queryItemsInYear(yearlyModel.year),
                ),
              ],
            ),
          ),
          bottomNavigationBar: MyBottomNavBar(
            currentIndex: yearlyModel.pageIndex,
            onTap: (int index) {
              setState(() {
                yearlyModel.pageIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
