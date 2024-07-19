import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/Model/User_info.dart';

import 'Login.dart';

class ActivityRegister extends StatefulWidget {
  String uid;
  ActivityRegister({required this.uid});
  @override
  _ActivityRegister createState() => _ActivityRegister();
}

class _ActivityRegister extends State<ActivityRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      shopDiablog(context, "Thông báo", "Mời bạn nhập thông tin để hoàn tất tạo tài khoản");
    });
  }
  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Hide keyboard
      String userId = widget.uid;
      if(userId == ""){
        userId = FirebaseFirestore.instance.collection('users').doc().id;
      }
      User_info newUser = User_info(
        FullName: _fullNameController.text,
        Id_User: userId,
        IsActive: false,
        PassWord: _passwordController.text,
        PhoneNumber: _phoneNumberController.text,
        UserName: _userNameController.text,
      );

      FirebaseFirestore.instance
          .collection('User_info')
          .doc(newUser.Id_User)
          .set(newUser.toMap())
          .then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Đăng ký thành công'),
              content: Text('Chúc mừng bạn đã đăng ký tài khoản thành công!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register user: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
   // shopDiablog(context,"Thông báo","Mời bạn nhập thông tin để hoàn tất tạo tài khoản");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/register_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Họ và tên',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bạn chưa nhập họ và tên';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Số điện thoại',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bạn chưa nhập số điện thoại';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Tài khoản',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bạn chưa nhập tài khoản';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Mật khẩu',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bạn chưa nhập mật khẩu';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: width * 0.6,
                          height: height * 0.07,
                          child: ElevatedButton(
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            onPressed: _registerUser,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void shopDiablog(BuildContext context,String title,String message){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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
}
