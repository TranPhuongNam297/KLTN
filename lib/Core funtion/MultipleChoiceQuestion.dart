import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatelessWidget {
  final String questionText;
  final List<String> answers;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;
  final String mode; // Thêm biến mode

  MultipleChoiceQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswerSelected,
    required this.selectedAnswer,
    required this.mode, // Khởi tạo biến mode
  });

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
          bool isSelected = selectedAnswer == answer;
          bool isCorrect = false;

          if (mode == 'xemdapan') {
            // Assuming you have a way to get the correct answer, add your logic here
            // For example, if `correctAnswer` is provided:
            // isCorrect = answer == correctAnswer;
          }

          return Column(
            children: [
              InkWell(
                onTap: mode == 'lambai' ? () => onAnswerSelected(answer) : null, // Vô hiệu hóa trong chế độ "xem đáp án"
                child: Container(
                  width: 300,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue[200] // Màu cho câu trả lời đã chọn
                        : (mode == 'xemdapan' && isCorrect ? Colors.green[200] : Colors.grey[350]), // Màu cho câu trả lời đúng trong chế độ "xem đáp án"
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Colors.blue[300]! // Border màu cho câu trả lời đã chọn
                          : (mode == 'xemdapan' && isCorrect ? Colors.green[300]! : Colors.grey[600]!), // Border màu cho câu trả lời đúng
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
}
