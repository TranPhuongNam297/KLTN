import 'package:flutter/material.dart';
import 'Home.dart';
import 'QuestionManager.dart';
import 'CountdownTimer.dart';
import 'Result.dart';
import 'StarButton.dart';
import 'mainLayout.dart';
import 'MatchingQuestion.dart';
import 'ConfirmDialog.dart';
import 'MultipleChoiceQuestion.dart';

class ActivityDoTest extends StatefulWidget {
  @override
  _ActivityDoTestState createState() => _ActivityDoTestState();
}

class _ActivityDoTestState extends State<ActivityDoTest> {
  final QuestionManager questionManager = QuestionManager();
  final CountdownTimer countdownTimer = CountdownTimer();
  final Home home = Home();
  int count = 0;
  Map<int, String?> selectedAnswers = {};
  Map<int, bool> correctAnswers = {};
  bool isMatchingQuestion = false;
  bool allMatchingCorrect = false;

  @override
  void initState() {
    super.initState();
    countdownTimer.startTimer();
    for (int i = 0; i < questionManager.questions.length; i++) {
      selectedAnswers[i] = null;
      correctAnswers[i] = false;
    }
    _checkMatchingQuestion();
  }

  void _checkMatchingQuestion() {
    setState(() {
      isMatchingQuestion = questionManager.currentQuestionType == 'matching';
    });
  }

  void _handleAnswer(String selectedAnswer) {
    final correctAnswer = questionManager.correctAnswer;
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = correctAnswers[currentIndex] ?? false;

    setState(() {
      selectedAnswers[currentIndex] = selectedAnswer;
      correctAnswers[currentIndex] = selectedAnswer == correctAnswer;
      if (selectedAnswer == correctAnswer) {
        if (!wasCorrect) {
          count++;
        }
      } else {
        if (wasCorrect) {
          count--;
        }
      }
      countdownTimer.resetTimer();
    });
  }

  void _handleMatchingAnswer(bool isAllCorrect) {
    final currentIndex = questionManager.currentQuestionIndex;
    bool wasCorrect = correctAnswers[currentIndex] ?? false;

    setState(() {
      correctAnswers[currentIndex] = isAllCorrect;
      if (isAllCorrect) {
        if (!wasCorrect) {
          count++;
        }
      } else {
        if (wasCorrect) {
          count--;
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
        _checkMatchingQuestion(); // Check if the next question is matching
      } else {
        _showSubmitDialog();
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (questionManager.currentQuestionIndex > 0) {
        questionManager.currentQuestionIndex--;
        _checkMatchingQuestion(); // Check if the previous question is matching
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
                      correctAnswers: count,
                      subtitle: home.data.length,
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
        body: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: countdownTimer.time * 2,
                      height: 10,
                      color: Colors.green,
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
                if (isMatchingQuestion)
                  MatchingQuestion(
                    matchingQuestion: questionManager.questions[questionManager.currentQuestionIndex],
                    onAllCorrect: _handleMatchingAnswer,
                  )
                else
                  MultipleChoiceQuestion(
                    questionText: questionManager.currentQuestion,
                    answers: questionManager.currentAnswers,
                    onAnswerSelected: _handleAnswer,
                    selectedAnswer: selectedAnswers[questionManager.currentQuestionIndex],
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    SizedBox(width: 100),
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
        ),
      ),
    );
  }
}
