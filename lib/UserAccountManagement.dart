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
  late TextEditingController _statusController;
  late TextEditingController _timeEndController;
  late TextEditingController _testCountController;
  late TextEditingController _practiceCountController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _userNameController = TextEditingController();
    _statusController = TextEditingController();
    _timeEndController = TextEditingController();
    _testCountController = TextEditingController();
    _practiceCountController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    _statusController.dispose();
    _timeEndController.dispose();
    _testCountController.dispose();
    _practiceCountController.dispose();
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

  Future<Map<String, dynamic>?> _getKeyActiveData(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final keyActiveDoc = await firestore
        .collection('Key_Active')
        .where('Id_User', isEqualTo: userId)
        .get();

    if (keyActiveDoc.docs.isNotEmpty) {
      return keyActiveDoc.docs.first.data();
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
                _statusController.text =
                userInfo.IsActive ? 'Đã kích hoạt' : 'Chưa kích hoạt';
              }

              return FutureBuilder<Map<String, dynamic>?>(
                future: _getKeyActiveData(userId),
                builder: (context, keyActiveSnapshot) {
                  if (keyActiveSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (keyActiveSnapshot.hasError) {
                    return Center(
                        child: Text('Đã xảy ra lỗi: ${keyActiveSnapshot.error}'));
                  } else if (!keyActiveSnapshot.hasData ||
                      keyActiveSnapshot.data == null) {
                    return Center(child: Text('Không có dữ liệu time_end'));
                  }

                  final keyActiveData = keyActiveSnapshot.data!;
                  _timeEndController.text = keyActiveData['Time_End'] as String;
                  _testCountController.text =
                      keyActiveData['Test']?.toString() ?? '0';
                  _practiceCountController.text =
                      keyActiveData['Practice']?.toString() ?? '0';

                  return SingleChildScrollView(
                    child: Padding(
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
                          _buildStatusTextField('Tình trạng tài khoản',
                              _statusController, userInfo.IsActive),
                          SizedBox(height: 16),
                          _buildTimeEndTextField(
                              'Thời hạn tài khoản', _timeEndController),
                          SizedBox(height: 16),
                          _buildCountTextField('Số lượng tạo bộ đề kiểm tra',
                              _testCountController),
                          SizedBox(height: 16),
                          _buildCountTextField('Số lượng tạo bộ đề luyện tập',
                              _practiceCountController),
                          SizedBox(height: 20),
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

  Widget _buildCountTextField(String label, TextEditingController controller) {
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

  Future<void> _updateUserInfo(String userId) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('User_info').doc(userId).update({
      'FullName': _fullNameController.text,
      'PhoneNumber': _phoneNumberController.text,
      'UserName': _userNameController.text,
    });
  }
}
