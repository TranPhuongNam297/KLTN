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
    double buttonWidth = MediaQuery.of(context).size.width * 0.9; // Chiều rộng bằng 70% màn hình

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

          }

          return Column(
            children: [
              InkWell(
                onTap: mode == 'lambai' ? () => onAnswerSelected(answer) : null, // Vô hiệu hóa trong chế độ "xem đáp án"
                child: Container(
                  width: buttonWidth, // Chiều rộng bằng 70% màn hình
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue[400] // Màu cho câu trả lời đã chọn
                        : (mode == 'xemdapan' && isCorrect ? Colors.green[200] : Colors.grey[400]), // Màu cho câu trả lời đúng trong chế độ "xem đáp án"
                    // Bỏ borderRadius và border để nút vuông vức
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
