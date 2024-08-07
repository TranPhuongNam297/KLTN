import 'package:flutter/material.dart';

class MultipleChoiceQuestionPrac extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final String? correctAnswer;
  final String? selectedAnswer; // Thêm tham số để nhận đáp án đã chọn
  final Function(String) onAnswerSelected;
  final bool isChecked; // Thêm tham số để kiểm tra trạng thái

  MultipleChoiceQuestionPrac({
    required this.questionText,
    required this.answers,
    this.correctAnswer,
    this.selectedAnswer,
    required this.onAnswerSelected,
    this.isChecked = false, // Mặc định là chưa kiểm tra
  });

  @override
  _MultipleChoiceQuestionPracState createState() =>
      _MultipleChoiceQuestionPracState();
}

class _MultipleChoiceQuestionPracState extends State<MultipleChoiceQuestionPrac> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.filled(widget.answers.length, false);
    _updateAnswerStates();
  }

  @override
  void didUpdateWidget(MultipleChoiceQuestionPrac oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.questionText != oldWidget.questionText) {
      _isSelected = List.filled(widget.answers.length, false);
      _updateAnswerStates();
    }
  }

  void _updateAnswerStates() {
    if (widget.selectedAnswer != null) {
      int selectedIndex = widget.answers.indexOf(widget.selectedAnswer!);
      if (selectedIndex != -1) {
        _isSelected[selectedIndex] = true;
      }
    }
  }

  void _handleAnswerSelected(String answer) {
    if (!widget.isChecked) { // Nếu chưa kiểm tra, chỉ thay đổi màu xanh dương
      setState(() {
        int index = widget.answers.indexOf(answer);
        if (index != -1) {
          _isSelected = List.filled(widget.answers.length, false);
          _isSelected[index] = true;
        }
      });
      widget.onAnswerSelected(answer);
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9; // Chiều rộng bằng 90% màn hình

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0), // Không bo tròn
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
              int index = widget.answers.indexOf(answer);
              bool isSelected = _isSelected[index];
              bool isCorrect = answer == widget.correctAnswer;
              bool isUserAnswer = widget.selectedAnswer == answer;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  onTap: () => _handleAnswerSelected(answer),
                  child: Container(
                    width: buttonWidth,
                    height: 65,
                    decoration: BoxDecoration(
                      color: widget.isChecked
                          ? (isUserAnswer
                          ? (isCorrect ? Colors.green[700] : Colors.red[700])
                          : Colors.blueGrey[200])
                          : (isSelected ? Colors.blue[900] : Colors.blueGrey[200]),
                      borderRadius: BorderRadius.circular(0), // Không bo tròn
                    ),
                    alignment: Alignment.center,
                    child: Text(answer, style: TextStyle(fontSize: 20, color: Colors.black)),
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
