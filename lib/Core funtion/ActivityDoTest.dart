import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/CompletedTests.dart';
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
  // final CountdownTimer countdownTimer = CountdownTimer();
  final Home home = Home();
  int correctCount = 0;
  Map<int, dynamic> selectedAnswers = {};
  Map<int, bool> answeredCorrectly = {};
  bool isMatchingQuestion = false;
  List<bool?> questionResults = [];
  Future<void>? _initialization;
  String? idBoDe;
  String? mode;
  late CountdownTimer countdownTimer;

  @override
  void initState() {
    super.initState();
    countdownTimer = CountdownTimer(
      remainingDuration: Duration(hours: 1),
    );
    countdownTimer.onTimerEnd = _navigateToResult;
    _loadIdBoDe().then((_) {
      if (mode != 'xemdapan') {
        countdownTimer.startTimer();
      }
      _initialization = questionManager.testFirestoreFunction().then((_) {
        setState(() {
          questionResults =
          List<bool?>.filled(questionManager.questions.length, null);
          for (int i = 0; i < questionManager.questions.length; i++) {
            selectedAnswers[i] = null;
            answeredCorrectly[i] = false;
          }
          _checkMatchingQuestion();
        });
      });
    });
  }

  Future<void> _loadIdBoDe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idBoDe = prefs.getString('boDeId')!;
      mode = prefs.getString('mode')!;
      print(mode);
    });
  }

  void _checkMatchingQuestion() {
    setState(() {
      isMatchingQuestion = questionManager.currentQuestionType == 'matching';
    });
  }

  void _handleAnswer(String selectedAnswer) {
    final correctAnswer = questionManager.correctAnswer;
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = answeredCorrectly[currentIndex] ?? false;
    setState(() {
      selectedAnswers[currentIndex] = selectedAnswer;
      bool isCorrect = selectedAnswer == correctAnswer;
      answeredCorrectly[currentIndex] = isCorrect;
      questionManager.updateChiTietBoDeMutipleChoise(
          selectedAnswer, questionManager.currentQuestionId, idBoDe!);
      if (isCorrect && !wasCorrect) {
        correctCount++;
      } else if (!isCorrect && wasCorrect) {
        correctCount--;
      }
      questionResults[currentIndex] = isCorrect;
    });
  }

  void _handleTrueFalseAnswer(bool allCorrect) {
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = answeredCorrectly[currentIndex] ?? false;
    setState(() {
      questionResults[currentIndex] = allCorrect;
      if (allCorrect) {
        if (!wasCorrect) {
          correctCount++;
          questionManager.updateChiTietBoDe(
              'dung', questionManager.currentQuestionId, idBoDe!);
        }
      } else {
        if (wasCorrect) {
          correctCount--;
          questionManager.updateChiTietBoDe(
              'sai', questionManager.currentQuestionId, idBoDe!);
        }
      }
    });
  }

  void _handleMatchingAnswer(bool isAllCorrect) {
    final currentIndex = questionManager.currentQuestionIndex;
    bool? wasCorrect = answeredCorrectly[currentIndex];
    setState(() {
      if (isAllCorrect) {
        if (wasCorrect == false || wasCorrect == null) {
          correctCount++;
          answeredCorrectly[currentIndex] = true;
        }
      } else {
        if (wasCorrect == true) {
          correctCount--;
          answeredCorrectly[currentIndex] = false;
        } else if (wasCorrect == null) {
          answeredCorrectly[currentIndex] = false;
        }
      }
      questionResults[currentIndex] = isAllCorrect;
    });
  }

  void _handleMultipleAnswer(List<String> selectedAnswers) {
    final correctAnswers = List<String>.from(questionManager.correctAnswer);
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = answeredCorrectly[currentIndex] ?? false;
    setState(() {
      this.selectedAnswers[currentIndex] = selectedAnswers;
      List<String> selected = this.selectedAnswers[currentIndex] ?? [];
      bool allCorrect = selected.length == correctAnswers.length &&
          selected.every((answer) => correctAnswers.contains(answer));
      questionResults[currentIndex] = allCorrect;
      bool isCorrect = allCorrect;
      questionManager.updateChiTietBoDeMutipleAnswers(
          selectedAnswers, questionManager.currentQuestionId, idBoDe!);
      if (isCorrect && !wasCorrect) {
        correctCount++;
      } else if (!isCorrect && wasCorrect) {
        correctCount--;
      }
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
      if (questionManager.currentQuestionIndex <
          questionManager.questions.length - 1) {
        questionManager.currentQuestionIndex++;
        _checkMatchingQuestion();
      } else {
        if (mode == 'lambai') {
          _showSubmitDialog();
        } else if (mode == 'xemdapan') {
          _showEndViewDialog();
        } else {
          _BackHome();
        }
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (questionManager.currentQuestionIndex > 0) {
        questionManager.currentQuestionIndex--;
        _checkMatchingQuestion();
      }
    });
  }

  void _BackHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => mainLayout(),
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
                final timeSpent = totalDuration -
                    countdownTimer.remainingDuration;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Result(
                          totalQuestions: questionManager.questions.length,
                          correctAnswers: correctCount,
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
      updateBoDe(idBoDe!, correctCount,
          (Duration(hours: 1) - countdownTimer.remainingDuration).toString());
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

  void _showEndViewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Thông báo',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bạn có muốn kết thúc xem chi tiết đáp án?',
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
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        Result(
                          totalQuestions: questionManager.questions.length,
                          correctAnswers: correctCount,
                          timeSpent: Duration.zero,
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

  void _navigateToResult() async {
    final totalDuration = Duration(hours: 1); // Adjust this if needed
    final timeSpent = totalDuration - countdownTimer.remainingDuration;

    await _submitTest(); // Gọi hàm _submitTest để cập nhật kết quả trước khi điều hướng

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Result(
          totalQuestions: questionManager.questions.length,
          correctAnswers: correctCount,
          timeSpent: timeSpent,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          mode == 'xemdapan' ? 'Chi tiết đáp án' : 'Làm bài',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (mode == 'xemdapan') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      mainLayout(
                          initialIndex: 2
                      ),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) =>
                    ConfirmDialog(
                      onConfirmed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => mainLayout()),
                        );
                      },
                    ),
              );
            }
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<void>(
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
                      if (mode != 'xemdapan')
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
                            '${questionManager.currentQuestionIndex +
                                1}/${questionManager.questions.length}',
                            style: TextStyle(fontSize: 24),
                          ),
                          StarButton(
                            Currentindex: questionManager.currentQuestionIndex
                                .toString(),
                          ),
                        ],
                      ),
                      if (questionManager.currentQuestionType == 'matching')
                        MatchingQuestion(
                          matchingQuestion: questionManager
                              .questions[questionManager.currentQuestionIndex],
                          onAllCorrect: _handleMatchingAnswer,
                          mode: mode ?? 'lambai',
                        )
                      else
                        if (questionManager.currentQuestionType ==
                            'multiple_choice')
                          MultipleChoiceQuestion(
                            questionText: questionManager.currentQuestion,
                            answers: questionManager.currentAnswers!,
                            onAnswerSelected: _handleAnswer,
                            correctAnswer: questionManager.correctAnswer,
                            selectedAnswer: mode == 'xemdapan' ? questionManager
                                .correctAnswer : selectedAnswers[questionManager
                                .currentQuestionIndex],
                            mode: mode ?? 'lambai',
                          )
                        else
                          if (questionManager.currentQuestionType ==
                              'truefalse')
                            TrueFalseQuestion(
                              trueFalseQuestion: questionManager
                                  .questions[questionManager
                                  .currentQuestionIndex],
                              onAnswerSelected: _handleTrueFalseAnswer,
                              mode: mode ?? 'lambai',
                            )
                          else
                            if (questionManager.currentQuestionType ==
                                'multiple_answer')
                              MultipleAnswerQuestion(
                                questionText: questionManager.currentQuestion,
                                answers: questionManager.currentAnswers ?? [],
                                onAnswersSelected: _handleMultipleAnswer,
                                selectedAnswers: mode == 'xemdapan'
                                    ? questionManager.correctAnswer ?? []
                                    : selectedAnswers[questionManager
                                    .currentQuestionIndex] ?? [],
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
                            onPressed: () {
                              if (questionManager.currentQuestionIndex <
                                  questionManager.questions.length - 1) {
                                _nextQuestion();
                              } else {
                                if (mode == 'xemdapan') {
                                  _showEndViewDialog();
                                } else {
                                  _showSubmitDialog();
                                }
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  (questionManager.currentQuestionIndex <
                                      questionManager.questions.length - 1 ||
                                      mode != 'xemdapan')
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
