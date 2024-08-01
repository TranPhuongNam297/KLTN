import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/LoadingScreen.dart';
import 'package:khoa_luan_tot_nghiep/Model/User_info.dart';
import 'package:khoa_luan_tot_nghiep/mainLayout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

class ActivityRegister extends StatefulWidget {
  final String uid;

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
  String? _phoneNumberError;
  String? _userNameError;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bạn chưa nhập họ và tên';
    }
    if (RegExp(r'\d').hasMatch(value)) {
      return 'Họ và tên không được chứa số';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bạn chưa nhập mật khẩu';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải dài ít nhất 8 ký tự';
    }
    if (value.length > 20) {
      return 'Mật khẩu không được dài quá 20 ký tự';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một chữ cái in hoa';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một số';
    }
    if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bạn chưa nhập số điện thoại';
    }
    if (value.length != 10 || !value.startsWith('0')) {
      return 'Số điện thoại phải có 10 số và bắt đầu bằng 0';
    }
    return null;
  }

  String? _validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bạn chưa nhập tài khoản';
    }
    if (value.length < 8 || value.length > 20) {
      return 'Tài khoản phải có từ 8 đến 20 ký tự';
    }
    return null;
  }

  Future<void> _checkExistingUserData() async {
    setState(() {
      _isLoading = true;
    });

    String phoneNumber = _phoneNumberController.text;
    String userName = _userNameController.text;

    bool phoneNumberExists = await FirebaseFirestore.instance
        .collection('User_info')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty);

    bool userNameExists = await FirebaseFirestore.instance
        .collection('User_info')
        .where('userName', isEqualTo: userName)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty);

    setState(() {
      _phoneNumberError = phoneNumberExists ? 'Số điện thoại đã tồn tại' : null;
      _userNameError = userNameExists ? 'Tài khoản đã tồn tại' : null;
      _isLoading = false;
    });

    if (_phoneNumberError != null || _userNameError != null) {
      // Nếu có lỗi, không tiếp tục đăng ký
      return;
    }

    // Nếu không có lỗi, thực hiện đăng ký
    _registerUser();
  }

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Hide keyboard
      String userId = widget.uid.isNotEmpty ? widget.uid : FirebaseFirestore.instance.collection('User_info').doc().id;
      User_info newUser = User_info(
        FullName: _fullNameController.text,
        Id_User: userId,
        IsActive: false,
        PassWord: _passwordController.text,
        PhoneNumber: _phoneNumberController.text,
        UserName: _userNameController.text,
      );
      print(newUser.Id_User);
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
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('idUser', newUser.Id_User);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => mainLayout()),
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Đăng ký',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/register_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
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
                          validator: _validateFullName,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Số điện thoại',
                            errorText: _phoneNumberError,
                          ),
                          validator: _validatePhoneNumber,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            labelText: 'Tài khoản',
                            errorText: _userNameError,
                          ),
                          validator: _validateUserName,
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
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator() // Hiệu ứng loading
                            : Container(
                          width: width * 0.6,
                          height: height * 0.07,
                          child: ElevatedButton(
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            onPressed: () async {
                              // Kiểm tra dữ liệu không đồng bộ trước khi gọi đăng ký
                              await _checkExistingUserData();
                            },
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
}
