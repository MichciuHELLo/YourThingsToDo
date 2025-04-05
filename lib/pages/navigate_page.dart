import 'package:flutter/material.dart';
import 'package:your_things_to_do/pages/settings_page.dart';
import 'package:your_things_to_do/pages/things_to_do_page.dart';
import 'package:your_things_to_do/widget/language_inherited_widget.dart';
import 'package:your_things_to_do/widget/scroll_to_hide_widget.dart';

import '../data/database.dart';

import '../data/globalVariables.dart' as globals;

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  ToDoDataBase db = ToDoDataBase();
  ScrollController scrollController = ScrollController();
  final List _pages = [];

  late String homeText;
  late String settingsText;

  int _selectedPageIndex = 0;
  int languageIndex = 0;
  String applicationColor = 'Dark';

  void navigateBottomBar(int pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
  }

  @override
  void initState() {

    scrollController = ScrollController();

    _pages.add(ThingsToDoPage(scrollController: scrollController));
    _pages.add(SettingsPage());

    db.loadSettings();
    globals.changeColors(db.settingsList[1]);
    languageIndex = db.settingsList[0];
    applicationColor = db.settingsList[1];

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _pages.clear();

    super.dispose();
  }

  void updateLanguage(int index) {
    print("updateLanguage: " + index.toString());
    setState(() {
      languageIndex = index;
    });
  }

  void updateAppColor(String appColor) {
    print("updateAppColor: " + appColor);
    setState(() {
      applicationColor = appColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(

    return LanguageInheritedWidget(
        languageIndex: languageIndex,
        appColor: applicationColor,
        updateLanguage: updateLanguage,
        updateAppColor: updateAppColor,
        child: Scaffold(
        body: _pages[_selectedPageIndex],
        bottomNavigationBar: ScrollToHideWidget(
          scrollController: scrollController,
          child: BottomNavigationBar(
            currentIndex: _selectedPageIndex,
            onTap: navigateBottomBar,
            // backgroundColor: Colors.purple.shade200,
            backgroundColor: globals.appColorSub,
            // unselectedItemColor: Colors.purple,
            unselectedItemColor: globals.appColorMain,
            // selectedItemColor: Colors.purple,
            selectedItemColor: globals.appColorMain,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.home,
                    // color: Colors.purple
                    color: globals.appColorMain
                ),
                // label: homeText,
                label: 'H O M E',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.settings,
                    // color: Colors.purple
                    color: globals.appColorMain
                ),
                // label: settingsText,
                label: 'S E T T I N G S',
              ),
            ],
          ),
        )
        )
    );
  }
}
