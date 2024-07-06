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
      'question': 'Đâu là một thương hiệu siêu xe?',
      'answers': ['Gucci','Nike','Lamborghini','Channel'],
      'correctAnswer': 'Lamborghini',
    },
    {
      'type': 'multiple_choice',
      'question': 'Ai là tổng thống Mỹ đương nhiệm',
      'answers': ['Obama', 'Trump', 'Benjamin', 'Biden'],
      'correctAnswer': 'Biden',
    },
    {
      'type': 'matching',
      'question': 'Ghép các câu sau đây:',
      'subQuestions': [
        {'question': 'Một bộ phận cơ thể', 'correctAnswer': 'Cánh tay'},
        {'question': 'Một phụ kiện của máy tính', 'correctAnswer': 'Bàn phím'},
        {'question': 'Con nào có cánh nhưng không bay', 'correctAnswer': 'Con gà'},
        {'question': 'Một bộ phận của con mèo', 'correctAnswer': 'Ria mép'},
      ],
    },
    {
      'type': 'truefalse',
      'subQuestions1': [
        {'question': 'Người ngoài hành tinh có thật?', 'correctAnswer': true},
        {'question': 'Euro Đức vô địch đúng không?', 'correctAnswer': false},
        {'question': 'Mặt trời là 1 ngôi sao?', 'correctAnswer': true},
      ],
    },
    {
      'type': 'multiple_choice',
      'question': 'Đội nào vô địch UEFA Champions League nhiều nhất?',
      'answers': ['Real Madrid', 'Manchester City', 'Manchester United', 'AC Milan'],
      'correctAnswer': 'Có',
    },
    {
      'type': 'multiple_answer',
      'question': 'Đâu là phụ kiện của máy tính? (Có thể chọn nhiều hơn 1 đáp án)',
      'answers': ['Chuột', 'Bàn phím', 'Máy lạnh', 'Tủ lạnh'],
      'correctAnswer': ['Chuột', 'Bàn phím'],
    },

  ];

  String get currentQuestion => questions[currentQuestionIndex]['question'];

  List<String>? get currentAnswers {
    if (questions[currentQuestionIndex]['type'] == 'multiple_choice' ||
        questions[currentQuestionIndex]['type'] == 'multiple_answer') {
      return questions[currentQuestionIndex]['answers'] as List<String>;
    } else {
      return null;
    }
  }

  dynamic get correctAnswer => questions[currentQuestionIndex]['correctAnswer'];

  String get currentQuestionType => questions[currentQuestionIndex]['type'];
}
