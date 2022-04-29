import 'package:flutter/material.dart';
import 'package:tic_tac_toe/pages/caterogy_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tic Tac Toe',
      home: new SelectCategory(),
    );
  }
}
