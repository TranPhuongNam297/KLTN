import 'package:flutter/material.dart';
import 'dart:async';
import 'Login.dart'; // Đảm bảo rằng bạn đã import tệp Login.dart

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('images/background.jpg'), context); // Tải trước hình nền của trang Login
      Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/logoapp.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
