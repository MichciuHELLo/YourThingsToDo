import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {

//variable
  double _height = 0.0;
  double _width = 0.0;
  int _counter = 0;

//method
  void _increaseCounter() {
    setState(() {
      _counter++;
      _height++;
      _width++;
    });
  }

//UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You pushed button this many times:"),
            Text(
              _counter.toString(),
              style: TextStyle(fontSize: 40),
            ),
            Container(
              color: Colors.deepPurple,
              height: _height,
              width: _width,
            ),
            ElevatedButton(onPressed: _increaseCounter, child: Text("Tap me!"))
          ],
        ),
      )
    );
  }
}
