class QuestionManager {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [
    {
      'question': 'Ai là người đầu tiên đặt chân lên Mặt Trăng?',
      'answers': ['Neil Armstrong', 'Buzz Aldrin', 'Yuri Gagarin', 'John Glenn'],
      'correctAnswer': 'Neil Armstrong',
    },
  ];

  String get currentQuestion => questions[currentQuestionIndex]['question'];
  List<String> get currentAnswers => questions[currentQuestionIndex]['answers'];
  String get correctAnswer => questions[currentQuestionIndex]['correctAnswer'];

  void nextQuestion() {
    currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
  }
}
