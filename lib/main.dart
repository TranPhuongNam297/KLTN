import 'package:flutter/material.dart';
import 'LoadingScreen.dart';
import 'MatchingQuestion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App thi trắc nghiệm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MatchingQuestion(),
    );
  }
}
