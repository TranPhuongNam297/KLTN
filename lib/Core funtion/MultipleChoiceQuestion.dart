import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;
  final String mode;

  MultipleChoiceQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswerSelected,
    required this.selectedAnswer,
    required this.mode,
  });

  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  Map<String, String> answerStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchAnswerStatus();
  }

  Future<void> _fetchAnswerStatus() async {
    if (widget.mode == 'xemdapan') {
      final prefs = await SharedPreferences.getInstance();
      final idBoDe = prefs.getString('boDeId')!;
      final CollectionReference chiTietBoDeRef = FirebaseFirestore.instance.collection('chi_tiet_bo_de');

      try {
        QuerySnapshot snapshot = await chiTietBoDeRef
            .where('Id_bo_de', isEqualTo: idBoDe)
            .get();

        final docs = snapshot.docs;
        final subQuestions = widget.answers;

        Map<String, String> status = {};
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final questionId = data['Id_cau_hoi'];
          final isCorrect = data['IsCorrect'] as String;

          if (subQuestions.contains(questionId)) {
            status[questionId] = isCorrect;
          }
        }

        setState(() {
          answerStatus = status;
        });
      } catch (error) {
        print('Failed to fetch answer status: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

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
                widget.questionText,
                style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ...widget.answers.map((answer) {
          bool isSelected = widget.selectedAnswer == answer;
          bool isCorrect = false;

          if (widget.mode == 'xemdapan') {
            isCorrect = answerStatus[answer] == 'dung';
          }

          return Column(
            children: [
              InkWell(
                onTap: widget.mode == 'lambai' ? () => widget.onAnswerSelected(answer) : null,
                child: Container(
                  width: buttonWidth,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue[400]
                        : (widget.mode == 'xemdapan'
                        ? (isCorrect ? Colors.green[200] : Colors.red[200])
                        : Colors.grey[400]),
                    borderRadius: BorderRadius.circular(0),
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
