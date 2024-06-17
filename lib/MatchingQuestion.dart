import 'package:flutter/material.dart';
import 'QuestionManager.dart';

class MatchingQuestion extends StatefulWidget {
  @override
  _MatchQuestionAppState createState() => _MatchQuestionAppState();
}

class _MatchQuestionAppState extends State<MatchingQuestion> {
  QuestionManager questionManager = QuestionManager();

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
      correctness[question] = questionManager.questions
          .firstWhere((q) => q['question'] == question)['correctAnswer'] ==
          answer;
    });
  }

  void checkAnswers() {
    setState(() {
      for (var question in questionManager.questions) {
        if (question['type'] == 'matching') {
          correctness[question['question']!] =
              selectedAnswers[question['question']!] == question['correctAnswer'];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // Set a specific height
      child: Scaffold(
        body: Column(
          children: [
            Text(
              'Ghép câu trả lời đúng cho câu hỏi:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questionManager.questions
                    .where((q) => q['type'] == 'matching')
                    .length,
                itemBuilder: (context, index) {
                  final question = questionManager.questions
                      .where((q) => q['type'] == 'matching')
                      .elementAt(index)['question']!;
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
                  for (final question in questionManager.questions
                      .where((q) => q['type'] == 'matching'))
                    if (!selectedAnswers.containsValue(question['correctAnswer']))
                      Draggable<String>(
                        data: question['correctAnswer'],
                        child: Card(
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(question['correctAnswer']!),
                          ),
                        ),
                        feedback: Material(
                          color: Colors.transparent,
                          child: Card(
                            margin: EdgeInsets.all(5),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(question['correctAnswer']!),
                            ),
                          ),
                        ),
                        childWhenDragging: Card(
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              question['correctAnswer']!,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAnswers,
              child: Text('Kiểm tra'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: correctness.length,
                itemBuilder: (context, index) {
                  final question = correctness.keys.elementAt(index);
                  final isCorrect = correctness[question] ?? false;
                  return ListTile(
                    title: Text(question),
                    trailing: Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
