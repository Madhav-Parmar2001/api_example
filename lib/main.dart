import 'package:flutter/material.dart';
import 'api/HomePage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Api Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:Api_HomePage(),
    );
  }
}
