import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchingQuestion extends StatefulWidget {
  final Map<String, dynamic> matchingQuestion;
  final Function(bool) onAllCorrect;
  final String mode;

  const MatchingQuestion({
    Key? key,
    required this.matchingQuestion,
    required this.onAllCorrect,
    required this.mode,
  }) : super(key: key);

  @override
  _MatchingQuestionState createState() => _MatchingQuestionState();
}

class _MatchingQuestionState extends State<MatchingQuestion> {
  Map<String, String?> selectedAnswers = {};
  Map<String, bool> correctness = {};
  Map<String, Color> answerColors = {};

  @override
  void initState() {
    super.initState();
    _initializeAnswerColors();
    if (widget.mode == 'xemdapan') {
      _fetchAnswerColors();
    }
  }

  void _initializeAnswerColors() {
    final subQuestions = widget.matchingQuestion['subQuestions'] as List;
    for (var subQuestion in subQuestions) {
      answerColors[subQuestion['question']] = Colors.black;
    }
  }

  void onAnswerDropped(String question, String? answer) {
    if (widget.mode == 'lambai') {
      setState(() {
        if (selectedAnswers.containsKey(question)) {
          final previousAnswer = selectedAnswers[question];
          selectedAnswers.remove(question);
          selectedAnswers[question] = answer;
          selectedAnswers.removeWhere((key, value) => value == previousAnswer);
        } else {
          selectedAnswers[question] = answer;
        }
        correctness[question] = widget.matchingQuestion['subQuestions']
            .firstWhere((q) => q['question'] == question)['correctAnswer'] == answer;
        //answerColors[question] = correctness[question]! ? Colors.green : Colors.red;
        widget.onAllCorrect(_checkAllCorrect());
        _updateFirestore(question, answer);
      });
    }
  }

  bool _checkAllCorrect() {
    for (var subQuestion in widget.matchingQuestion['subQuestions']) {
      if (correctness[subQuestion['question']] != true) {
        return false;
      }
    }
    return true;
  }

  Future<void> _updateFirestore(String question, String? answer) async {
    if (widget.mode == 'lambai') {
      final prefs = await SharedPreferences.getInstance();
      final idBoDe = prefs.getString('boDeId')!;
      final subQuestions = widget.matchingQuestion['subQuestions'];
      final questionId = subQuestions.firstWhere((q) => q['question'] == question)['Id'];
      try {
        CollectionReference chiTietBoDeRef = FirebaseFirestore.instance.collection('chi_tiet_bo_de');
        QuerySnapshot snapshot = await chiTietBoDeRef
            .where('Id_cau_hoi', isEqualTo: questionId)
            .where('Id_bo_de', isEqualTo: idBoDe)
            .get();

        if (snapshot.docs.isNotEmpty) {
          DocumentSnapshot document = snapshot.docs.first;

          await document.reference.update({
            'IsCorrect': answer == widget.matchingQuestion['subQuestions']
                .firstWhere((q) => q['question'] == question)['correctAnswer'] ? 'dung' : 'sai',
          });
          print('Firestore update successful');
        } else {
          print('No document found for the given Id_cau_hoi and Id_bo_de');
        }
      } catch (error) {
        print('Failed to update Firestore: $error');
      }
    }
  }

  Future<void> _fetchAnswerColors() async {
    final prefs = await SharedPreferences.getInstance();
    final idBoDe = prefs.getString('boDeId')!;
    final subQuestions = widget.matchingQuestion['subQuestions'] as List;

    for (var subQuestion in subQuestions) {
      final questionId = subQuestion['Id'];

      CollectionReference chiTietBoDeRef = FirebaseFirestore.instance.collection('chi_tiet_bo_de');

      try {
        QuerySnapshot snapshot = await chiTietBoDeRef
            .where('Id_cau_hoi', isEqualTo: questionId)
            .where('Id_bo_de', isEqualTo: idBoDe)
            .get();

        if (snapshot.docs.isNotEmpty) {
          DocumentSnapshot document = snapshot.docs.first;
          String isCorrect = document['IsCorrect'];
          setState(() {
            answerColors[subQuestion['question']] = isCorrect == 'dung' ? Colors.green : Colors.red;
          });
        }
      } catch (error) {
        print('Failed to fetch answer colors: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List subQuestions = widget.matchingQuestion['subQuestions'] as List;

    return Container(
      height: 600, // Set a specific height
      child: Scaffold(
        body: Column(
          children: [
            Text(
              widget.matchingQuestion['question'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subQuestions.length,
                itemBuilder: (context, index) {
                  final subQuestion = subQuestions[index];
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          subQuestion['question'],
                          style: TextStyle(fontSize: 18, color: answerColors[subQuestion['question']]),
                        ),
                      ),
                      if (widget.mode == 'lambai')
                        DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              alignment: Alignment.center,
                              child: selectedAnswers[subQuestion['question']] != null
                                  ? Draggable<String>(
                                data: selectedAnswers[subQuestion['question']],
                                child: Card(
                                  margin: EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  color: Colors.indigo,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      selectedAnswers[subQuestion['question']]!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Card(
                                    margin: EdgeInsets.all(5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    color: Colors.indigo,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        selectedAnswers[subQuestion['question']]!,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Kéo vào đây', style: TextStyle(fontSize: 16)),
                                ),
                                onDragCompleted: () => setState(() {
                                  selectedAnswers.remove(subQuestion['question']);
                                }),
                              )
                                  : Text('Kéo vào đây', style: TextStyle(fontSize: 16)),
                            );
                          },
                          onAccept: (data) => onAnswerDropped(subQuestion['question'], data),
                        )
                      else
                        Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            subQuestion['correctAnswer'],
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            if (widget.mode == 'lambai') ...[
              SizedBox(height: 20),
              Expanded(
                child: Wrap(
                  spacing: 10,
                  children: [
                    for (final subQuestion in subQuestions)
                      if (!selectedAnswers.containsValue(subQuestion['correctAnswer']))
                        Draggable<String>(
                          data: subQuestion['correctAnswer'],
                          child: Card(
                            margin: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            color: Colors.indigo,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                subQuestion['correctAnswer'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          feedback: Material(
                            color: Colors.transparent,
                            child: Card(
                              margin: EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              color: Colors.indigo,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  subQuestion['correctAnswer'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
