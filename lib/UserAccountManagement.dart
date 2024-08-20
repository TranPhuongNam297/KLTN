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
  late TextEditingController _statusController;
  late TextEditingController _timeEndController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _statusController = TextEditingController();
    _timeEndController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _statusController.dispose();
    _timeEndController.dispose();
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

  bool _validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$');
    return regex.hasMatch(password);
  }

  Future<void> _updateUserInfo(String userId) async {
    final firestore = FirebaseFirestore.instance;

    final newPhoneNumber = _phoneNumberController.text;
    final newPassword = _passwordController.text;

    if (!_validatePhoneNumber(newPhoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số điện thoại không hợp lệ')),
      );
      return;
    }

    if (!_validatePassword(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Mật khẩu phải từ 8 đến 20 ký tự, có ít nhất 1 chữ hoa, 1 số và 1 ký tự đặc biệt')),
      );
      return;
    }

    bool isPhoneNumberTaken = await _isPhoneNumberTaken(newPhoneNumber);

    if (isPhoneNumberTaken && userInfo.PhoneNumber != newPhoneNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số điện thoại đã tồn tại')),
      );
      return;
    }

    await firestore.collection('User_info').doc(userId).update({
      'fullName': _fullNameController.text,
      'phoneNumber': newPhoneNumber,
      'password': newPassword,
    });
  }

  Future<String?> _getTimeEnd(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final keyActiveDoc = await firestore
        .collection('Key_Active')
        .where('Id_User', isEqualTo: userId)
        .get();

    if (keyActiveDoc.docs.isNotEmpty) {
      return keyActiveDoc.docs.first['Time_End'] as String;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Thông tin tài khoản',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans'),
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _getUserId(),
        builder: (context, userIdSnapshot) {
          if (userIdSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (userIdSnapshot.hasError) {
            return Center(
                child: Text('Đã xảy ra lỗi: ${userIdSnapshot.error}'));
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
                _statusController.text =
                userInfo.IsActive ? 'Đã kích hoạt' : 'Chưa kích hoạt';
              }

              return FutureBuilder<String?>(
                future: _getTimeEnd(userId),
                builder: (context, timeEndSnapshot) {
                  if (timeEndSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (timeEndSnapshot.hasError) {
                    return Center(
                        child: Text('Đã xảy ra lỗi: ${timeEndSnapshot.error}'));
                  } else if (!timeEndSnapshot.hasData ||
                      timeEndSnapshot.data == null) {
                    return Center(child: Text('Không có dữ liệu time_end'));
                  }

                  _timeEndController.text = timeEndSnapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabeledTextField(
                            'Họ và tên', _fullNameController, _isEditing),
                        SizedBox(height: 16),
                        _buildLabeledTextField('Số điện thoại',
                            _phoneNumberController, _isEditing),
                        SizedBox(height: 16),
                        _buildLabeledTextField(
                            'Tên người dùng', _userNameController, false), // Tên người dùng không thể chỉnh sửa
                        SizedBox(height: 16),
                        _buildPasswordTextField(
                            'Mật khẩu', _passwordController, _isEditing), // Mật khẩu có thể chỉnh sửa khi _isEditing là true
                        SizedBox(height: 16),
                        _buildStatusTextField('Tình trạng tài khoản',
                            _statusController, userInfo.IsActive),
                        SizedBox(height: 16),
                        _buildTimeEndTextField(
                            'Thời hạn tài khoản', _timeEndController),
                        SizedBox(height: 50),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () async {
                                if (_isEditing) {
                                  await _updateUserInfo(userId);
                                }

                                bool hasValidationError =
                                    _phoneNumberController.text !=
                                        userInfo.PhoneNumber;

                                setState(() {
                                  _isEditing =
                                      hasValidationError || !_isEditing;
                                });
                              },
                              child: Text(
                                _isEditing ? 'Lưu' : 'Chỉnh sửa',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLabeledTextField(
      String label, TextEditingController controller, bool isEnabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          enabled: isEnabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField(
      String label, TextEditingController controller, bool isEnabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          enabled: isEnabled,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTextField(
      String label, TextEditingController controller, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTimeEndTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}
