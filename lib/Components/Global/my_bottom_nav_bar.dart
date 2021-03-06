import 'package:Expenseye/Resources/Strings.dart';
import 'package:Expenseye/Resources/Themes/Colors.dart';
import 'package:flutter/material.dart';

class MyBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function onTap;

  MyBottomNavBar({@required this.currentIndex, this.onTap});

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedIconTheme: const IconThemeData(color: MyColors.secondary),
      backgroundColor: MyColors.black24dp,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.list),
          title: Text(
            Strings.expenses,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.pie_chart),
          title: Text(
            Strings.stats,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
      ],
    );
  }
}
