import 'package:flutter/material.dart';
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

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void _showActivationCodeDialog(BuildContext context) {
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
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Giảm chiều cao ở đây
                  ),
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
