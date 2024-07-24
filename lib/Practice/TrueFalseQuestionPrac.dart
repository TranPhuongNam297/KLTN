import 'package:flutter/material.dart';

class TrueFalseQuestionPrac extends StatefulWidget {
  final Map<String, dynamic> trueFalseQuestion;
  final void Function(bool) onAnswerSelected;
  final bool isChecked;

  TrueFalseQuestionPrac({
    required this.trueFalseQuestion,
    required this.onAnswerSelected,
    required this.isChecked,
  });

  @override
  _TrueFalseQuestionPracState createState() => _TrueFalseQuestionPracState();
}

class _TrueFalseQuestionPracState extends State<TrueFalseQuestionPrac> {
  List<bool?> _selectedAnswers = [];
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
    _initializeSelectedAnswers();
  }

  @override
  void didUpdateWidget(TrueFalseQuestionPrac oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trueFalseQuestion != oldWidget.trueFalseQuestion) {
      _initializeSelectedAnswers();
    }
  }

  void _initializeSelectedAnswers() {
    final subQuestions = widget.trueFalseQuestion['subQuestions1'];
    _selectedAnswers = List<bool?>.filled(subQuestions.length, null);
  }

  void _checkAnswers() {
    setState(() {
      _isChecked = true;
      final subQuestions = widget.trueFalseQuestion['subQuestions1'];
      widget.onAnswerSelected(
        _selectedAnswers.every((answer) =>
        answer != null &&
            answer == subQuestions[_selectedAnswers.indexOf(answer)]['correctAnswer']),
      );
    });
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
                      width: screenWidth * 0.5,
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
                            onChanged: _isChecked ? null : (value) {
                              setState(() {
                                _selectedAnswers[i] = value;
                              });
                            },
                            activeColor: _isChecked && _selectedAnswers[i] == true
                                ? Colors.green
                                : Colors.black,
                          ),
                          Radio<bool?>(
                            value: false,
                            groupValue: _selectedAnswers[i],
                            onChanged: _isChecked ? null : (value) {
                              setState(() {
                                _selectedAnswers[i] = value;
                              });
                            },
                            activeColor: _isChecked && _selectedAnswers[i] == false
                                ? Colors.red
                                : Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkAnswers,
            child: Text('Kiểm tra'),
          ),
        ],
      ),
    );
  }
}
