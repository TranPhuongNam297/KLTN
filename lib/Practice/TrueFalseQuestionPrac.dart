import 'package:flutter/material.dart';

class TrueFalseQuestionPrac extends StatefulWidget {
  final Map<String, dynamic> trueFalseQuestion;
  final bool isChecked;
  final void Function(bool? selectedAnswer) onAnswerSelected;

  TrueFalseQuestionPrac({
    required this.trueFalseQuestion,
    required this.isChecked,
    required this.onAnswerSelected,
  });

  @override
  _TrueFalseQuestionPracState createState() => _TrueFalseQuestionPracState();
}

class _TrueFalseQuestionPracState extends State<TrueFalseQuestionPrac> {
  List<bool?> _selectedAnswers = [];
  late bool _isChecked;
  List<bool?> _correctAnswers = [];

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
    _correctAnswers = List<bool?>.generate(
      subQuestions.length,
          (index) => subQuestions[index]['correctAnswer'],
    );
  }

  void _checkAnswers() {
    bool anyAnswerSelected = _selectedAnswers.any((answer) => answer != null);
    if (!anyAnswerSelected) {
      widget.onAnswerSelected(null);
      return;
    }

    bool allCorrect = true;
    for (int i = 0; i < _selectedAnswers.length; i++) {
      if (_selectedAnswers[i] != _correctAnswers[i]) {
        allCorrect = false;
        break;
      }
    }
    widget.onAnswerSelected(allCorrect ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    final subQuestions = widget.trueFalseQuestion['subQuestions1'];
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * 0.5,
                      child: Text(
                        subQuestions[i]['question'],
                        style: TextStyle(
                          fontSize: 18,
                          color: _selectedAnswers[i] != null
                              ? (_selectedAnswers[i] == _correctAnswers[i]
                              ? Colors.green
                              : Colors.red)
                              : Colors.black,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 3,
                      ),
                    ),
                    Spacer(),
                    Radio<bool?>(
                      value: true,
                      groupValue: _selectedAnswers[i],
                      onChanged: _isChecked
                          ? null
                          : (value) {
                        setState(() {
                          _selectedAnswers[i] = value;
                          _checkAnswers();
                        });
                      },
                    ),
                    Radio<bool?>(
                      value: false,
                      groupValue: _selectedAnswers[i],
                      onChanged: _isChecked
                          ? null
                          : (value) {
                        setState(() {
                          _selectedAnswers[i] = value;
                          _checkAnswers();
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
