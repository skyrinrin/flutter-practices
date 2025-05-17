import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(count.toString()),
              ElevatedButton(onPressed: () {
                count++;
                setState(() {
                  
                });
              }, child: Text('ボタン'))
            ],
          ),
        ),
      ),
    );
  }
}
