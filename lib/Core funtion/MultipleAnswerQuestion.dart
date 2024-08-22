import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

String idBoDe = "";
List<String> DapAnDaChon = [];

class MultipleAnswerQuestion extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final Function(List<String>) onAnswersSelected;
  final List<String> selectedAnswers;
  final String mode;
  final List<String> correctAnswers;
  final String idQuestion;

  MultipleAnswerQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswersSelected,
    required this.selectedAnswers,
    required this.mode,
    required this.correctAnswers,
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
        DapAnDaChon = answersString.split('+');
        setState(() {}); // Cập nhật giao diện
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
          bool isCorrect = widget.mode == 'xemdapan' && widget.correctAnswers.contains(answer);
          bool isAnswerInDapAnDaChon = DapAnDaChon.contains(answer);

          // Xác định màu nền của item
          Color containerColor = Colors.blueGrey[200]!; // Màu nền mặc định

          // Nếu đang trong chế độ "lambai" và item được chọn, đổi màu nền thành lightBlue[800]
          if (widget.mode == 'lambai' && isSelected) {
            containerColor = Colors.lightBlue[800]!;
          }
          // Nếu đang trong chế độ "xemdapan" và cả hai biểu tượng xuất hiện, thay đổi màu nền thành xanh
          else if (widget.mode == 'xemdapan' && isCorrect && isAnswerInDapAnDaChon) {
            containerColor = Colors.greenAccent[100]!;
          }

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
                    color: containerColor, // Áp dụng màu nền nếu cần
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: Colors.black, // Sử dụng khung viền màu đen mặc định
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
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
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                answer,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            if (widget.mode == 'xemdapan' && isCorrect)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.check, // Biểu tượng dấu tích
                                  color: Colors.green[700], // Màu sắc của dấu tích
                                  size: 30, // Kích thước của dấu tích
                                ),
                              ),
                            if (widget.mode == 'xemdapan' && isAnswerInDapAnDaChon)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.handPointLeft, // Biểu tượng tay chỉ trái
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                          ],
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
