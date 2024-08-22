import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String idBoDe = "";
List<String> DapAnDaChon = [];

class MultipleAnswerQuestion extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final Function(List<String>) onAnswersSelected;
  final List<String> selectedAnswers;
  final String mode;
  final String idQuestion;

  MultipleAnswerQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswersSelected,
    required this.selectedAnswers,
    required this.mode,
    required this.idQuestion,
  });

  @override
  _MultipleAnswerQuestionState createState() => _MultipleAnswerQuestionState();
}

class _MultipleAnswerQuestionState extends State<MultipleAnswerQuestion> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await GetStringBoDe();
    await fetchSelectedAnswers(widget.idQuestion);
  }

  Future<void> GetStringBoDe() async {
    final prefs = await SharedPreferences.getInstance();
    idBoDe = prefs.getString('boDeId') ?? "";
  }

  Future<void> fetchSelectedAnswers(String idQuestion) async {
    if (idBoDe.isNotEmpty) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('chi_tiet_bo_de')
          .where('Id_cau_hoi', isEqualTo: idQuestion)
          .where('Id_bo_de', isEqualTo: idBoDe)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        var data = docSnapshot.docs.first.data();
        String answersString = data['IsCorrect'] as String;
        // Tách chuỗi bằng dấu cộng và cập nhật biến toàn cục
        DapAnDaChon = answersString.split('+');
        setState(() {}); // Cập nhật giao diện
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9; // Chiều rộng bằng 90% màn hình

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: buttonWidth,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.zero,
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
          bool isSelected = widget.selectedAnswers.contains(answer);
          bool isCorrect = widget.mode == 'xemdapan' && DapAnDaChon.contains(answer);
          bool isUserSelected = widget.mode == 'xemdapan' && isSelected;
          bool isIncorrect = widget.mode == 'xemdapan' && isSelected && !isCorrect;

          return Column(
            children: [
              InkWell(
                onTap: widget.mode == 'lambai'
                    ? () {
                  List<String> updatedSelections = List.from(widget.selectedAnswers);
                  if (updatedSelections.contains(answer)) {
                    updatedSelections.remove(answer);
                  } else {
                    updatedSelections.add(answer);
                  }
                  widget.onAnswersSelected(updatedSelections);
                }
                    : null, // Vô hiệu hóa trong chế độ "xemdapan"
                child: Container(
                  width: buttonWidth,
                  height: 65,
                  decoration: BoxDecoration(
                    color: widget.mode == 'xemdapan'
                        ? isUserSelected
                        ? isCorrect
                        ? Colors.green[100] // Màu nền cho đáp án đúng đã chọn
                        : Colors.red[100] // Màu nền cho đáp án sai đã chọn
                        : Colors.blueGrey[200] // Màu nền mặc định cho đáp án chưa chọn
                        : isSelected
                        ? Colors.lightBlue[800] // Màu nền cho đáp án đã chọn trong chế độ "lambai"
                        : Colors.blueGrey[200], // Màu nền mặc định cho đáp án chưa chọn
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: isUserSelected ? (isCorrect ? Colors.green[700]! : Colors.red[700]!) : Colors.transparent, // Khung viền màu xanh lá cây cho đáp án đúng và màu đỏ cho đáp án sai
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      // Ba dấu gạch ngang bên trái
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: 36, // Kích thước của nút menu
                        ),
                      ),
                      SizedBox(width: 8),
                      VerticalDivider(
                        width: 1,
                        color: Colors.black,
                        thickness: 1,
                      ),
                      SizedBox(width: 8),
                      // Phần đáp án
                      Expanded(
                        child: Text(
                          answer,
                          style: TextStyle(
                            fontSize: 20,
                            color: isUserSelected ? Colors.black : Colors.black,
                            fontWeight: isUserSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      // Biểu tượng (nếu có)
                      if (widget.mode == 'xemdapan')
                        if (isCorrect)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.green[700], // Đổi màu sắc của dấu tích thành xanh lá cây
                              size: 36, // Tăng kích thước của dấu tích
                            ),
                          ),
                      if (isIncorrect)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.red[700], // Đổi màu sắc của dấu X thành đỏ
                            size: 36, // Tăng kích thước của dấu X
                          ),
                        ),
                    ],
                  ),
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
