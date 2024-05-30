import 'package:flutter/material.dart';

class MatchingQuestion extends StatefulWidget {
  @override
  _MatchQuestionAppState createState() => _MatchQuestionAppState();
}

class _MatchQuestionAppState extends State<MatchingQuestion> {
  List<Map<String, String>> questions = [
    {'question': 'Câu hỏi 1', 'answer': 'Câu trả lời 1'},
    {'question': 'Câu hỏi 2', 'answer': 'Câu trả lời 2'},
    {'question': 'Câu hỏi 3', 'answer': 'Câu trả lời 3'},
    {'question': 'Câu hỏi 4', 'answer': 'Câu trả lời 4'},
    {'question': 'Câu hỏi 5', 'answer': 'Câu trả lời 5'},
    {'question': 'Câu hỏi 6', 'answer': 'Câu trả lời 6'},

    // Add more questions here
  ];

  Map<String, String> selectedAnswers = {};
  Map<String, bool> correctness = {};

  void onAnswerDropped(String question, String answer) {
    setState(() {
      if (selectedAnswers.containsKey(question)) {
        final previousAnswer = selectedAnswers[question]!;
        selectedAnswers.remove(question);
        selectedAnswers[question] = answer;
        selectedAnswers.removeWhere((key, value) => value == previousAnswer);
      } else {
        selectedAnswers[question] = answer;
      }
      correctness[question] =
          questions.firstWhere((q) => q['question'] == question)['answer'] == answer;
    });
  }

  void checkAnswers() {
    setState(() {
      for (var question in questions) {
        correctness[question['question']!] =
            selectedAnswers[question['question']!] == question['answer'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài tập ghép câu'),
      ),
      body: Column(
        children: [
          Text(
            'Ghép câu trả lời đúng cho câu hỏi:',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index]['question']!;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 150,
                          height: 50,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: selectedAnswers[question] != null
                              ? Draggable<String>(
                            data: selectedAnswers[question],
                            child: Card(
                              margin: EdgeInsets.all(5),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(selectedAnswers[question]!),
                              ),
                            ),
                            feedback: Material(
                              color: Colors.transparent,
                              child: Card(
                                margin: EdgeInsets.all(5),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(selectedAnswers[question]!),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              width: 150,
                              height: 50,
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: Text('Kéo vào đây', style: TextStyle(fontSize: 16)),
                            ),
                            onDragCompleted: () => setState(() {
                              selectedAnswers.remove(question);
                            }),
                          )
                              : Text('Kéo vào đây', style: TextStyle(fontSize: 16)),
                        );
                      },
                      onAccept: (data) => onAnswerDropped(question, data),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Wrap(
              spacing: 10,
              children: [
                for (final question in questions)
                  if (!selectedAnswers.containsValue(question['answer']))
                    Draggable<String>(
                      data: question['answer'],
                      child: Card(
                        margin: EdgeInsets.all(5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(question['answer']!),
                        ),
                      ),
                      feedback: Material(
                        color: Colors.transparent,
                        child: Card(
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(question['answer']!),
                          ),
                        ),
                      ),
                      childWhenDragging: Card(
                        margin: EdgeInsets.all(5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            question['answer']!,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: checkAnswers,
                child: Text('Kiểm tra'),
              ),
              SizedBox(width: 20),
              Column(
                children: questions.map((q) {
                  final question = q['question']!;
                  final isCorrect = correctness[question] ?? false;
                  return Text(
                    isCorrect ? 'Đúng' : 'Sai',
                    style: TextStyle(
                      fontSize: 18,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}