import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'doTest.dart';
import 'home.dart';

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
              ListTile(
                leading: Icon(Icons.account_box_rounded, color: Colors.indigo, size: 50),
                title: Text('Tài khoản của tôi', style: TextStyle(fontSize: 20)),
                onTap: () {
                  // Thêm hành động khi nhấn vào mục này
                },
              ),
              SizedBox(height: 25),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.indigo, size: 50),
                title: Text('Đăng xuất', style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 25),
              ListTile(
                leading: Icon(Icons.vpn_key, color: Colors.indigo, size: 50),
                title: Text('Mã kích hoạt', style: TextStyle(fontSize: 20)),
                onTap: () {

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
            home(),
            doTest(),
            Text('Khóa học'),
            Text('Sách'),
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
              icon: Icon(Icons.book,  size: 35,),
              label: 'Khóa học',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books,  size: 35,),
              label: 'Sách',
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
