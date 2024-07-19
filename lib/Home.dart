import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ActivityItemMain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> activityList = [];
  bool _isLoading = false; // Track loading state for popup

  @override
  void initState() {
    super.initState();
    _fetchActivityList();
  }

  Future<void> _fetchActivityList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('idUser');

    if (userId == null) {
      print("User ID not found in SharedPreferences");
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Bo_de')
        .where('Id_user_tao', isEqualTo: userId)
        .where('Tinh_trang', isEqualTo: false)
        .get();

    setState(() {
      activityList = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Những hoạt động gần đây',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
              Divider(
                color: Colors.black.withOpacity(0.5),
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: activityList.length,
                  itemBuilder: (context, index) {
                    return ActivityItemMain(
                      title: 'Bộ đề ${index + 1}',
                      boDeId: activityList[index]['Id'], // Truyền boDeId vào ActivityItemMain
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isLoading) // Show loading indicator
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
