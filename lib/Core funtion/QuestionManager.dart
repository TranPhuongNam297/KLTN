import 'package:cloud_firestore/cloud_firestore.dart';
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
    String? idBoDe = prefs.getString('boDeId'); // Lấy id_bo_de từ SharedPreferences
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
      list_question question = await list_question.getListQuestionById(idCauHoi);
      List<list_answer> answers = await list_answer.getListAnswerById(question.Id_Question);
      return answers;
    } catch (e) {
      print('Error getting list_answer data: $e');
      throw Exception('Error getting multiple answers');
    }
  }

  Future<void> transferData() async {
    List<Map<String, dynamic>> matchingQuestionTemplate = List.generate(10, (_) => {
      'type': 'matching',
      'question': 'Ghép các câu sau đây:',
      'subQuestions': [],
    });

    List<Map<String, dynamic>> trueFalseQuestionTemplate = List.generate(10, (_) => {
      'type': 'truefalse',
      'subQuestions1': [],
    });

    int matchingQuestionIndex = 0;
    int trueFalseQuestionIndex = 0;

    for (var chiTiet in chiTietList) {
      if (chiTiet.Type_cau_hoi == 'matching') {
        String idCauHoi = chiTiet.Id_cau_hoi;
        list_matching matchingData = await getListMatchingData(idCauHoi);
        matchingQuestionTemplate[matchingQuestionIndex]['subQuestions'].add({
          'question': matchingData.Question,
          'correctAnswer': matchingData.CorrectAnswer,
          'Id': idCauHoi,
        });
        if (matchingQuestionTemplate[matchingQuestionIndex]['subQuestions'].length == 4) {
          matchingQuestionIndex++;
        }
      } else if (chiTiet.Type_cau_hoi == 'truefalse') {
        String idCauHoi = chiTiet.Id_cau_hoi;
        list_truefalse truefalseData = await getListTrueFalseData(idCauHoi);
        trueFalseQuestionTemplate[trueFalseQuestionIndex]['subQuestions1'].add({
          'question': truefalseData.Question,
          'correctAnswer': truefalseData.CorrectAnswer,
          'Id': idCauHoi,
        });
        if (trueFalseQuestionTemplate[trueFalseQuestionIndex]['subQuestions1'].length == 4) {
          trueFalseQuestionIndex++;
        }
      } else if (chiTiet.Type_cau_hoi == 'multiple_answer') {
        String idCauHoi = chiTiet.Id_cau_hoi;

        try {
          list_question question = await list_question.getListQuestionById(idCauHoi);
          List<list_answer> answers = await list_answer.getListAnswerById(question.Id_Question);

          List<String> answerTexts = [];
          List<String> correctAnswers = [];

          answers.forEach((answer) {
            answerTexts.add(answer.Dap_An);
            if (answer.Is_Correct == true) {
              correctAnswers.add(answer.Dap_An);
            }
          });

          Map<String, dynamic> listquestions = {
            'type': 'multiple_answer',
            'question': question.Question,
            'answers': answerTexts,
            'correctAnswer': correctAnswers,
            'Id': idCauHoi,
          };

          questions.add(listquestions);
        } catch (e) {
          print('Error processing multiple_answer question: $e');
        }
      } else if (chiTiet.Type_cau_hoi == 'multiple_choice') {
        String idCauHoi = chiTiet.Id_cau_hoi;

        try {
          list_question question = await list_question.getListQuestionById(idCauHoi);
          List<list_answer> answers = await list_answer.getListAnswerById(question.Id_Question);

          List<String> answerTexts = [];
          String? correctAnswer;

          answers.forEach((answer) {
            answerTexts.add(answer.Dap_An);
            if (answer.Is_Correct) {
              correctAnswer = answer.Dap_An;
            }
          });

          Map<String, dynamic> listquestions = {
            'type': 'multiple_choice',
            'question': question.Question,
            'answers': answerTexts,
            'correctAnswer': correctAnswer,
            'Id': idCauHoi,
          };

          questions.add(listquestions);
        } catch (e) {
          print('Error processing multiple_choice question: $e');
        }
      }
    }
    matchingQuestionTemplate.forEach((question) {
      if (question['subQuestions'].isNotEmpty) {
        questions.add(question);
      }
    });

    trueFalseQuestionTemplate.forEach((question) {
      if (question['subQuestions1'].isNotEmpty) {
        questions.add(question);
      }
    });
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
  String get currentQuestionId {
    if (questions.isNotEmpty && currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex]['Id'] ?? '';
    } else {
      return '';
    }
  }
  String get currentQuestionType => questions[currentQuestionIndex]['type'];


  Future<void> updateChiTietBoDe(String isCorrect, String id, String idBoDe) async {
    try {
      // Truy cập vào bảng chi_tiet_bo_de
      CollectionReference chiTietBoDeRef = FirebaseFirestore.instance.collection('chi_tiet_bo_de');
      // Tìm tài liệu cụ thể dựa trên Id và Id_bo_de
      QuerySnapshot snapshot = await chiTietBoDeRef
          .where('Id_cau_hoi', isEqualTo: id)
          .where('Id_bo_de', isEqualTo: idBoDe)
          .get();
      if (snapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên (giả sử Id và Id_bo_de là duy nhất)
        DocumentSnapshot document = snapshot.docs.first;
        // Cập nhật giá trị IsCorrect
        await document.reference.update({'IsCorrect': isCorrect});
        print("update ok");
      } else {
        print("update k dc");
      }
    } catch (e) {
      print('Có lỗi xảy ra: $e');
    }
  }
  Future<void> updateChiTietBoDeMutipleAnswers(List<String> answers, String id, String idBoDe) async {
    try {
      // Truy cập vào bảng chi_tiet_bo_de
      CollectionReference chiTietBoDeRef = FirebaseFirestore.instance.collection('chi_tiet_bo_de');

      // Tìm tài liệu cụ thể dựa trên Id và Id_bo_de
      QuerySnapshot snapshot = await chiTietBoDeRef
          .where('Id_cau_hoi', isEqualTo: id)
          .where('Id_bo_de', isEqualTo: idBoDe)
          .get();
      if (snapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên (giả sử Id và Id_bo_de là duy nhất)
        DocumentSnapshot document = snapshot.docs.first;

        // Chuyển đổi danh sách thành chuỗi
        String answersString = answers.join('+');
        // Cập nhật giá trị IsCorrect
        await document.reference.update({'IsCorrect': answersString});
        print("update ok");
      } else {
        print("update k dc");
      }
    } catch (e) {
      print('Có lỗi xảy ra: $e');
    }
  }

  Future<void> updateChiTietBoDeMutipleChoise(String Answers, String id, String idBoDe) async {
    try {
      // Truy cập vào bảng chi_tiet_bo_de
      CollectionReference chiTietBoDeRef = FirebaseFirestore.instance.collection('chi_tiet_bo_de');
      // Tìm tài liệu cụ thể dựa trên Id và Id_bo_de
      QuerySnapshot snapshot = await chiTietBoDeRef
          .where('Id_cau_hoi', isEqualTo: id)
          .where('Id_bo_de', isEqualTo: idBoDe)
          .get();
      if (snapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên (giả sử Id và Id_bo_de là duy nhất)
        DocumentSnapshot document = snapshot.docs.first;
        // Cập nhật giá trị IsCorrect
        await document.reference.update({'IsCorrect': Answers});
        print("update ok");
      } else {
        print("update k dc");
      }
    } catch (e) {
      print('Có lỗi xảy ra: $e');
    }
  }
}