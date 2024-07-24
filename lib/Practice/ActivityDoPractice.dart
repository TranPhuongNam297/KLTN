import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Core funtion/QuestionManager.dart';
import '../Core funtion/Result.dart';
import '../CountdownTimer.dart';
import '../StarButton.dart';
import '../mainLayout.dart';
import 'MatchingQuestionPrac.dart';
import 'MultipleChoiceQuestionPrac.dart';
import 'TrueFalseQuestionPrac.dart';
import 'MultipleAnswerQuestionPrac.dart';
import '../ConfirmDialog.dart';
import '../Home.dart';

class ActivityDoPractice extends StatefulWidget {
  @override
  _ActivityDoPracticeState createState() => _ActivityDoPracticeState();
}

class _ActivityDoPracticeState extends State<ActivityDoPractice> {
  final QuestionManager questionManager = QuestionManager();
  final CountdownTimer countdownTimer = CountdownTimer();
  int correctCount = 0;
  Map<int, dynamic> selectedAnswers = {};
  Map<int, bool> answeredCorrectly = {};
  bool isMatchingQuestion = false;
  List<bool?> questionResults = [];
  Future<void>? _initialization;
  String? idBoDe;
  bool isChecked = false; // Thêm thuộc tính để theo dõi khi nào kiểm tra

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
  }

  void _checkMatchingQuestion() {
    setState(() {
      isMatchingQuestion = questionManager.currentQuestionType == 'matching';
    });
  }

  void _handleAnswer(String selectedAnswer) {
    final correctAnswer = questionManager.correctAnswer;
    final currentIndex = questionManager.currentQuestionIndex;

    setState(() {
      selectedAnswers[currentIndex] = selectedAnswer;
      bool isCorrect = selectedAnswer == correctAnswer;
      answeredCorrectly[currentIndex] = isCorrect;
      questionResults[currentIndex] = isCorrect;

      if (isCorrect) {
        questionManager.updateChiTietBoDe(true, questionManager.currentQuestionId, idBoDe!);
      } else {
        questionManager.updateChiTietBoDe(false, questionManager.currentQuestionId, idBoDe!);
      }
    });
  }

  void _handleTrueFalseAnswer(bool allCorrect) {
    final currentIndex = questionManager.currentQuestionIndex;

    setState(() {
      questionResults[currentIndex] = allCorrect;
      if (allCorrect) {
        questionManager.updateChiTietBoDe(true, questionManager.currentQuestionId, idBoDe!);
      } else {
        questionManager.updateChiTietBoDe(false, questionManager.currentQuestionId, idBoDe!);
      }
    });
  }

  void _handleMatchingAnswer(bool isAllCorrect) {
    final currentIndex = questionManager.currentQuestionIndex;

    setState(() {
      selectedAnswers[questionManager.currentQuestionIndex] = selectedAnswers;
      questionResults[currentIndex] = isAllCorrect;
      if (isAllCorrect) {
        questionManager.updateChiTietBoDe(true, questionManager.currentQuestionId, idBoDe!);
      } else {
        questionManager.updateChiTietBoDe(false, questionManager.currentQuestionId, idBoDe!);
      }
    });
  }

  void _handleMultipleAnswer(List<String> selectedAnswers) {
    final correctAnswers = List<String>.from(questionManager.correctAnswer);
    final currentIndex = questionManager.currentQuestionIndex;

    setState(() {
      this.selectedAnswers[currentIndex] = selectedAnswers;
      List<String> selected = this.selectedAnswers[currentIndex] ?? [];
      bool allCorrect = selected.length == correctAnswers.length && !selected.any((answer) => !correctAnswers.contains(answer));

      questionResults[currentIndex] = allCorrect;

      if (allCorrect) {
        questionManager.updateChiTietBoDe(true, questionManager.currentQuestionId, idBoDe!);
      } else {
        questionManager.updateChiTietBoDe(false, questionManager.currentQuestionId, idBoDe!);
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      final currentIndex = questionManager.currentQuestionIndex;

      if (!isChecked) {
        isChecked = true;

        switch (questionManager.currentQuestionType) {
          case 'multiple_choice':
            final selectedAnswer = selectedAnswers[currentIndex];
            final correctAnswer = questionManager.correctAnswer;

            if (selectedAnswer != null) {
              bool isCorrect = selectedAnswer == correctAnswer;
              answeredCorrectly[currentIndex] = isCorrect;
              questionResults[currentIndex] = isCorrect;

              questionManager.updateChiTietBoDe(isCorrect, questionManager.currentQuestionId, idBoDe!);
            } else {
              answeredCorrectly[currentIndex] = false;
            }
            break;

          case 'multiple_answer':
            final selectedAnswersList = selectedAnswers[currentIndex] as List<String>;
            final correctAnswers = List<String>.from(questionManager.correctAnswer ?? []);

            bool allCorrect = selectedAnswersList.length == correctAnswers.length &&
                !selectedAnswersList.any((answer) => !correctAnswers.contains(answer));

            questionResults[currentIndex] = allCorrect;

            questionManager.updateChiTietBoDe(allCorrect, questionManager.currentQuestionId, idBoDe!);
            break;

          case 'truefalse':
            break;

          case 'matching':
            break;

          default:
            break;
        }
      } else {
        if (currentIndex < questionManager.questions.length - 1) {
          questionManager.currentQuestionIndex++;
          isChecked = false;
          _checkMatchingQuestion();
        } else {
          _showSubmitDialog();
        }
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (questionManager.currentQuestionIndex > 0) {
        questionManager.currentQuestionIndex--;
        questionManager.updateChiTietBoDe(false, questionManager.currentQuestionId, idBoDe!);
        _checkMatchingQuestion();
      }
    });
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
      correctCount = querySnapshot.docs.where((doc) {
        return doc.data().containsKey('IsCorrect') && doc['IsCorrect'] == true;
      }).length;
      updateBoDe(idBoDe!, correctCount, (Duration(hours: 1) - countdownTimer.remainingDuration).toString());
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateBoDe(String idBoDe, int diemSo, String time) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('Bo_de').doc(idBoDe).update({
        'Tinh_trang': true,
        'DiemSo': diemSo,
        'Time_finish': time,
      });
    } catch (e) {
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
        ) ?? false;
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
                        ],
                      ),
                      if (questionManager.currentQuestionType == 'matching')
                        MatchingQuestionPrac(
                          matchingQuestion: questionManager.questions[questionManager.currentQuestionIndex],
                          onAllCorrect: _handleMatchingAnswer,
                          isChecked: isChecked, // Truyền trạng thái kiểm tra
                        )
                      else if (questionManager.currentQuestionType == 'multiple_choice')
                        MultipleChoiceQuestionPrac(
                          questionText: questionManager.currentQuestion,
                          answers: questionManager.currentAnswers!,
                          onAnswerSelected: (selectedAnswer) {
                            setState(() {
                              selectedAnswers[questionManager.currentQuestionIndex] = selectedAnswer;
                            });
                          },
                          selectedAnswer: selectedAnswers[questionManager.currentQuestionIndex],
                          correctAnswer: questionManager.correctAnswer,
                          isChecked: isChecked, // Truyền trạng thái kiểm tra
                        )
                      else if (questionManager.currentQuestionType == 'truefalse')
                          TrueFalseQuestionPrac(
                            trueFalseQuestion: questionManager.questions[questionManager.currentQuestionIndex],
                            onAnswerSelected: _handleTrueFalseAnswer,
                            isChecked: isChecked, // Truyền trạng thái kiểm tra
                          )
                        else if (questionManager.currentQuestionType == 'multiple_answer')
                            MultipleAnswerQuestionPrac(
                              questionText: questionManager.currentQuestion,
                              answers: questionManager.currentAnswers!,
                              onAnswersSelected: (selectedAnswers) {
                                setState(() {
                                  this.selectedAnswers[questionManager.currentQuestionIndex] = selectedAnswers;
                                });
                              },
                              selectedAnswers: selectedAnswers[questionManager.currentQuestionIndex] ?? [],
                              correctAnswers: questionManager.correctAnswer ?? [],
                              showResult: questionResults[questionManager.currentQuestionIndex] ?? false,
                              isChecked: isChecked, // Truyền trạng thái kiểm tra
                            ),
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
