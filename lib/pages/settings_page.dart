import 'package:flutter/material.dart';

import '../data/database.dart';

import '../data/globalVariables.dart' as globals;
import '../widget/language_inherited_widget.dart';
import 'navigate_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ToDoDataBase db = ToDoDataBase();
  late int languageIndex;
  late String dropdownValue;

  late String languageText;
  late String backgroundText;
  late String darkColor;
  late String lightColor;
  late String purpleColor;
  late String yellowColor;
  late String settingsText;

  List<String> languageList = ['English', 'Polski'];

  @override
  void initState() {

    languageIndex = getLanguageIndex();
    dropdownValue = getDropdownValue();

    // db.loadSettings();
    // switch (db.settingsList[0]) {
    //   case 0: // ENGLISH
    //     languageText = "Language";
    //     backgroundText = "Background style";
    //     darkColor = "Dark Mode";
    //     lightColor = "Light Mode";
    //     purpleColor = "Purple";
    //     yellowColor = "Yellow";
    //     settingsText = "\nS E T T I N G S";
    //     break;
    //   case 1: // POLISH
    //     languageText = "Język";
    //     backgroundText = "Styl tła";
    //     darkColor = "Tryb ciemny";
    //     lightColor = "Tryb jasny";
    //     purpleColor = "Fioletowy";
    //     yellowColor = "Żółty";
    //     settingsText = "\nU S T A W I E N I A";
    //     break;
    // }

    setProperLanguage();

    super.initState();
  }

  void setProperLanguage() {
    db.loadSettings();
    switch (db.settingsList[0]) {
      case 0: // ENGLISH
        setState(() {
          languageText = "Language";
          backgroundText = "Background style";
          darkColor = "Dark Mode";
          lightColor = "Light Mode";
          purpleColor = "Purple";
          yellowColor = "Yellow";
          settingsText = "\nS E T T I N G S";
        });
        break;
      case 1: // POLISH
        setState(() {
          languageText = "Język";
          backgroundText = "Styl tła";
          darkColor = "Tryb ciemny";
          lightColor = "Tryb jasny";
          purpleColor = "Fioletowy";
          yellowColor = "Żółty";
          settingsText = "\nU S T A W I E N I A";
        });
        break;
    }
  }

  int getLanguageIndex() {
    db.loadSettings();
    return db.settingsList[0];
  }

  String getDropdownValue() {
    db.loadSettings();
    switch (db.settingsList[1]) {
      case 'Dark':
        return 'Dark';
      case 'Light':
        return 'Light';
      case 'Purple':
        return 'Purple';
      case 'Yellow':
        return 'Yellow';
      default:
        return 'Dark';
    }
  }

  void saveSelectedColorValue(String newValue) {
    db.loadSettings();
    switch (newValue) {
      case 'Dark':
        db.settingsList[1] = 'Dark';
        break;
      case 'Light':
        db.settingsList[1] = 'Light';
        break;
      case 'Purple':
        db.settingsList[1] = 'Purple';
        break;
      case 'Yellow':
        db.settingsList[1] = 'Yellow';
        break;
    }
    db.updateSettings();
  }

  @override
  Widget build(BuildContext context) {

    final languageInheritedWidget = LanguageInheritedWidget.of(context);

    return Scaffold(
      // backgroundColor: Colors.purple[200],
      backgroundColor: globals.appColorSub,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              text: "Your Things To Do",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: globals.appColorText,
              ),
              children: <TextSpan>[
                TextSpan(
                  // text: '\nS E T T I N G S',
                  text: settingsText,
                  style: TextStyle(
                    fontSize: 12,
                    color: globals.appColorText,
                  ),
                ),
              ]),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        // backgroundColor: Colors.purple,
        backgroundColor: globals.appColorMain,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        elevation: 10,
        // shadowColor: Colors.purple[100],
        shadowColor: globals.appColorSub,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.purple
                      color: globals.appColorMain
                  ),
                  child: Icon(
                    Icons.language,
                    // color: Colors.purple[200],
                    // color: globals.appColorSub,
                    color: globals.appColorIcon,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  languageText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: globals.appColorText,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    int languageIndexOperator = languageIndex;
                    if (languageIndexOperator >= 1) {
                      languageIndexOperator--;
                    } else {
                      languageIndexOperator = languageList.length - 1;
                    }
                    setState(() {
                      languageIndex = languageIndexOperator;
                    });
                    db.loadSettings();
                    db.settingsList[0] = languageIndex;
                    db.updateSettings();
                    setProperLanguage();
                  },
                  icon: Icon(Icons.arrow_left, color: globals.appColorText,),
                ),
                Text(
                  languageList[languageIndex],
                  style: TextStyle(
                    color: globals.appColorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    int languageIndexOperator = languageIndex;
                    if (languageIndexOperator <= languageList.length - 2) {
                      languageIndexOperator++;
                    } else {
                      languageIndexOperator = 0;
                    }
                    setState(() {
                      languageIndex = languageIndexOperator;
                    });
                    db.loadSettings();
                    db.settingsList[0] = languageIndex;
                    db.updateSettings();
                    setProperLanguage();
                    languageInheritedWidget?.updateLanguage(languageIndex);
                  },
                  icon: Icon(Icons.arrow_right, color: globals.appColorText,),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.purple
                      color: globals.appColorMain
                  ),
                  child: Icon(
                    Icons.color_lens,
                    // color: Colors.purple[200],
                    // color: globals.appColorSub,
                    color: globals.appColorIcon,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  backgroundText,
                  style: TextStyle(
                    color: globals.appColorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  // dropdownColor: Colors.purple[200],
                  dropdownColor: globals.appColorSub,
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    languageInheritedWidget?.updateAppColor(db.settingsList[1].toString());
                    saveSelectedColorValue(newValue!);
                    setState(() {
                      dropdownValue = newValue;
                      globals.changeColors(newValue);
                    });
                  },
                  items: [
                    DropdownMenuItem(
                        value: "Dark",
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                                darkColor,
                              style: TextStyle(
                                color: globals.appColorText,
                              ),
                            )
                          ],
                        )),
                    DropdownMenuItem(
                        value: "Light",
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(lightColor,
                              style: TextStyle(
                                color: globals.appColorText,
                              ),
                            )
                          ],
                        )),
                    DropdownMenuItem(
                        value: "Purple",
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(purpleColor,
                              style: TextStyle(
                                color: globals.appColorText,
                              ),
                            )
                          ],
                        )),
                    DropdownMenuItem(
                        value: "Yellow",
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.yellow),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(yellowColor,
                              style: TextStyle(
                                color: globals.appColorText,
                              ),
                            )
                          ],
                        )),
                  ],
                ),
                const SizedBox(width: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
