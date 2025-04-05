import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  TextEditingController myController = TextEditingController();

  String _name = "";

  void greetUser() {
    String _insertedUsername = myController.text;
    setState(() {
      _name = _insertedUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text("H I "),
              Text("H I "),
              Text("H I "),
              Text("H I "),
              Text("H I "),
              Text("H I " + _name),
              TextField(controller: myController, decoration: InputDecoration(border: OutlineInputBorder()),),
              ElevatedButton(onPressed: greetUser, child: Text("Tap"))
            ],
          ),
        ),
      ),
    );
  }
}
