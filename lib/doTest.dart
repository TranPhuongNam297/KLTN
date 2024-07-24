import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/listContinue.dart';
import 'package:khoa_luan_tot_nghiep/listPrac.dart';
import 'listTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => listTask(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit_note_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                label: Text(
                  'Kiểm tra',
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
                      builder: (context) => listPrac(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.menu_book_sharp,
                  color: Colors.white,
                  size: 32,
                ),
                label: Text(
                  'Luyện tập',
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
