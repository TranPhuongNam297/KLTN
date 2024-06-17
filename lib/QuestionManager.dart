import 'package:flutter/material.dart';

class QuestionManager {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [
    {
      'type': 'multiple_choice',
      'question': 'Ai là người đầu tiên đặt chân lên Mặt Trăng?',
      'answers': ['Neil Armstrong', 'Buzz Aldrin', 'Yuri Gagarin', 'John Glenn'],
      'correctAnswer': 'Neil Armstrong',
    },
    {
      'type': 'multiple_choice',
      'question': 'Ai là võ sư mạnh nhất lịch sử?',
      'answers': ['Đạt G', 'Decao', 'Bruce Lee', 'Mike Tyson'],
      'correctAnswer': 'Đạt G',
    },
    {
      'type': 'multiple_choice',
      'question': 'Ai chơi vợ bạn?',
      'answers': ['Thắng ngọt', 'Jack', 'K-ICM', 'Tăng Duy Tân'],
      'correctAnswer': 'Thắng ngọt',
    },
  ];
  List<Map<String, dynamic>> questionsmatching = [{
    'type': 'matching',
    'question': 'Câu hỏi 1',
    'answers': ['Câu trả lời 1'],
    'correctAnswer': 'Câu trả lời 1',
  },
    {
      'type': 'matching',
      'question': 'Câu hỏi 2',
      'answers': ['Câu trả lời 2'],
      'correctAnswer': 'Câu trả lời 2',
    },
    {
      'type': 'matching',
      'question': 'Câu hỏi 3',
      'answers': ['Câu trả lời 3'],
      'correctAnswer': 'Câu trả lời 3',
    },
    {
      'type': 'matching',
      'question': 'Câu hỏi 4',
      'answers': ['Câu trả lời 4'],
      'correctAnswer': 'Câu trả lời 4',
    },];


  String get currentQuestion => questions[currentQuestionIndex]['question'];
  List<String> get currentAnswers => questions[currentQuestionIndex]['answers'];
  String get correctAnswer => questions[currentQuestionIndex]['correctAnswer'];
  String get currentQuestionType => questions[currentQuestionIndex]['type'];
}
