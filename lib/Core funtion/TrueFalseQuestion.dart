import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrueFalseQuestion extends StatefulWidget {
  final Map<String, dynamic> trueFalseQuestion;
  final void Function(bool) onAnswerSelected;
  final String mode;

  TrueFalseQuestion({
    required this.trueFalseQuestion,
    required this.onAnswerSelected,
    required this.mode,
  });

  @override
  _TrueFalseQuestionState createState() => _TrueFalseQuestionState();
}

class _TrueFalseQuestionState extends State<TrueFalseQuestion> {
  List<bool?> _selectedAnswers = [];
  List<Color> _answerColors = [];

  @override
  void initState() {
    super.initState();
    _initializeSelectedAnswers();
    if (widget.mode == 'xemdapan') {
      _fetchAnswerColors();
    }
  }

  @override
  void didUpdateWidget(TrueFalseQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trueFalseQuestion != oldWidget.trueFalseQuestion) {
      _initializeSelectedAnswers();
      if (widget.mode == 'xemdapan') {
        _fetchAnswerColors();
      }
    }
  }

  void _initializeSelectedAnswers() {
    final subQuestions = widget.trueFalseQuestion['subQuestions1'];
    _selectedAnswers = List<bool?>.filled(subQuestions.length, null);
    _answerColors = List<Color>.filled(subQuestions.length, Colors.black);

    if (widget.mode == 'xemdapan') {
      for (int i = 0; i < subQuestions.length; i++) {
        _selectedAnswers[i] = subQuestions[i]['correctAnswer'];
      }
    }
  }

  Future<void> _fetchAnswerColors() async {
    final prefs = await SharedPreferences.getInstance();
    final idBoDe = prefs.getString('boDeId')!;
    final subQuestions = widget.trueFalseQuestion['subQuestions1'];

    for (int i = 0; i < subQuestions.length; i++) {
      final questionId = subQuestions[i]['Id'];

      CollectionReference chiTietBoDeRef =
      FirebaseFirestore.instance.collection('chi_tiet_bo_de');

      try {
        QuerySnapshot snapshot = await chiTietBoDeRef
            .where('Id_cau_hoi', isEqualTo: questionId)
            .where('Id_bo_de', isEqualTo: idBoDe)
            .get();

        if (snapshot.docs.isNotEmpty) {
          DocumentSnapshot document = snapshot.docs.first;
          String isCorrect = document['IsCorrect'];

          setState(() {
            _answerColors[i] = isCorrect == 'dung' ? Colors.green : Colors.red;
          });
        }
      } catch (error) {
        print('Failed to fetch answer colors: $error');
      }
    }
  }

  void _onRadioChanged(bool? value, int index) async {
    setState(() {
      _selectedAnswers[index] = value;
    });

    bool allCorrect = _selectedAnswers.every((answer) {
      int answerIndex = _selectedAnswers.indexOf(answer);
      return answer != null &&
          answer ==
              widget.trueFalseQuestion['subQuestions1'][answerIndex]
              ['correctAnswer'];
    });

    widget.onAnswerSelected(allCorrect);

    if (widget.mode == 'lambai') {
      final prefs = await SharedPreferences.getInstance();
      final idBoDe = prefs.getString('boDeId')!;
      final subQuestions = widget.trueFalseQuestion['subQuestions1'];

      if (subQuestions.length > index) {
        final questionId = subQuestions[index]['Id'];

        CollectionReference chiTietBoDeRef =
        FirebaseFirestore.instance.collection('chi_tiet_bo_de');

        try {
          QuerySnapshot snapshot = await chiTietBoDeRef
              .where('Id_cau_hoi', isEqualTo: questionId)
              .where('Id_bo_de', isEqualTo: idBoDe)
              .get();
          if (snapshot.docs.isNotEmpty) {
            DocumentSnapshot document = snapshot.docs.first;
            await document.reference.update({
              'IsCorrect': _selectedAnswers[index] ==
                  subQuestions[index]['correctAnswer']
                  ? 'dung'
                  : 'sai',
            });
            print('Update successful');
          } else {
            print('No document found for the given Id_cau_hoi and Id_bo_de');
          }
        } catch (error) {
          print('Failed to update: $error');
        }
      } else {
        print('Invalid index for subQuestions');
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
            child: Center(
              child: Text(
                'Câu hỏi đúng sai',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.blueAccent),
              ),
            ),
          ),
          for (int i = 0; i < subQuestions.length; i++)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      subQuestions[i]['question'],
                      style: TextStyle(fontSize: 18, color: _answerColors[i]),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Radio<bool?>(
                              value: true,
                              groupValue: _selectedAnswers[i],
                              onChanged: widget.mode == 'lambai'
                                  ? (value) {
                                _onRadioChanged(value, i);
                              }
                                  : null,
                            ),
                          ),
                          Text('Đúng'),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Radio<bool?>(
                              value: false,
                              groupValue: _selectedAnswers[i],
                              onChanged: widget.mode == 'lambai'
                                  ? (value) {
                                _onRadioChanged(value, i);
                              }
                                  : null,
                            ),
                          ),
                          Text('Sai'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
