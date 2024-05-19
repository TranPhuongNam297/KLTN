import 'dart:async';

import 'package:flutter/material.dart';

import 'package:khoa_luan_tot_nghiep/mainLayout.dart';

class ActivityDoTest extends StatefulWidget {
  @override
  _ActivityDoTestState createState() => _ActivityDoTestState();
}

class _ActivityDoTestState extends State<ActivityDoTest> {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [
    {
      'question': 'Ai là người đầu tiên đặt chân lên Mặt Trăng?',
      'answers': ['Neil Armstrong', 'Buzz Aldrin', 'Yuri Gagarin', 'John Glenn'],
      'correctAnswer': 'Neil Armstrong',
    },
    // Add other questions here...
  ];

  int remainingTime = 240; // 1 minute in seconds
  late Timer _timer;

  Future<bool> _onWillPop() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận thoát', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Text('Bạn có muốn thoát ra ngoài khi chưa làm xong không?', style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(false),
            child: Text('Không', style: TextStyle(fontSize: 20)),
          ),
          TextButton(
            onPressed: () {
              // Thay vì pop(Home()), sử dụng Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()))
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => mainLayout()));
            },
            child: Text('Có', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          // Handle time's up (e.g., show feedback, move to next question, etc.)
          print('Time\'s up!');
          timer.cancel();
        }
      });
    });
  }


  void _handleAnswer(String selectedAnswer) {
    final correctAnswer = questions[currentQuestionIndex]['correctAnswer'];
    if (selectedAnswer == correctAnswer) {
      // Handle correct answer (e.g., update score, show feedback, etc.)
      print('Correct!');
    } else {
      // Handle incorrect answer (e.g., show feedback, etc.)
      print('Incorrect. The correct answer is: $correctAnswer');
    }

    // Move to the next question
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
      remainingTime = 240; // Reset timer for the next question
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          'Làm bài',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _onWillPop();
          },
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: remainingTime * 2,
                height: 10,
                color: Colors.green,
              ),
            ),
          ),
          Container(
            width: 400,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  questions[currentQuestionIndex]['question'],
                  style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
                ),
              )
            ),
          ),
          SizedBox(height: 20),
          ...questions[currentQuestionIndex]['answers'].map((answer) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => _handleAnswer(answer),
                  child: Text(answer, style: TextStyle(fontSize: 20),),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(300, 65),
                  ),
                ),
                SizedBox(height: 10), // Add SizedBox with height 10
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}



