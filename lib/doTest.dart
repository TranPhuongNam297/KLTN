import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/listContinue.dart';
import 'listContinue.dart';

class doTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Handle "Làm bài mới" button press
                },
                icon: Icon(
                  Icons.edit_note_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                label: Text(
                  'Làm bài mới',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 75),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listContinue(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.menu_book_sharp,
                  color: Colors.white,
                  size: 32,
                ),
                label: Text(
                  'Tiếp tục làm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 75),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle "Đã hoàn thành" button press
                },
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                  size: 32,
                ),
                label: Text(
                  'Đã hoàn thành',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 75),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
