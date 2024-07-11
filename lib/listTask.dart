import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/bo_de.dart';
import 'TaskItem.dart';

class listTask extends StatefulWidget {
  @override
  _ListTaskState createState() => _ListTaskState();
}

class _ListTaskState extends State<listTask> {
  List<Map<String, dynamic>> boDeList = [];

  @override
  void initState() {
    super.initState();
    _fetchBoDeList();
  }

  Future<void> _fetchBoDeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('idUser');

    if (userId == null) {
      print("User ID not found in SharedPreferences");
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Bo_de')
        .where('Id_user_tao', isEqualTo: userId)
        .get();

    setState(() {
      boDeList = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  Future<void> _createNewBoDe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('idUser');

    if (userId == null) {
      print("Could not fetch user ID from SharedPreferences");
      return;
    }

    String newId = FirebaseFirestore.instance.collection('Bo_de').doc().id;
    String ngayTao = DateFormat('yyyy-MM-dd').format(DateTime.now());

    bo_de newBoDe = bo_de(
      Id: newId,
      Id_user_tao: userId,
      Ngay_tao: ngayTao,
      Tinh_trang: false,
    );

    await FirebaseFirestore.instance.collection('Bo_de').doc(newId).set(newBoDe.toMap());

    setState(() {
      boDeList.add(newBoDe.toMap());
    });
  }

  void _showCreateNewBoDeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có muốn tạo bộ đề mới không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _createNewBoDe(); // Create new test set
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Danh sách bộ đề', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: boDeList.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  title: 'Bộ đề ${index + 1}',
                  imageUrl: 'images/tetmass3.png',
                  onTap: () {
                    // Xử lý khi người dùng nhấn vào từng mục "bộ đề"
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: Colors.indigo, // Replace with your desired color
          child: InkWell(
            splashColor: Colors.white, // Splash color when tapped
            child: SizedBox(width: 56, height: 56, child: Icon(Icons.add, color: Colors.white)),
            onTap: _showCreateNewBoDeDialog,
          ),
        ),
      ),
    );
  }
}
