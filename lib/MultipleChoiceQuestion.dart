import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatelessWidget {
  final String questionText;
  final List<String> answers;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;

  MultipleChoiceQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswerSelected,
    required this.selectedAnswer,
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
          return Column(
            children: [
              InkWell(
                onTap: () => onAnswerSelected(answer),
                child: Container(
                  width: 300,
                  height: 65,
                  decoration: BoxDecoration(
                    color: selectedAnswer == answer ? Colors.blue[200] : Colors.grey[350],
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
