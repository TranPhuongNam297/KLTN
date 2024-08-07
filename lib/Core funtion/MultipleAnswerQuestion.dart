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

    double buttonWidth = MediaQuery.of(context).size.width * 0.9; // Chiều rộng bằng 90% màn hình

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.zero, // Đã thay đổi từ BorderRadius.circular(10) thành BorderRadius.zero
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
          bool isCorrect = false;

          if (mode == 'xemdapan') {
            // Tách chuỗi IsCorrect thành mảng và kiểm tra
            List<String> correctAnswers = 'Phrases+Address information+Payment methods'.split('+');
            isCorrect = correctAnswers.contains(answer);
          }

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
                  width: buttonWidth, // Chiều rộng bằng 90% màn hình
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue[900] // Màu cho đáp án đã chọn
                        : (mode == 'xemdapan'
                        ? (isCorrect ? Colors.green[700] : Colors.red[700]) // Màu cho đáp án đúng/sai trong chế độ "xemdapan"
                        : Colors.blueGrey[200]), // Màu cho câu trả lời không chọn
                    borderRadius: BorderRadius.zero, // Đã thay đổi từ BorderRadius.circular(0) thành BorderRadius.zero
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
