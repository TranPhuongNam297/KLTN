import 'package:flutter/material.dart';

class MultipleAnswerQuestion extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final Function(List<String>) onAnswersSelected;
  final List<String>? selectedAnswers;

  MultipleAnswerQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswersSelected,
    this.selectedAnswers,
  });

  @override
  _MultipleAnswerQuestionState createState() => _MultipleAnswerQuestionState();
}

class _MultipleAnswerQuestionState extends State<MultipleAnswerQuestion> {
  List<String> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedAnswers != null) {
      selectedAnswers.addAll(widget.selectedAnswers!);
    }
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
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        selectedAnswers.remove(answer);
                      } else {
                        if (selectedAnswers.length < 3) {
                          selectedAnswers.add(answer);
                        }
                      }
                      widget.onAnswersSelected(selectedAnswers);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      return isSelected ? Colors.blue[200]! : Colors.grey[350]!;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 300,
                    height: 55, // Đã thay đổi kích thước nút
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
        SizedBox(height: 20),
      ],
    );
  }
}
