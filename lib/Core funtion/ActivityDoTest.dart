import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'QuestionManager.dart';
import '../CountdownTimer.dart';
import 'Result.dart';
import '../StarButton.dart';
import '../mainLayout.dart';
import 'MatchingQuestion.dart';
import '../ConfirmDialog.dart';
import 'MultipleChoiceQuestion.dart';
import 'TrueFalseQuestion.dart';
import 'MultipleAnswerQuestion.dart';
import '../Home.dart';

class ActivityDoTest extends StatefulWidget {
  @override
  _ActivityDoTestState createState() => _ActivityDoTestState();
}

class _ActivityDoTestState extends State<ActivityDoTest> {
  final QuestionManager questionManager = QuestionManager();
  final CountdownTimer countdownTimer = CountdownTimer();
  final Home home = Home();
  int correctCount = 0;
  Map<int, dynamic> selectedAnswers = {};
  Map<int, bool> answeredCorrectly = {};
  bool isMatchingQuestion = false;
  List<bool?> questionResults = [];
  Future<void>? _initialization;
  String? idBoDe;
  String? mode;
  @override
  void initState() {
    super.initState();
    countdownTimer.startTimer();
    _initialization = questionManager.testFirestoreFunction().then((_) {
      setState(() {
        questionResults = List<bool?>.filled(questionManager.questions.length, null);
        for (int i = 0; i < questionManager.questions.length; i++) {
          selectedAnswers[i] = null;
          answeredCorrectly[i] = false;
        }
        _checkMatchingQuestion();
      });
    });
    _loadIdBoDe();
  }
  Future<void> _loadIdBoDe() async {
    final prefs = await SharedPreferences.getInstance();
    idBoDe = prefs.getString('boDeId')!;
    mode = prefs.getString("mode")!;
    print(mode);
  }
  void _checkMatchingQuestion() {
    setState(() {
      isMatchingQuestion = questionManager.currentQuestionType == 'matching';
    });
  }
//1 dap an dung
  void _handleAnswer(String selectedAnswer) {
    final correctAnswer = questionManager.correctAnswer;
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = answeredCorrectly[currentIndex] ?? false;
    setState(() {
      selectedAnswers[currentIndex] = selectedAnswer;
      bool isCorrect = selectedAnswer == correctAnswer;
      answeredCorrectly[currentIndex] = isCorrect;

      // Chỉ cộng hoặc trừ điểm nếu câu trả lời thay đổi từ sai sang đúng hoặc ngược lại
      if (isCorrect && !wasCorrect) {
        correctCount++;
        questionManager.updateChiTietBoDe(true, questionManager.currentQuestionId, idBoDe!);
      } else if (!isCorrect && wasCorrect) {
        correctCount--;
        questionManager.updateChiTietBoDe(false, questionManager.currentQuestionId, idBoDe!);
      }
    print(correctCount);
      // Lưu kết quả cho câu hỏi hiện tại
      questionResults[currentIndex] = isCorrect;
    });
  }


  void _handleTrueFalseAnswer(bool allCorrect) {
    print(allCorrect);
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = answeredCorrectly[currentIndex] ?? false;
    setState(() {
      questionResults[currentIndex] = allCorrect;
      if (allCorrect) {
        if (!wasCorrect) {
          correctCount++;
          questionManager.updateChiTietBoDe(true,questionManager.currentQuestionId,idBoDe!);
        }
      } else {
        if (wasCorrect) {
           correctCount--;
          questionManager.updateChiTietBoDe(false,questionManager.currentQuestionId,idBoDe!);
        }
      }
    });
  }

  void _handleMatchingAnswer(bool isAllCorrect) {
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = answeredCorrectly[currentIndex] ?? false;
    setState(() {
      questionResults[currentIndex] = isAllCorrect;
      if (isAllCorrect) {
        if (!wasCorrect) {
           correctCount++;
          //questionManager.updateChiTietBoDe(true,questionManager.currentQuestionId,idBoDe!);
        }
      } else {
        if (wasCorrect) {
           correctCount--;
         // questionManager.updateChiTietBoDe(false,questionManager.currentQuestionId,idBoDe!);
        }
      }
    });
  }
//nhieu dap an
  void _handleMultipleAnswer(List<String> selectedAnswers) {
    final correctAnswers = List<String>.from(questionManager.correctAnswer);
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = answeredCorrectly[currentIndex] ?? false;

    setState(() {
      this.selectedAnswers[currentIndex] = selectedAnswers;
      List<String> selected = this.selectedAnswers[currentIndex] ?? [];

      // Kiểm tra xem đáp án đã chọn có khớp hoàn toàn với đáp án đúng không
      bool allCorrect = selected.length == correctAnswers.length &&
          selected.every((answer) => correctAnswers.contains(answer));

      questionResults[currentIndex] = allCorrect;
      bool isCorrect = allCorrect;

      // Chỉ cộng hoặc trừ điểm nếu câu trả lời thay đổi từ sai sang đúng hoặc ngược lại
      if (isCorrect && !wasCorrect) {
        correctCount++;
        questionManager.updateChiTietBoDe(true, questionManager.currentQuestionId, idBoDe!);
      } else if (!isCorrect && wasCorrect) {
        correctCount--;
        questionManager.updateChiTietBoDe(false, questionManager.currentQuestionId, idBoDe!);
      }
      print(correctCount);
      answeredCorrectly[currentIndex] = isCorrect;
    });
  }


  @override
  void dispose() {
    countdownTimer.stopTimer();
    super.dispose();
  }

  void _nextQuestion() {
    setState(() {
      if (questionManager.currentQuestionIndex < questionManager.questions.length - 1) {
        questionManager.currentQuestionIndex++;
        _checkMatchingQuestion();
      } else {
        if(mode == 'lambai'){
          _showSubmitDialog();
        }
        else{
          _BackHome();
        }
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (questionManager.currentQuestionIndex > 0) {
        questionManager.currentQuestionIndex--;
        // if(mode == 'lambai'){
        //   questionManager.updateChiTietBoDe(false,questionManager.currentQuestionId,idBoDe!);
        // }
        _checkMatchingQuestion();
      }

    });
  }

  void _BackHome(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => mainLayout(
        ),
      ),
    );
  }
  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Thông báo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bạn chắc chắn nộp bài?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Hủy',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _submitTest();
                final totalDuration = Duration(hours: 1);
                final timeSpent = totalDuration - countdownTimer.remainingDuration;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Result(
                      totalQuestions: questionManager.questions.length,
                      correctAnswers: correctCount,
                      questionResults: questionResults,
                      timeSpent: timeSpent,
                    ),
                  ),
                );
              },
              child: Text(
                'Đồng ý',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitTest() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore
          .collection('chi_tiet_bo_de')
          .where('Id_bo_de', isEqualTo: idBoDe)
          .get();
      updateBoDe(idBoDe!,correctCount,(Duration(hours: 1) - countdownTimer.remainingDuration).toString());
    } catch (e) {
      // Xử lý lỗi
      print('Error: $e');
    }
  }
  Future<void> updateBoDe(String idBoDe, int diemSo,String time) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('Bo_de').doc(idBoDe).update({
        'Tinh_trang': true,
        'DiemSo': diemSo,
        'Time_finish' : time,
      });
    } catch (e) {
      // Xử lý lỗi
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            onConfirmed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => mainLayout()),
              );
            },
          ),
        ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(
            'Làm bài',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ConfirmDialog(
                  onConfirmed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => mainLayout()),
                    );
                  },
                ),
              );
            },
          ),
        ),
        body: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Stack(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimatedBuilder(
                            animation: countdownTimer,
                            builder: (context, child) {
                              return Text(
                                countdownTimer.formattedTime,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${questionManager.currentQuestionIndex + 1}/${questionManager.questions.length}',
                            style: TextStyle(fontSize: 24),
                          ),
                          StarButton(),
                        ],
                      ),
                      if (questionManager.currentQuestionType == 'matching')
                        MatchingQuestion(
                          matchingQuestion: questionManager.questions[questionManager.currentQuestionIndex],
                          onAllCorrect: _handleMatchingAnswer,
                          mode: mode ?? 'lambai',
                        )
                      else if (questionManager.currentQuestionType == 'multiple_choice')
                        MultipleChoiceQuestion(
                          questionText: questionManager.currentQuestion,
                          answers: questionManager.currentAnswers!,
                          onAnswerSelected: _handleAnswer,
                          selectedAnswer: mode == 'xemdapan' ? questionManager.correctAnswer : selectedAnswers[questionManager.currentQuestionIndex],
                          mode: mode ?? 'lambai',
                        )
                      else if (questionManager.currentQuestionType == 'truefalse')
                          TrueFalseQuestion(
                            trueFalseQuestion: questionManager.questions[questionManager.currentQuestionIndex], // Truyền câu hỏi cụ thể
                            onAnswerSelected: _handleTrueFalseAnswer,
                            mode: mode ?? 'lambai',
                          )
                        else if (questionManager.currentQuestionType == 'multiple_answer')
                            MultipleAnswerQuestion(
                              questionText: questionManager.currentQuestion,
                              answers: questionManager.currentAnswers ?? [],
                              onAnswersSelected: _handleMultipleAnswer,
                              selectedAnswers:mode == 'xemdapan' ?
                              questionManager.correctAnswer ??[] :
                              selectedAnswers[questionManager.currentQuestionIndex] ??[],
                              mode: mode ?? 'lambai',
                            )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          if (questionManager.currentQuestionIndex > 0)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                minimumSize: Size(75, 35),
                              ),
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              label: Text(
                                'Quay về',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _previousQuestion,
                            ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              minimumSize: Size(75, 35),
                            ),
                            onPressed: _nextQuestion,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  questionManager.currentQuestionIndex < questionManager.questions.length - 1
                                      ? 'Tiếp tục'
                                      : 'Nộp bài',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
