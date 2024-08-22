import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String idBoDe = "";
String DapAnDaChon = "";

class MultipleChoiceQuestion extends StatefulWidget {
  final String questionText;
  final List<String> answers;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;
  final String mode;
  final String correctAnswer;
  final String idQuestion;

  MultipleChoiceQuestion({
    required this.questionText,
    required this.answers,
    required this.onAnswerSelected,
    required this.selectedAnswer,
    required this.mode,
    required this.correctAnswer,
    required this.idQuestion,
  });

  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didUpdateWidget(covariant MultipleChoiceQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.idQuestion != oldWidget.idQuestion) {
      loadData();
    }
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    await GetStringBoDe();
    await fetchSelectedAnswer(widget.idQuestion);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> GetStringBoDe() async {
    final prefs = await SharedPreferences.getInstance();
    idBoDe = prefs.getString('boDeId') ?? "";
  }

  Future<void> fetchSelectedAnswer(String idQuestion) async {
    if (idBoDe.isNotEmpty) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('chi_tiet_bo_de')
          .where('Id_cau_hoi', isEqualTo: idQuestion)
          .where('Id_bo_de', isEqualTo: idBoDe)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        var data = docSnapshot.docs.first.data();
        DapAnDaChon = data['IsCorrect'] as String;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
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
          bool isSelected = widget.selectedAnswer == answer && widget.mode == 'lambai';
          bool isCorrect = widget.mode == 'xemdapan' && answer == widget.correctAnswer;
          bool isUserSelected = widget.mode == 'xemdapan' && answer == DapAnDaChon;

          return Column(
            children: [
              InkWell(
                onTap: widget.mode == 'lambai' ? () => widget.onAnswerSelected(answer) : null,
                child: Container(
                  width: buttonWidth,
                  height: 65,
                  decoration: BoxDecoration(
                    color: widget.mode == 'xemdapan'
                        ? isUserSelected
                        ? isCorrect
                        ? Colors.green[100]
                        : Colors.blueGrey[200]
                        : Colors.blueGrey[200]
                        : isSelected
                        ? Colors.lightBlue[800]
                        : Colors.blueGrey[200],
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: isUserSelected
                          ? isCorrect
                          ? Colors.green[700]!
                          : Colors.transparent
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
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
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (isUserSelected)
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: FaIcon(
                            FontAwesomeIcons.handPointLeft, // Icon bàn tay chỉ trái
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                      if (isCorrect)
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.green[700],
                            size: 32,
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
