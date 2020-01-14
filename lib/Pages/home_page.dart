import 'package:expense_app/Pages/Monthly/monthly_home_page.dart';
import 'package:expense_app/Pages/Yearly/yearly_home_page.dart';
import 'package:expense_app/Providers/daily_model.dart';
import 'package:expense_app/Providers/monthly_model.dart';
import 'package:expense_app/Providers/yearly_model.dart';
import 'package:expense_app/google_firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Daily/daily_home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      GoogleFirebaseHelper.uploadDbFile();
    }
  }

  final controller = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DailyModel>(create: (_) => DailyModel()),
        ChangeNotifierProvider<MonthlyModel>(
            create: (_) => MonthlyModel(DateTime.now())),
        ChangeNotifierProvider<YearlyModel>(create: (_) => YearlyModel()),
      ],
      child: PageView(
        controller: controller,
        children: <Widget>[
          DailyHomePage(),
          MonthlyHomePage(),
          YearlyHomePage(goToMonthPage: onYearlyMonthSelected),
        ],
      ),
    );
  }

  void onYearlyMonthSelected() {
    controller.animateToPage(
      1,
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }
}