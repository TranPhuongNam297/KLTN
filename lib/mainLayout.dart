import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CompletedTests.dart';
import 'UserAccountManagement.dart';
import 'doTest.dart';
import 'Home.dart';
import 'Login.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('T.E.T Mass', style: TextStyle(color: Colors.white),),
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
                        title: Text('Thông báo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        content: Text('Bạn có chắc chắn muốn đăng xuất?', style: TextStyle(fontSize: 20),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Hủy', style: TextStyle(fontSize: 20),),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                            },
                            child: Text('Đăng xuất', style: TextStyle(fontSize: 20),),
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
            // Thay thế các Text widget bằng các trang thực tế của bạn
            Home(),
            doTest(),
            CompletedTests(),
            UserAccountManagement(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar (
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home,  size: 35),
              label: 'Trang chủ' ,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment, size: 35,),
              label: 'Làm bài',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save,  size: 35,),
              label: 'Hoàn thành',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box,  size: 35,),
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
