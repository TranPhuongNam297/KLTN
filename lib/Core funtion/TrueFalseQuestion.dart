import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrueFalseQuestion extends StatefulWidget {
  final Map<String, dynamic> trueFalseQuestion; // Cập nhật từ QuestionManager thành Map
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

  void _onRadioChanged(bool? value, int index) async {
    setState(() {
      _selectedAnswers[index] = value;
    });

    // Xác định tất cả các câu trả lời có đúng không
    bool allCorrect = _selectedAnswers.every((answer) {
      int answerIndex = _selectedAnswers.indexOf(answer);
      return answer != null && answer == widget.trueFalseQuestion['subQuestions1'][answerIndex]['correctAnswer'];
    });

    // Thực hiện callback khi câu trả lời được chọn
    widget.onAnswerSelected(allCorrect);

    if (widget.mode == 'lambai') {
      final prefs = await SharedPreferences.getInstance();
      final idBoDe = prefs.getString('boDeId')!;
      final subQuestions = widget.trueFalseQuestion['subQuestions1'];

      if (subQuestions.length > index) {
        final questionId = subQuestions[index]['Id']; // ID câu hỏi trong subQuestions
        print(idBoDe);
        print(questionId);

        CollectionReference chiTietBoDeRef = FirebaseFirestore.instance.collection('chi_tiet_bo_de');

        try {
          // Tìm tài liệu cụ thể dựa trên Id và Id_bo_de
          QuerySnapshot snapshot = await chiTietBoDeRef
              .where('Id_cau_hoi', isEqualTo: questionId)
              .where('Id_bo_de', isEqualTo: idBoDe)
              .get();

          // Cập nhật tài liệu đầu tiên nếu có tài liệu khớp với điều kiện
          if (snapshot.docs.isNotEmpty) {
            DocumentSnapshot document = snapshot.docs.first;

            await document.reference.update({
              'IsCorrect': _selectedAnswers[index] == subQuestions[index]['correctAnswer'] ? 'dung' : 'sai',
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Câu hỏi đúng sai'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Câu hỏi đúng sai',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  textAlign: TextAlign.center,
                ),
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subQuestions.length,
              itemBuilder: (context, i) {
                return Column(
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
                                onChanged: widget.mode == 'lambai'
                                    ? (value) {
                                  _onRadioChanged(value, i);
                                }
                                    : null,
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
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
