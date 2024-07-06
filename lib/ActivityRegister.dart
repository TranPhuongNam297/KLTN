import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoa_luan_tot_nghiep/Model/User_info.dart';

import 'Login.dart';

class ActivityRegister extends StatefulWidget {
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
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      String userId = FirebaseFirestore.instance.collection('users').doc().id;

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
                        MaterialPageRoute(builder: (context) => Login(),
                        )
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Họ và tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bạn chưa nhập họ và tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bạn chưa nhập số điện thoại';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'Tài khoản'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bạn chưa nhập tài khoản';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bạn chưa nhập mật khẩu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
