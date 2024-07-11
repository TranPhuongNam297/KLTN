import 'package:flutter/material.dart';

class MatchingQuestion extends StatefulWidget {
  final Map<String, dynamic> matchingQuestion;
  final Function(bool) onAllCorrect;

  const MatchingQuestion({Key? key, required this.matchingQuestion, required this.onAllCorrect}) : super(key: key);

  @override
  _MatchingQuestionState createState() => _MatchingQuestionState();
}

class _MatchingQuestionState extends State<MatchingQuestion> {
  Map<String, String?> selectedAnswers = {};
  Map<String, bool> correctness = {};

  void onAnswerDropped(String question, String? answer) {
    setState(() {
      if (selectedAnswers.containsKey(question)) {
        final previousAnswer = selectedAnswers[question];
        selectedAnswers.remove(question);
        selectedAnswers[question] = answer;
        selectedAnswers.removeWhere((key, value) => value == previousAnswer);
      } else {
        selectedAnswers[question] = answer;
      }
      correctness[question] = widget.matchingQuestion['subQuestions']
          .firstWhere((q) => q['question'] == question)['correctAnswer'] == answer;

      widget.onAllCorrect(_checkAllCorrect());
    });
  }

  bool _checkAllCorrect() {
    for (var subQuestion in widget.matchingQuestion['subQuestions']) {
      if (correctness[subQuestion['question']] != true) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // Set a specific height
      child: Scaffold(
        body: Column(
          children: [
            Text(
              widget.matchingQuestion['question'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.matchingQuestion['subQuestions'].length,
                itemBuilder: (context, index) {
                  final subQuestion = widget.matchingQuestion['subQuestions'][index];
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          subQuestion['question'],
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
                            child: selectedAnswers[subQuestion['question']] != null
                                ? Draggable<String>(
                              data: selectedAnswers[subQuestion['question']],
                              child: Card(
                                margin: EdgeInsets.all(5),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(selectedAnswers[subQuestion['question']]!),
                                ),
                              ),
                              feedback: Material(
                                color: Colors.transparent,
                                child: Card(
                                  margin: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(selectedAnswers[subQuestion['question']]!),
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
                                selectedAnswers.remove(subQuestion['question']);
                              }),
                            )
                                : Text('Kéo vào đây', style: TextStyle(fontSize: 16)),
                          );
                        },
                        onAccept: (data) => onAnswerDropped(subQuestion['question'], data),
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
                  for (final subQuestion in widget.matchingQuestion['subQuestions'])
                    if (!selectedAnswers.containsValue(subQuestion['correctAnswer']))
                      Draggable<String>(
                        data: subQuestion['correctAnswer'],
                        child: Card(
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(subQuestion['correctAnswer']),
                          ),
                        ),
                        feedback: Material(
                          color: Colors.transparent,
                          child: Card(
                            margin: EdgeInsets.all(5),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(subQuestion['correctAnswer']),
                            ),
                          ),
                        ),
                        childWhenDragging: Card(
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              subQuestion['correctAnswer'],
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
