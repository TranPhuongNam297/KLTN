import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mainLayout extends StatelessWidget {

  Color color = Color(0xFF090979);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('ABCXYZ', style: TextStyle(color: Colors.white),),
          backgroundColor: color,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset('images/logoapp2.jpg'),
                decoration: BoxDecoration(
                  color: color,
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_box_rounded, color: Colors.black, size: 50),
                title: Text('Tài khoản của tôi', style: TextStyle(fontSize: 20)),
                onTap: () {
                  // Thêm hành động khi nhấn vào mục này
                },
              ),
              SizedBox(height: 25),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.black, size: 50),
                title: Text('Đăng xuất', style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 25),
              ListTile(
                leading: Icon(Icons.vpn_key, color: Colors.black, size: 50),
                title: Text('Mã kích hoạt', style: TextStyle(fontSize: 20)),
                onTap: () {
                  
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Text(
            'Hello World',
            style: TextStyle(fontSize: 24), // Đặt kích thước chữ
          ),
        ),
      ),
    );
  }
}
