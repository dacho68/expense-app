import 'package:Expenseye/Models/Item.dart';
import 'package:Expenseye/Pages/Categories/cat_home_page.dart';
import 'package:Expenseye/Pages/Monthly/monthly_home_page.dart';
import 'package:Expenseye/Pages/Yearly/yearly_home_page.dart';
import 'package:Expenseye/Pages/about_page.dart';
import 'package:Expenseye/Providers/Global/db_model.dart';
import 'package:Expenseye/Resources/Strings.dart';
import 'package:Expenseye/Resources/Themes/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../Models/Category.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _logInFirstPress = true;
  bool _logOutFirstPress = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: MyColors.black00dp,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: MyColors.black02dp,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.remove_red_eye, color: Colors.white),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            Strings.appName,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseAuth.instance.onAuthStateChanged,
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data.photoUrl),
                                radius: 25,
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              RaisedButton(
                                color: MyColors.black06dp,
                                child: Text(
                                  Strings.signOut,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                                onPressed: () {
                                  if (_logOutFirstPress) {
                                    _logOutFirstPress = false;
                                    _logoutReset(context);
                                  }
                                },
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  Strings.signInToAvoidLosingData,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person),
                                    radius: 25,
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  RaisedButton(
                                    padding: const EdgeInsets.all(0),
                                    color: MyColors.black06dp,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/btn_google_img.png',
                                          width: 180,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      if (_logInFirstPress) {
                                        _logInFirstPress = false;
                                        _loginInit(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(MdiIcons.calendarBlank, color: Colors.white),
                  const SizedBox(width: 6),
                  const Text(Strings.monthly),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop(context);
                openMonthlyPage(context);
              } 
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(MdiIcons.calendarBlankMultiple, color: Colors.white),
                  const SizedBox(width: 6),
                  const Text(Strings.yearly),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop(context);
                openYearlyPage(context);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(MdiIcons.viewGrid, color: Colors.white),
                  const SizedBox(width: 6),
                  const Text(Strings.categories),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop(context);
                openCategoriesPage(context);
              } 
            ),
            ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.info_outline, color: Colors.white),
                    const SizedBox(width: 6),
                    const Text(Strings.about),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop(context);
                  openAboutPage(context);
                }),
          ],
        ),
      ),
    );
  }

  void _logoutReset(BuildContext context) async {
    await Provider.of<DbModel>(context, listen: false).logOutFromGoogle();
    _logInFirstPress = true;
  }

  void _loginInit(BuildContext context) async {
    final _dbModel = Provider.of<DbModel>(context, listen: false);
    final _firebaseModel = Provider.of<DbModel>(context, listen: false);

    // TODO: refactor: don't use dbHelper outside of provider
    List<Item> localItems = await _dbModel.dbHelper.queryAllItems();
    List<Category> localCategories = await _dbModel.queryCategories();

    bool isLoggedIn = await _firebaseModel.loginWithGoogle();
    await _dbModel.initCategoriesMap();

    List<Category> accCategories = await _dbModel.queryCategories();

    if (isLoggedIn) {
      await _dbModel.addLocalItems(localItems, localCategories, accCategories);
    }
    _logOutFirstPress = true;
  }

  void openMonthlyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MonthlyHomePage(DateTime.now())),
    );
  }

  void openYearlyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => YearlyHomePage()),
    );
  }

  void openAboutPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  void openCategoriesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CatHomePage()),
    );
  }
}

// TODO: refactor this
