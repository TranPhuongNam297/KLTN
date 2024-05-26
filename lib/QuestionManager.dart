import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/ActivityDoTest.dart';


class QuestionManager {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [
    {
      'question': 'Ai là người đầu tiên đặt chân lên Mặt Trăng?',
      'answers': ['Neil Armstrong', 'Buzz Aldrin', 'Yuri Gagarin', 'John Glenn'],
      'correctAnswer': 'Neil Armstrong',
    },

    {
      'question': 'Ai là võ sư mạnh nhất lịch sử?',
      'answers': ['Đạt G', 'Decao', 'Bruce Lee', 'Mike Tyson'],
      'correctAnswer': 'Đạt G',
    },

    {
      'question': 'Ai chơi vợ bạn?',
      'answers': ['Thắng ngọt', 'Jack', 'K-ICM', 'Tăng Duy Tân'],
      'correctAnswer': 'Thắng ngọt',
    },
  ];



  String get currentQuestion => questions[currentQuestionIndex]['question'];
  List<String> get currentAnswers => questions[currentQuestionIndex]['answers'];
  String get correctAnswer => questions[currentQuestionIndex]['correctAnswer'];

}
