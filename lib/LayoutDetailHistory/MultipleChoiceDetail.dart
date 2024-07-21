import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MultipleChoiceDetail extends StatefulWidget {
  final String id;

  MultipleChoiceDetail({required this.id});

  @override
  _MultipleAnswerQuestionState createState() => _MultipleAnswerQuestionState();
}

class _MultipleAnswerQuestionState extends State<MultipleChoiceDetail> {
  List<String> selectedAnswers = [];
  late Future<Map<String, dynamic>> questionDataFuture;
  late Future<List<Map<String, dynamic>>> answersDataFuture;

  @override
  void initState() {
    super.initState();
    questionDataFuture = _fetchQuestion(widget.id);
    answersDataFuture = _fetchAnswers(widget.id);
  }

  Future<Map<String, dynamic>> _fetchQuestion(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('list_question')
        .doc(id)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> _fetchAnswers(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('list_answer')
        .where('Id_Question', isEqualTo: id)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: questionDataFuture,
        builder: (context, questionSnapshot) {
          if (questionSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (questionSnapshot.hasError) {
            return Center(child: Text('Error: ${questionSnapshot.error}'));
          } else if (!questionSnapshot.hasData || questionSnapshot.data == null) {
            return Center(child: Text('No data found.'));
          }

          var questionData = questionSnapshot.data!;
          var questionText = questionData['Question'];

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: answersDataFuture,
            builder: (context, answersSnapshot) {
              if (answersSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (answersSnapshot.hasError) {
                return Center(child: Text('Error: ${answersSnapshot.error}'));
              } else if (!answersSnapshot.hasData || answersSnapshot.data == null) {
                return Center(child: Text('No answers found.'));
              }

              var answersData = answersSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: SingleChildScrollView(
                        child: Text(
                          questionText,
                          style: TextStyle(fontSize: 24, fontFamily: 'OpenSans'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: answersData.map((answerData) {
                          var answer = answerData['Dap_An'];
                          var isCorrect = answerData['Is_Correct'];
                          bool isSelected = selectedAnswers.contains(answer);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedAnswers.remove(answer);
                                  } else {
                                    if (selectedAnswers.length < 3) {
                                      selectedAnswers.add(answer);
                                    }
                                  }
                                  // Có thể thực hiện xử lý với danh sách selectedAnswers tại đây
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (isSelected) {
                                    return Colors.blue[200]!;
                                  } else if (isCorrect) {
                                    return Colors.green[200]!;
                                  } else {
                                    return Colors.grey[350]!;
                                  }
                                }),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Container(
                                width: 300,
                                height: 55, // Đã thay đổi kích thước nút
                                alignment: Alignment.center,
                                child: Text(
                                  answer,
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
