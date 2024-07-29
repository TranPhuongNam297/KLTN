import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model/User_info.dart';
import 'SharedPreferences/SharedPreferences.dart';

class UserAccountManagement extends StatefulWidget {
  @override
  _UserAccountManagementState createState() => _UserAccountManagementState();
}

class _UserAccountManagementState extends State<UserAccountManagement> {
  bool _isEditing = false;
  late User_info userInfo;

  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<User_info?> _getUserInfo(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('User_info').doc(userId).get();

    if (userDoc.exists) {
      return User_info.fromMap(userDoc.data()!);
    } else {
      return null;
    }
  }

  Future<String?> _getUserId() async {
    return await UserPreferences.getUserId();
  }

  Future<bool> _isUserNameTaken(String userName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('User_info')
        .where('userName', isEqualTo: userName)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> _isPhoneNumberTaken(String phoneNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('User_info')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  bool _validatePhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^0\d{9}$');
    return regex.hasMatch(phoneNumber);
  }

  bool _validateUserName(String userName) {
    return userName.length >= 8 && userName.length <= 20;
  }

  Future<void> _updateUserInfo(String userId) async {
    final firestore = FirebaseFirestore.instance;

    final newUserName = _userNameController.text;
    final newPhoneNumber = _phoneNumberController.text;

    // Validate phone number and username
    if (!_validatePhoneNumber(newPhoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số điện thoại không hợp lệ')),
      );
      return;
    }

    if (!_validateUserName(newUserName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tên tài khoản phải có từ 8 đến 20 ký tự')),
      );
      return;
    }

    // Check if the new username or phone number is already taken
    bool isUserNameTaken = await _isUserNameTaken(newUserName);
    bool isPhoneNumberTaken = await _isPhoneNumberTaken(newPhoneNumber);

    if (isUserNameTaken && userInfo.UserName != newUserName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tên tài khoản đã tồn tại')),
      );
      return;
    }

    if (isPhoneNumberTaken && userInfo.PhoneNumber != newPhoneNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số điện thoại đã tồn tại')),
      );
      return;
    }

    await firestore.collection('User_info').doc(userId).update({
      'fullName': _fullNameController.text,
      'phoneNumber': newPhoneNumber,
      'userName': newUserName,
      // Keep password unchanged for security reasons
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Thông tin tài khoản',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Open Sans'),
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _getUserId(),
        builder: (context, userIdSnapshot) {
          if (userIdSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (userIdSnapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${userIdSnapshot.error}'));
          } else if (!userIdSnapshot.hasData || userIdSnapshot.data == null) {
            return Center(child: Text('Không có ID người dùng'));
          }

          final userId = userIdSnapshot.data!;

          return FutureBuilder<User_info?>(
            future: _getUserInfo(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Không có dữ liệu'));
              }

              userInfo = snapshot.data!;
              if (!_isEditing) {
                _fullNameController.text = userInfo.FullName;
                _phoneNumberController.text = userInfo.PhoneNumber;
                _userNameController.text = userInfo.UserName;
                _passwordController.text = userInfo.PassWord;
              } else {
                _fullNameController.clear();
                _phoneNumberController.clear();
                _userNameController.clear();
                _passwordController.clear();
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabeledTextField('Họ và tên', _fullNameController, _isEditing),
                      SizedBox(height: 16),
                      _buildLabeledTextField('Số điện thoại', _phoneNumberController, _isEditing),
                      SizedBox(height: 16),
                      _buildLabeledTextField('Tên người dùng', _userNameController, _isEditing),
                      SizedBox(height: 16),
                      _buildPasswordTextField('Mật khẩu', _passwordController),
                      SizedBox(height: 16),
                      Text(
                        'Tình trạng tài khoản: ${userInfo.IsActive ? 'Đã kích hoạt' : 'Chưa kích hoạt'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: () async {
                            if (_isEditing) {
                              // Save the changes
                              await _updateUserInfo(userId);
                            }
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                          child: Text(
                            _isEditing ? 'Lưu' : 'Chỉnh sửa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLabeledTextField(String labelText, TextEditingController controller, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: enabled ? 'Nhập $labelText' : controller.text,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: controller,
          enabled: false,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '*************', // Always show asterisks
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
