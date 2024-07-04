import 'package:flutter/material.dart';

class MultipleAnswerQuestion extends StatelessWidget {
  final String questionText;
  final List<String> answers;
  final List<String> correctAnswers;
  final List<String>? selectedAnswers;
  final Function(List<String>) onAnswersSelected;

  MultipleAnswerQuestion({
    required this.questionText,
    required this.answers,
    required this.correctAnswers,
    required this.selectedAnswers,
    required this.onAnswersSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                questionText,
                style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ...answers.map((answer) {
          bool isSelected = selectedAnswers != null && selectedAnswers!.contains(answer);
          return Column(
            children: [
              InkWell(
                onTap: () {
                  List<String> newSelectedAnswers = List.from(selectedAnswers ?? []);
                  if (newSelectedAnswers.contains(answer)) {
                    newSelectedAnswers.remove(answer);
                  } else {
                    if (newSelectedAnswers.length < 3) { // Maximum of 3 answers
                      newSelectedAnswers.add(answer);
                    }
                  }
                  onAnswersSelected(newSelectedAnswers);
                },
                child: Container(
                  width: 300,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[200] : Colors.grey[350],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(answer, style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    );
  }
}
