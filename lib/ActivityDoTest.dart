import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/mainLayout.dart';
import 'Question.dart';
import 'AnswerButton.dart';
import 'ConfirmDialog.dart';
import 'QuestionManager.dart';
import 'CountdownTimer.dart';
import 'StarButton.dart';

class ActivityDoTest extends StatefulWidget {
  @override
  _ActivityDoTestState createState() => _ActivityDoTestState();
}

class _ActivityDoTestState extends State<ActivityDoTest> {
  final QuestionManager questionManager = QuestionManager();
  final CountdownTimer countdownTimer = CountdownTimer();

  @override
  void initState() {
    super.initState();
    countdownTimer.startTimer();
  }

  void _handleAnswer(String selectedAnswer) {
    final correctAnswer = questionManager.correctAnswer;
    if (selectedAnswer == correctAnswer) {
      // Handle correct answer (e.g., update score, show feedback, etc.)
      print('Correct!');
    } else {
      // Handle incorrect answer (e.g., show feedback, etc.)
      print('Incorrect. The correct answer is: $correctAnswer');
    }

    // Move to the next question
    questionManager.nextQuestion();
    countdownTimer.resetTimer();
  }

  @override
  void dispose() {
    countdownTimer.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
            onConfirmed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => mainLayout()));
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => mainLayout()));
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
                    Text('${questionManager.currentQuestionIndex + 1}/${questionManager.questions.length}', style: TextStyle(fontSize: 24)),
                    StarButton(),
                  ],
                ),
                Question(questionManager.currentQuestion),
                SizedBox(height: 20),
                ...questionManager.currentAnswers.map((answer) {
                  return AnswerButton(
                    answerText: answer,
                    onPressed: () => _handleAnswer(answer),
                  );
                }).toList(),
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
                        backgroundColor: Colors.indigo, // Set the button color to indigo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // Make the button square
                        ),
                        minimumSize: Size(75, 35), // Set the size of the button
                      ),
                      icon: Icon(Icons.arrow_back, color: Colors.white), // Set the icon color to white
                      label: Text('Quay về', style: TextStyle(color: Colors.white)), // Set the text color to white
                      onPressed: () {
                        // Handle "Quay về" action here
                      },
                    ),
                    SizedBox(width: 100), // Add a space between the buttons
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo, // Set the button color to indigo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // Make the button square
                        ),
                        minimumSize: Size(75, 35), // Set the size of the button
                      ),
                      onPressed: () {
                        // Handle "Tiếp tục" action here
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Tiếp tục', style: TextStyle(color: Colors.white)), // Set the text color to white
                          SizedBox(width: 5), // Add a space between the text and the icon
                          Icon(Icons.arrow_forward, color: Colors.white), // Set the icon color to white
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
