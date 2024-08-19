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
          bool userAnswer; // Lấy đáp án của người dùng
          userAnswer = isCorrect == 'dung';

          setState(() {
            _answerColors[i] = isCorrect == 'dung' ? Colors.green : Colors.red;
            _selectedAnswers[i] =
                userAnswer; // Cập nhật radio button theo đáp án người dùng
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
          answer == widget.trueFalseQuestion['subQuestions1'][answerIndex]
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
            print(
                'No document found for the given Id_cau_hoi and Id_bo_de');
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu hỏi đúng sai',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            for (int i = 0; i < subQuestions.length; i++)
              Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Văn bản câu hỏi
                      Text(
                        subQuestions[i]['question'],
                        style: TextStyle(
                          fontSize: 16, // Giảm kích thước chữ
                          color: _answerColors[i],
                        ),
                      ),
                      SizedBox(height: 8), // Thêm khoảng cách giữa văn bản câu hỏi và các nút radio
                      // Các nút radio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Đúng",
                                style: TextStyle(fontSize: 14), // Giảm kích thước chữ
                              ),
                              Radio<bool?>(
                                value: true,
                                groupValue: _selectedAnswers[i],
                                onChanged: widget.mode == 'lambai'
                                    ? (value) {
                                  _onRadioChanged(value, i);
                                }
                                    : null,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Sai",
                                style: TextStyle(fontSize: 14), // Giảm kích thước chữ
                              ),
                              Radio<bool?>(
                                value: false,
                                groupValue: _selectedAnswers[i],
                                onChanged: widget.mode == 'lambai'
                                    ? (value) {
                                  _onRadioChanged(value, i);
                                }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


}