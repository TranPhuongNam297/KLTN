import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoa_luan_tot_nghiep/Model/answer_mutiple.dart';
import 'package:khoa_luan_tot_nghiep/Model/chi_tiet_bo_de.dart';
import 'package:khoa_luan_tot_nghiep/Model/list_matching.dart';
import 'package:khoa_luan_tot_nghiep/Model/question_mutiple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/list_truefalse.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<chi_tiet_bo_de> chiTietList = [];

  @override
  void initState() {
    super.initState();
    testFirestoreFunction();
  }

  Future<void> testFirestoreFunction() async {
    await addQuestionAndAnswers(
      'Trên thiết bị Windows, người ta có thể truy cập thông tin hiển thị từ khu vực nào của Settings?',
      ['Devices', 'Personalization', 'Privacy', 'System'],
      0,  // Chọn đáp án đúng, ví dụ là 'Đáp án 3'
    );
  }

  Future<void> addQuestionAndAnswers(String questionText, List<String> answerTexts, int correctAnswerIndex) async {
    final firestore = FirebaseFirestore.instance;

    // Tạo một document mới cho list_question và lấy ID
    DocumentReference questionRef = firestore.collection('list_question').doc();
    String questionId = questionRef.id;

    // Thêm câu hỏi mới vào list_question
    await questionRef.set({
      'Id_Question': questionId,
      'Question': questionText,
      'Type': 'multiple_choice',
    });

    // Thêm các đáp án vào list_answer
    for (int i = 0; i < answerTexts.length; i++) {
      DocumentReference answerRef = firestore.collection('list_answer').doc();
      String answerId = answerRef.id;

      await answerRef.set({
        'Dap_An': answerTexts[i],
        'Id_DapAn': answerId,
        'Id_Question': questionId,
        'Is_Correct': i == correctAnswerIndex,  // Set true for the selected correct answer
      });
    }

    print('Data added successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Test'),
      ),
      body: Center(
        child: Text('Check console for Firestore test results.'),
      ),
    );
  }
}
