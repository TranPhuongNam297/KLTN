import 'package:flutter/material.dart';
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
      answeredCorrectly[currentIndex] = selectedAnswer == correctAnswer;

      questionResults[currentIndex] = selectedAnswer == correctAnswer;

      if (selectedAnswer == correctAnswer) {
        if (!wasCorrect) {
          correctCount++;
        }
      } else {
        if (wasCorrect) {
          correctCount--;
        }
      }
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
        }
      } else {
        if (wasCorrect) {
          correctCount--;
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
        }
      } else {
        if (wasCorrect) {
          correctCount--;
        }
      }
    });
  }

  void _handleMultipleAnswer(List<String> selectedAnswers) {
    final correctAnswers = List<String>.from(questionManager.correctAnswer);
    final currentIndex = questionManager.currentQuestionIndex;

    setState(() {
      // Lưu trữ các đáp án được chọn
      this.selectedAnswers[currentIndex] = selectedAnswers;

      // Kiểm tra xem các đáp án được chọn có đúng hay không
      List<String> selected = this.selectedAnswers[currentIndex] ?? [];
      bool allCorrect = true;

      // Kiểm tra từng đáp án được chọn xem có trong danh sách đáp án đúng không
      for (var answer in selected) {
        if (!correctAnswers.contains(answer)) {
          allCorrect = false;
          break;
        }
      }

      // Cập nhật kết quả cho câu hỏi hiện tại
      questionResults[currentIndex] = allCorrect;

      // Tính toán số câu trả lời đúng
      bool wasCorrect = questionResults[currentIndex] ?? false; // Kiểm tra câu hỏi trước đó đã đúng hay chưa
      if (allCorrect && selected.length == correctAnswers.length) {
        if (!wasCorrect) {
          correctCount--;
        }
      } else {
        if (wasCorrect) {
          correctCount++;
        }
      }
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
        _showSubmitDialog();
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Result(
                      totalQuestions: questionManager.questions.length,
                      correctAnswers: correctCount,
                      subtitle: home.data.length,
                      questionResults: questionResults,
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
                        )
                      else if (questionManager.currentQuestionType == 'multiple_choice')
                        MultipleChoiceQuestion(
                          questionText: questionManager.currentQuestion,
                          answers: questionManager.currentAnswers!,
                          onAnswerSelected: _handleAnswer,
                          selectedAnswer: selectedAnswers[questionManager.currentQuestionIndex],
                        )
                      else if (questionManager.currentQuestionType == 'truefalse')
                          TrueFalseQuestion(
                            questionManager: questionManager,
                            onAnswerSelected: (allCorrect) {
                              setState(() {
                                _handleTrueFalseAnswer(allCorrect);
                              });
                            },
                          )
                        else if (questionManager.currentQuestionType == 'multiple_answer')
                            MultipleAnswerQuestion(
                              questionText: questionManager.currentQuestion,
                              answers: questionManager.currentAnswers!,
                              onAnswersSelected: _handleMultipleAnswer,
                              selectedAnswers: selectedAnswers[questionManager.currentQuestionIndex],
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
