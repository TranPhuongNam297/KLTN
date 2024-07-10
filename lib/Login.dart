import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ActivityRegister.dart';
import 'mainLayout.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  void _loginUser() async {
    String userName = _userNameController.text;
    String password = _passwordController.text;

    if (!_validateInputs(userName, password)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    _showLoadingDialog();

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User_info')
          .where('UserName', isEqualTo: userName)
          .where('PassWord', isEqualTo: password)
          .get();

      Navigator.pop(context); // Close the loading dialog

      if (querySnapshot.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => mainLayout()),
        );
      } else {
        _showErrorDialog('Sai tài khoản hoặc mật khẩu');
      }
    } catch (error) {
      Navigator.pop(context); // Close the loading dialog
      _showErrorDialog('Đã xảy ra lỗi: $error');
    }

    setState(() {
      isLoading = false;
    });
  }

  bool _validateInputs(String userName, String password) {
    if (userName.isEmpty || password.isEmpty) {
      _showErrorDialog('Vui lòng nhập tài khoản và mật khẩu');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi đăng nhập'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đang xử lý...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Vui lòng chờ trong giây lát.'),
            ],
          ),
        );
      },
    );
  }

  void _showLoadingPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đang xử lý...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Vui lòng chờ trong giây lát.'),
            ],
          ),
        );
      },
    );
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
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/tetmass.png',
                    height: width * 0.5,
                    width: width * 0.5,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Tài khoản',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Mật khẩu',
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Add action here
                        },
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: width * 0.6,
                    height: height * 0.07,
                    child: ElevatedButton(
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Bạn chưa có tài khoản?',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextButton(
                        onPressed: () {
                          _showLoadingPopup();
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActivityRegister()),
                            );
                          });
                        },
                        child: Text(
                          'Đăng kí ngay',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Colors.black,
                          thickness: 2.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Hoặc',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.black,
                          thickness: 2.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: width * 0.8,
                    height: height * 0.07,
                    child: ElevatedButton.icon(
                      icon: Image.network(
                        'https://developers.google.com/identity/images/g-logo.png',
                        height: 30,
                        width: 30,
                      ),
                      label: Text(
                        'Tiếp tục với Google',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
