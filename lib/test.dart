import 'package:flutter/material.dart';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idBoDe = 'JI2ryEqO9R4DnGBEWxKF'; // Lấy id_bo_de từ SharedPreferences

    if (idBoDe != null) {
      chiTietList = await chi_tiet_bo_de.getChiTietBoDeByBoDeId(idBoDe);

      // Hiển thị kết quả trong console để kiểm tra
      chiTietList.forEach((chiTiet) {
        // print('Id: ${chiTiet.Id}, Id_bo_de: ${chiTiet.Id_bo_de}, Id_cau_hoi: ${chiTiet.Id_cau_hoi}, Type_cau_hoi: ${chiTiet.Type_cau_hoi}, IsCorrect: ${chiTiet.IsCorrect}');
      });

      transferData();
    } else {
      print('id_bo_de is null or empty');
    }
  }

  Future<list_matching> getListMatchingData(String idCauHoi) async {
    try {
      return await list_matching.getListMatchingById(idCauHoi);
    } catch (e) {
      print('Error getting list_matching data: $e');
      return list_matching(
        CorrectAnswer: '',
        Id_Question: '',
        Question: '',
        Type: '',
      );
    }
  }

  Future<list_truefalse> getListTrueFalseData(String idCauHoi) async {
    try {
      return await list_truefalse.getListTrueFalseById(idCauHoi);
    } catch (e) {
      print('Error getting list_matching data: $e');
      return list_truefalse(
        CorrectAnswer: false,
        Id_Question: '',
        Question: '',
        Type: '',
      );
    }
  }
  Future<List<list_answer>> getListMutipleAnswer(String idCauHoi) async {
    try {
      list_question question = await list_question.getListQuestionById(idCauHoi);
      List<list_answer> answers = await list_answer.getListAnswerById(question.Id_Question);
      return answers;
    } catch (e) {
      print('Error getting list_answer data: $e');
      throw Exception('Error getting multiple answers');
    }
  }
  Future<void> transferData() async {
    List<Map<String, dynamic>> questions = [];

    for (var chiTiet in chiTietList) {
      if (chiTiet.Type_cau_hoi == 'matching') {
        String idCauHoi = chiTiet.Id_cau_hoi;
        list_matching matchingData = await getListMatchingData(idCauHoi);

        Map<String, dynamic> listquestions = {
          'type': 'matching',
          'question': 'Ghép các câu sau đây:',
          'subQuestions': [],
        };
        listquestions['subQuestions'] = matchingData.toMap();
        questions.add(listquestions);

      } else if (chiTiet.Type_cau_hoi == 'truefalse') {
        String idCauHoi = chiTiet.Id_cau_hoi;
        list_truefalse truefalseData = await getListTrueFalseData(idCauHoi);

        // Đảm bảo chỉ thêm một lần mỗi câu hỏi
        Map<String, dynamic> listquestions = {
          'type': 'truefalse',
          'subQuestions1': [],
        };

        // Thêm câu hỏi và câu trả lời đúng
        listquestions['subQuestions1'].add({
          'question': truefalseData.Question,
          'correctAnswer': truefalseData.CorrectAnswer,
        });

        questions.add(listquestions);

      } else if (chiTiet.Type_cau_hoi == 'multiple_answer') {
        String idCauHoi = chiTiet.Id_cau_hoi;

        try {
          list_question question = await list_question.getListQuestionById(idCauHoi);
          List<list_answer> answers = await list_answer.getListAnswerById(question.Id_Question);

          List<String> answerTexts = [];
          List<String> correctAnswers = [];

          answers.forEach((answer) {
            answerTexts.add(answer.Dap_An);
            if (answer.Is_Correct) {
              correctAnswers.add(answer.Dap_An);
            }
          });

          Map<String, dynamic> listquestions = {
            'type': 'multiple_answer',
            'question': question.Question,
            'answers': answerTexts,
            'correctAnswer': correctAnswers,
          };

          questions.add(listquestions);

        } catch (e) {
          print('Error processing multiple_answer question: $e');
        }
      }
    }

    // In danh sách questions ra console để kiểm tra
    questions.forEach((question) {
      print('Question: ${question['question']}');
      if (question['type'] == 'matching') {
        print('SubQuestions: ${question['subQuestions']}');
      } else if (question['type'] == 'truefalse') {
        print('SubQuestions1: ${question['subQuestions1']}');
      } else if (question['type'] == 'multiple_answer') {
        print('Answers: ${question['answers']}');
        print('Correct Answers: ${question['correctAnswer']}');
      }
    });
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
