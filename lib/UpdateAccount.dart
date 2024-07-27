import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoa_luan_tot_nghiep/mainLayout.dart'; // Import file chứa trang chủ
import 'Login.dart';
import 'Model/User_info.dart';
import 'SharedPreferences/SharedPreferences.dart'; // Import file UserPreferences để lưu ID người dùng

class UpdateAccount extends StatefulWidget {
  final String uid;
  final bool isEditing;

  UpdateAccount({required this.uid, this.isEditing = false});

  @override
  _UpdateAccountState createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  String? _fullNameError;
  String? _phoneNumberError;
  String? _userNameError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.isEditing) {
        shopDiablog(context, "Thông báo", "Mời bạn nhập thông tin để hoàn tất tạo tài khoản");
      }
      _loadUserData();
    });
  }

  void _loadUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('User_info')
        .doc(widget.uid)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      _fullNameController.text = data['fullName'];
      _phoneNumberController.text = data['phoneNumber'];
      _userNameController.text = data['userName'];
      // Mật khẩu không được tải từ Firestore vì không được hiển thị hoặc cập nhật
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    setState(() {
      _fullNameError = null;
      _phoneNumberError = null;
      _userNameError = null;
    });

    bool isValid = true;

    if (_fullNameController.text.isEmpty) {
      setState(() {
        _fullNameError = 'Bạn chưa nhập họ và tên';
      });
      isValid = false;
    }

    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        _phoneNumberError = 'Bạn chưa nhập số điện thoại';
      });
      isValid = false;
    }

    if (_userNameController.text.isEmpty) {
      setState(() {
        _userNameError = 'Bạn chưa nhập tài khoản';
      });
      isValid = false;
    }

    if (!isValid) return;

    FocusScope.of(context).unfocus(); // Hide keyboard

    // Kiểm tra xem số điện thoại hoặc tài khoản đã tồn tại chưa
    bool phoneNumberExists = false;
    bool userNameExists = false;

    QuerySnapshot phoneQuery = await FirebaseFirestore.instance
        .collection('User_info')
        .where('phoneNumber', isEqualTo: _phoneNumberController.text)
        .get();

    if (phoneQuery.docs.isNotEmpty && phoneQuery.docs.first.id != widget.uid) {
      setState(() {
        _phoneNumberError = 'Số điện thoại đã tồn tại';
      });
      phoneNumberExists = true;
    }

    QuerySnapshot userNameQuery = await FirebaseFirestore.instance
        .collection('User_info')
        .where('userName', isEqualTo: _userNameController.text)
        .get();

    if (userNameQuery.docs.isNotEmpty && userNameQuery.docs.first.id != widget.uid) {
      setState(() {
        _userNameError = 'Tài khoản đã tồn tại';
      });
      userNameExists = true;
    }

    if (phoneNumberExists || userNameExists) return;

    User_info updatedUser = User_info(
      FullName: _fullNameController.text,
      Id_User: widget.uid,
      IsActive: false,
      PassWord: '1',
      PhoneNumber: _phoneNumberController.text,
      UserName: _userNameController.text,
    );

    try {
      await FirebaseFirestore.instance
          .collection('User_info')
          .doc(updatedUser.Id_User)
          .set(updatedUser.toMap());

      // Lưu ID người dùng vào SharedPreferences
      UserPreferences.saveUserId(updatedUser.Id_User);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cập nhật thành công'),
            content: Text('Thông tin tài khoản đã được cập nhật thành công!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => mainLayout()), // Replace HomePage() with your main screen widget
                        (route) => false, // Remove all previous routes
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
        title: Text(
          'Cập nhật',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white), // Set color for all icons in AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Cập nhật thông tin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 50),
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
                        errorText: _fullNameError,
                      ),
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
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: width * 0.6,
                      height: height * 0.07,
                      child: ElevatedButton(
                        child: Text(
                          'Cập nhật',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        onPressed: _updateUser,
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
    );
  }

  void shopDiablog(BuildContext context, String title, String message) {
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
