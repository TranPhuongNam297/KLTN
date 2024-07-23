import 'package:flutter/material.dart';

class MultipleAnswerQuestion extends StatelessWidget {
  final String questionText;
  final List<String> answers;
  final Function(List<String>) onAnswersSelected;
  final List<String> selectedAnswers;
  final String mode;

  MultipleAnswerQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswersSelected,
    required this.selectedAnswers,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra và đảm bảo rằng các giá trị không bị null
    assert(questionText.isNotEmpty, 'Question text cannot be empty');
    assert(answers.isNotEmpty, 'Answers cannot be empty');
    assert(selectedAnswers != null, 'Selected answers cannot be null');
    assert(mode.isNotEmpty, 'Mode cannot be empty');

    // In danh sách đáp án
    printAnswers();

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Center(
              child: Text(
                questionText,
                style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ...answers.map((answer) {
          bool isSelected = selectedAnswers.contains(answer);
          bool isCorrect = mode == 'xemdapan' && isSelected;

          return Column(
            children: [
              InkWell(
                onTap: mode == 'lambai'
                    ? () {
                  List<String> updatedSelections = List.from(selectedAnswers);
                  if (updatedSelections.contains(answer)) {
                    updatedSelections.remove(answer);
                  } else {
                    updatedSelections.add(answer);
                  }
                  onAnswersSelected(updatedSelections);
                }
                    : null, // Vô hiệu hóa trong chế độ "xemdapan"
                child: Container(
                  width: 300,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue[200] // Màu cho đáp án đã chọn
                        : (mode == 'xemdapan' && isCorrect ? Colors.green[200] : Colors.grey[350]), // Màu cho đáp án đúng trong chế độ "xemdapan"
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Colors.blue[300]! // Border màu cho đáp án đã chọn
                          : (mode == 'xemdapan' && isCorrect ? Colors.green[300]! : Colors.grey[600]!), // Border màu cho đáp án đúng
                    ),
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

  void printAnswers() {
    print('Danh sách đáp án:');
    for (var answer in answers) {
      print(answer);
    }
  }
}
