import 'package:shared_preferences/shared_preferences.dart';
import 'package:khoa_luan_tot_nghiep/Model/chi_tiet_bo_de.dart';

import '../Model/answer_mutiple.dart';
import '../Model/list_matching.dart';
import '../Model/list_truefalse.dart';
import '../Model/question_mutiple.dart';

class QuestionManager {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [];
  List<chi_tiet_bo_de> chiTietList = [];

  Future<void> testFirestoreFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idBoDe =
    prefs.getString('boDeId'); // Lấy id_bo_de từ SharedPreferences
    if (idBoDe != null) {
      chiTietList = await chi_tiet_bo_de.getChiTietBoDeByBoDeId(idBoDe);

      await transferData(); // Đảm bảo transferData hoàn thành trước khi tiếp tục
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
      print('Error getting list_truefalse data: $e');
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
      list_question question =
      await list_question.getListQuestionById(idCauHoi);
      List<list_answer> answers =
      await list_answer.getListAnswerById(question.Id_Question);
      return answers;
    } catch (e) {
      print('Error getting list_answer data: $e');
      throw Exception('Error getting multiple answers');
    }
  }

  Future<void> transferData() async {
    for (var chiTiet in chiTietList) {
      if (chiTiet.Type_cau_hoi == 'matching') {
              String idCauHoi = chiTiet.Id_cau_hoi;
              list_matching matchingData = await getListMatchingData(idCauHoi);
              Map<String, dynamic> listquestions = {
                'type': 'matching',
                'question': 'Ghép các câu sau đây:',
                'subQuestions': [],
              };
              listquestions['subQuestions'].add({
                'question': matchingData.Question,
                'correctAnswer': matchingData.CorrectAnswer
              });
              questions.add(listquestions);
      }
       else if (chiTiet.Type_cau_hoi == 'truefalse') {
        String idCauHoi = chiTiet.Id_cau_hoi;
        list_truefalse truefalseData = await getListTrueFalseData(idCauHoi);

        Map<String, dynamic> listquestions = {
          'type': 'truefalse',
          'subQuestions1': [],
        };

        listquestions['subQuestions1'].add({
          'question': truefalseData.Question,
          'correctAnswer': truefalseData.CorrectAnswer,
        });

        questions.add(listquestions);
      } else if (chiTiet.Type_cau_hoi == 'multiple_answer') {
        String idCauHoi = chiTiet.Id_cau_hoi;

        try {
          list_question question =
          await list_question.getListQuestionById(idCauHoi);
          List<list_answer> answers =
          await list_answer.getListAnswerById(question.Id_Question);

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
  }

  String get currentQuestion => questions[currentQuestionIndex]['question'];

  List<String>? get currentAnswers {
    if (questions[currentQuestionIndex]['type'] == 'multiple_choice' ||
        questions[currentQuestionIndex]['type'] == 'multiple_answer') {
      return questions[currentQuestionIndex]['answers'] as List<String>;
    } else {
      return null;
    }
  }

  dynamic get correctAnswer => questions[currentQuestionIndex]['correctAnswer'];

  String get currentQuestionType => questions[currentQuestionIndex]['type'];
}
