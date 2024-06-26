import 'package:flutter/material.dart';
import 'QuestionManager.dart';

class TrueFalseQuestion extends StatefulWidget {
  final QuestionManager questionManager;
  final void Function(bool) onAnswerSelected;
  final bool? selectedAnswer;

  TrueFalseQuestion({
    required this.questionManager,
    required this.onAnswerSelected,
    this.selectedAnswer,
  });

  @override
  _TrueFalseQuestionState createState() => _TrueFalseQuestionState();
}

class _TrueFalseQuestionState extends State<TrueFalseQuestion> {
  List<bool?> _selectedAnswers = [];
  List<Map<String, dynamic>> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    _filterQuestions();
    _initializeSelectedAnswers();
  }

  @override
  void didUpdateWidget(covariant TrueFalseQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _filterQuestions();
  }

  void _filterQuestions() {
    setState(() {
      _filteredQuestions = widget.questionManager.questions
          .where((question) => question['type'] == 'truefalse')
          .take(5)
          .toList();
    });
  }

  void _initializeSelectedAnswers() {
    _selectedAnswers = List<bool?>.filled(_filteredQuestions.length, null);
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Câu hỏi: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Đúng / Sai', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          for (int i = 0; i < _filteredQuestions.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_filteredQuestions[i]['question'], style: TextStyle(fontSize: 18)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Radio<bool?>(
                          value: true,
                          groupValue: _selectedAnswers[i],
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswers[i] = value;
                            });
                            widget.onAnswerSelected(value!);
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Radio<bool?>(
                          value: false,
                          groupValue: _selectedAnswers[i],
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswers[i] = value;
                            });
                            widget.onAnswerSelected(value!);
                          },
                        ),
                      ],
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
