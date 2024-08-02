import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CompletedTests.dart';
import 'Home.dart';
import 'Login.dart';
import 'UpdateAccount.dart';
import 'UserAccountManagement.dart';
import 'doTest.dart'; // Import màn hình đăng nhập

class mainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<mainLayout> {
  int _selectedIndex = 0;
  final _pageController = PageController();
  final _keycontroller = TextEditingController();
  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }
  Future<void> _activateKey(BuildContext context, String key) async {
    try {
      // Lấy user ID từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('idUser');
      if (userId == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Không tìm thấy thông tin người dùng.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Truy xuất mã key từ Firestore
      DocumentSnapshot<Map<String, dynamic>> keyDoc = await FirebaseFirestore.instance
          .collection('Key_Active')
          .doc(key)
          .get();

      if (!keyDoc.exists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Mã key không tồn tại.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Kiểm tra xem mã key đã được sử dụng chưa
      bool isUsed = keyDoc.data()?['Used'] ?? true;
      if (isUsed) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Mã key đã được kích hoạt.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Lấy thông tin ngày bắt đầu và số ngày hoạt động
      int daysActive = keyDoc.data()?['Date'] ?? 0;
      String timeStart = DateFormat('dd-MM-yyyy').format(DateTime.now());
      String timeEnd = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: daysActive)));

      // Cập nhật thông tin mã key trong Firestore
      await FirebaseFirestore.instance.collection('Key_Active').doc(key).update({
        'Id_User': userId,
        'Time_Start': timeStart,
        'Time_End': timeEnd,
        'Used': true,
      });
      await FirebaseFirestore.instance.collection('User_info').doc(userId).update({
        'isActive': true,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Kích hoạt mã key thành công.', style: TextStyle(fontSize: 20),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Đóng dialog và quay lại màn hình trước
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Có lỗi xảy ra: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  void _showActivationCodeDialog(BuildContext context) {
    final TextEditingController _keyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận mã key'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ),
                    hintText: 'Nhập mã key',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  ),
                  controller: _keyController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                String key = _keyController.text.trim();
                if (key.isNotEmpty) {
                  _activateKey(context, key);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập mã key.')),
                  );
                }
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Xóa dữ liệu trong SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Chuyển hướng đến màn hình đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'T.E.T Mass',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset('images/tetmass2.png'),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 25),
              ListTile(
                leading: Icon(Icons.vpn_key, color: Colors.indigo, size: 50),
                title: Text('Mã kích hoạt', style: TextStyle(fontSize: 20)),
                onTap: () {
                  _showActivationCodeDialog(context);
                },
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.indigo, size: 50),
                title: Text('Đăng xuất', style: TextStyle(fontSize: 20)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Thông báo',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Bạn có chắc chắn muốn đăng xuất?',
                          style: TextStyle(fontSize: 20),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Hủy',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Đóng dialog
                              _logout(context); // Đăng xuất
                            },
                            child: Text(
                              'Đăng xuất',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            Home(),
            doTest(),
            CompletedTests(),
            UserAccountManagement(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 35),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment, size: 35),
              label: 'Làm bài',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save, size: 35),
              label: 'Hoàn thành',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box, size: 35),
              label: 'Tài khoản',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
