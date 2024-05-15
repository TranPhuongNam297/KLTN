import 'mainLayout.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage('images/background.jpg'), // Thay 'đường dẫn đến hình ảnh' bằng đường dẫn thực tế của bạn
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // Đặt màu nền của Scaffold thành trong suốt
          appBar: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent, // Đặt màu nền của AppBar thành trong suốt
            elevation: 0, // Loại bỏ đổ bóng của AppBar
          ),
        body: SingleChildScrollView( // Add this to avoid overflow
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'images/tetmass.png',
                  height: 250, // Điều chỉnh chiều cao của hình ảnh
                  width: 250, // Điều chỉnh chiều rộng của hình ảnh
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white, // Đặt màu nền của TextField thành trắng
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Tài khoản',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white, // Đặt màu nền của TextField thành trắng
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Mật khẩu',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Add action here
                      },
                      child: Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 20
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Container(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    child: Text('Đăng nhập', style: TextStyle(fontSize: 15, color: Colors.white),),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mainLayout()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo, // Tô màu nút thành indigo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Làm bo tròn góc của nút
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the row content
                  children: <Widget>[
                    Text('Bạn chưa có tài khoản?', style: TextStyle(fontSize: 20),),
                    TextButton(
                      onPressed: () {
                        // Add action here
                      },
                      child: Text(
                        'Đăng kí ngay',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Hoặc',
                        style: TextStyle(color: Colors.black, fontSize: 20 ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 350,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 30,
                      width: 30,
                    ),
                    label: Text('Tiếp tục với Google', style: TextStyle(fontSize: 15, color: Colors.white),),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo, // Tô màu nút thành indigo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Làm bo tròn góc của nút
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
     ),
    );
  }
}
