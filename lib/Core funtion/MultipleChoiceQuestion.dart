import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;
  final String mode;
  final String correctAnswer; // Thêm biến correctAnswer

  MultipleChoiceQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswerSelected,
    required this.selectedAnswer,
    required this.mode,
    required this.correctAnswer, // Khởi tạo biến correctAnswer
  });

  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Center(
              child: Text(
                widget.questionText,
                style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ...widget.answers.map((answer) {
          bool isSelected = widget.selectedAnswer == answer && widget.mode == 'lambai';
          bool isCorrect = widget.mode == 'xemdapan' && answer == widget.correctAnswer;

          return Column(
            children: [
              InkWell(
                onTap: widget.mode == 'lambai' ? () => widget.onAnswerSelected(answer) : null,
                child: Container(
                  width: buttonWidth,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue[900]
                        : (widget.mode == 'xemdapan'
                        ? (isCorrect ? Colors.green[700] : Colors.blueGrey[200])
                        : Colors.blueGrey[200]),
                    borderRadius: BorderRadius.zero,
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
