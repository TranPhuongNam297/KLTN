import 'package:flutter/material.dart';

class TrueFalseQuestion extends StatefulWidget {
  final Map<String, dynamic> trueFalseQuestion; // Thay đổi từ QuestionManager thành Map
  final void Function(bool) onAnswerSelected;
  final String mode;

  TrueFalseQuestion({
    required this.trueFalseQuestion, // Cập nhật tham số
    required this.onAnswerSelected,
    required this.mode,
  });

  @override
  _TrueFalseQuestionState createState() => _TrueFalseQuestionState();
}

class _TrueFalseQuestionState extends State<TrueFalseQuestion> {
  List<bool?> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _initializeSelectedAnswers();
  }

  @override
  void didUpdateWidget(TrueFalseQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trueFalseQuestion != oldWidget.trueFalseQuestion) {
      _initializeSelectedAnswers();
    }
  }

  void _initializeSelectedAnswers() {
    final subQuestions = widget.trueFalseQuestion['subQuestions1'];
    _selectedAnswers = List<bool?>.filled(subQuestions.length, null);
    if (widget.mode == 'xemdapan') {
      for (int i = 0; i < subQuestions.length; i++) {
        _selectedAnswers[i] = subQuestions[i]['correctAnswer'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subQuestions = widget.trueFalseQuestion['subQuestions1'];
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Text(
              'Câu hỏi đúng sai',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Đúng / Sai',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          for (int i = 0; i < subQuestions.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.5, // Giới hạn chiều rộng là 50% màn hình
                      child: Text(
                        subQuestions[i]['question'],
                        style: TextStyle(fontSize: 18),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: null,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Radio<bool?>(
                            value: true,
                            groupValue: _selectedAnswers[i],
                            onChanged: widget.mode == 'lambai' ? (value) {
                              setState(() {
                                _selectedAnswers[i] = value;
                              });
                              widget.onAnswerSelected(_selectedAnswers.every((answer) =>
                              answer != null && answer == subQuestions[_selectedAnswers.indexOf(answer)]['correctAnswer']));
                            } : null,
                          ),
                          Radio<bool?>(
                            value: false,
                            groupValue: _selectedAnswers[i],
                            onChanged: widget.mode == 'lambai' ? (value) {
                              setState(() {
                                _selectedAnswers[i] = value;
                              });
                              widget.onAnswerSelected(_selectedAnswers.every((answer) =>
                              answer != null && answer == subQuestions[_selectedAnswers.indexOf(answer)]['correctAnswer']));
                            } : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}