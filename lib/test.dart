import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoa_luan_tot_nghiep/Model/list_truefalse.dart';

class TestPage extends StatefulWidget {

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String? idQuestion;
  String question = "Tài khoản ngân hàng trực tuyến là một phần của nhận dạng kĩ thuật số";
  @override
  void initState() {
    super.initState();
    // Gọi hàm testFirestoreFunction khi initState được gọi
    testFirestoreFunction();
  }

  void testFirestoreFunction() {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("list_truefalse");
    collectionReference.add({
      'CorrectAnswer': true,
      'Id_Question': idQuestion,
      'Question': question,
      'Type': "trueflase",
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Test'),
      ),
      body: Center(
        child: Text('Kiểm tra console để xem kết quả thử nghiệm Firestore.'),

      ),
    );
  }
}
