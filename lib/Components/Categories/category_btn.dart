import 'package:Expenseye/Models/Category.dart';
import 'package:flutter/material.dart';

class CategoryBtn extends StatelessWidget {
  final Category category;
  final Function onPressed;

  CategoryBtn({@required this.category, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            category.iconData,
            color: category.color,
            size: 35,
          ),
          const SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              category.name,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
        ],
      ),
    );
  }
}
