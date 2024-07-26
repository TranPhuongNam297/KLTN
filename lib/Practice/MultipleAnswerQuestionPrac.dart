import 'package:flutter/material.dart';

class MultipleAnswerQuestionPrac extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final ValueChanged<List<String>> onAnswersSelected;
  final List<String> selectedAnswers;
  final List<String> correctAnswers;
  final bool showResult;
  final bool isChecked; // Thêm thuộc tính này

  const MultipleAnswerQuestionPrac({
    required this.questionText,
    required this.answers,
    required this.onAnswersSelected,
    required this.selectedAnswers,
    required this.correctAnswers,
    this.showResult = false,
    required this.isChecked, // Thêm thuộc tính này
  });

  @override
  _MultipleAnswerQuestionPracState createState() => _MultipleAnswerQuestionPracState();
}

class _MultipleAnswerQuestionPracState extends State<MultipleAnswerQuestionPrac> {
  late List<String> selectedAnswers;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.from(widget.selectedAnswers);
  }

  Color _getButtonColor(String answer) {
    if (widget.isChecked) {
      bool isCorrect = widget.correctAnswers.contains(answer);
      bool isSelected = selectedAnswers.contains(answer);
      if (isSelected) {
        return isCorrect ? Colors.green[200]! : Colors.red[200]!;
      }
      return Colors.grey[350]!;
    }
    return selectedAnswers.contains(answer) ? Colors.blue[200]! : Colors.grey[350]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Center(
            child: Text(
              widget.questionText,
              style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Column(
            children: widget.answers.map((answer) {
              bool isSelected = selectedAnswers.contains(answer);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextButton(
                  onPressed: widget.isChecked ? null : () {
                    setState(() {
                      if (isSelected) {
                        selectedAnswers.remove(answer);
                      } else {
                        selectedAnswers.add(answer);
                      }
                      widget.onAnswersSelected(selectedAnswers);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      return _getButtonColor(answer);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 300,
                    height: 55,
                    alignment: Alignment.center,
                    child: Text(
                      answer,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
