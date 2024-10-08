import 'package:flutter/material.dart';

class MatchingQuestionPrac extends StatefulWidget {
  final Map<String, dynamic> matchingQuestion;
  final bool isChecked;

  const MatchingQuestionPrac({
    Key? key,
    required this.matchingQuestion,
    required this.isChecked, required void Function(bool isAllCorrect) onAllCorrect,
  }) : super(key: key);

  @override
  _MatchingQuestionPracState createState() => _MatchingQuestionPracState();
}

class _MatchingQuestionPracState extends State<MatchingQuestionPrac> {
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
    });
  }

  void _checkAnswers() {
    setState(() {
      correctness.clear();
      for (var subQuestion in widget.matchingQuestion['subQuestions']) {
        final question = subQuestion['question'];
        final correctAnswer = subQuestion['correctAnswer'];
        correctness[question] = selectedAnswers[question] == correctAnswer;
      }
    });
  }

  @override
  void didUpdateWidget(MatchingQuestionPrac oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked && !oldWidget.isChecked) {
      _checkAnswers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List subQuestions = widget.matchingQuestion['subQuestions'] as List;

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
                itemCount: subQuestions.length,
                itemBuilder: (context, index) {
                  final subQuestion = subQuestions[index];
                  final question = subQuestion['question'];
                  final correctAnswer = subQuestion['correctAnswer'];

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
                            color: widget.isChecked
                                ? (correctness[question] == true
                                ? Colors.green[700]
                                : Colors.red[700])
                                : Colors.blueGrey[200],
                            alignment: Alignment.center,
                            child: selectedAnswers[question] != null
                                ? Draggable<String>(
                              data: selectedAnswers[question]!,
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
                                color: Colors.blueGrey[200],
                                alignment: Alignment.center,
                                child: Text('Kéo vào đây',
                                    style: TextStyle(fontSize: 16)),
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
                  for (final subQuestion in subQuestions)
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
