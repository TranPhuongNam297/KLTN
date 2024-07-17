import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/bo_de.dart';
import 'Model/list_matching.dart';
import 'Model/list_truefalse.dart';
import 'Model/question_mutiple.dart';
import 'TaskItem.dart';
import 'SharedPreferences/SharedPreferences.dart';
import 'Model/chi_tiet_bo_de.dart';
import 'TestRulesScreen.dart'; // Import the UserPreferences class

class listTask extends StatefulWidget {
  @override
  _ListTaskState createState() => _ListTaskState();
}

class _ListTaskState extends State<listTask> {
  List<Map<String, dynamic>> boDeList = [];
  bool _isLoading = false; // Track loading state for popup

  @override
  void initState() {
    super.initState();
    _fetchBoDeList();
  }

  Future<void> _fetchBoDeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('idUser');

    if (userId == null) {
      print("User ID not found in SharedPreferences");
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Bo_de')
        .where('Id_user_tao', isEqualTo: userId)
        .get();

    setState(() {
      boDeList = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _createNewBoDe() async {
    String? userId = await UserPreferences.getUserId();

    if (userId == null) {
      print("Could not fetch user ID from SharedPreferences");
      return;
    }

    String newId = FirebaseFirestore.instance.collection('Bo_de').doc().id;
    String ngayTao = DateFormat('yyyy-MM-dd').format(DateTime.now());

    bo_de newBoDe = bo_de(
      Id: newId,
      Id_user_tao: userId,
      Ngay_tao: ngayTao,
      Tinh_trang: false,
      Generate: false,
      DiemSo: 0,
    );

    await FirebaseFirestore.instance
        .collection('Bo_de')
        .doc(newId)
        .set(newBoDe.toMap());

    // Save the new bo_de Id to SharedPreferences using UserPreferences
    await UserPreferences.saveBoDeId(newId);

    setState(() {
      boDeList.add(newBoDe.toMap());
    });
  }

  void _showCreateNewBoDeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text('Xác nhận'),
            content: Text('Bạn có muốn tạo bộ đề mới không?'),
            backgroundColor: Colors.white, // Set background color to white
            elevation: 24.0, // Add elevation for shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _createNewBoDe(); // Create new test set
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startTest(BuildContext context, String boDeId) async {
    setState(() {
      _isLoading = true; // Show loading popup
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('latestBoDeId', boDeId);

    // Check if the Bo_de has been generated
    DocumentSnapshot boDeSnapshot =
    await FirebaseFirestore.instance.collection('Bo_de').doc(boDeId).get();

    bo_de boDe =
    bo_de.fromMap(boDeSnapshot.data() as Map<String, dynamic>, boDeId);

    if (boDe.Generate) {
      // If already generated, just navigate to the test screen
      setState(() {
        _isLoading = false; // Hide loading popup
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestRulesScreen(),
        ),
      );
      return;
    }

    // Fetch questions and other data here
    QuerySnapshot questionSnapshot =
    await FirebaseFirestore.instance.collection('list_question').get();
    QuerySnapshot trueFalseSnapshot =
    await FirebaseFirestore.instance.collection('list_truefalse').get();
    QuerySnapshot matchingSnapshot =
    await FirebaseFirestore.instance.collection('list_matching').get();

    List<list_question> questions = questionSnapshot.docs.map((doc) {
      return list_question.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    List<list_truefalse> trueFalseQuestions = trueFalseSnapshot.docs.map((doc) {
      return list_truefalse.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    List<list_matching> matchingQuestions = matchingSnapshot.docs.map((doc) {
      return list_matching.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    // Shuffle and select up to 10 questions
    Random random = Random();
    List<Map<String, String>> selectedQuestions = [];

    void addRandomQuestions<T>(List<T> questionList, int count) {
      questionList.shuffle(random);
      int takeCount = min(count, questionList.length);
      selectedQuestions.addAll(questionList.take(takeCount).map((q) {
        if (q is list_question) {
          return {
            'id': q.Id_Question,
            'type': q.Type, // Use the Type value from the model
          };
        } else if (q is list_truefalse) {
          return {
            'id': q.Id_Question,
            'type': q.Type, // Use the Type value from the model
          };
        } else if (q is list_matching) {
          return {
            'id': q.Id_Question,
            'type': q.Type, // Use the Type value from the model
          };
        } else {
          throw Exception('Unknown question type');
        }
      }));
    }

    addRandomQuestions(questions, 20);
    addRandomQuestions(trueFalseQuestions, 10);
    addRandomQuestions(matchingQuestions, 10);

    CollectionReference chiTietBoDeCollection =
    FirebaseFirestore.instance.collection('chi_tiet_bo_de');

    for (var question in selectedQuestions) {
      chi_tiet_bo_de chiTiet = chi_tiet_bo_de(
        Id: chiTietBoDeCollection.doc().id,
        // Auto-generate ID
        Id_bo_de: boDeId,
        Id_cau_hoi: question['id']!,
        Type_cau_hoi: question['type']!,
        IsCorrect: false,
      );

      await chiTietBoDeCollection.doc(chiTiet.Id).set(chiTiet.toMap());
    }

    // Update the Bo_de to mark it as generated
    await FirebaseFirestore.instance
        .collection('Bo_de')
        .doc(boDeId)
        .update({'Generate': true});

    setState(() {
      _isLoading = false; // Hide loading popup
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestRulesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Danh sách bộ đề', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: boDeList.length,
                  itemBuilder: (context, index) {
                    return TaskItem(
                      title: 'Bộ đề ${index + 1}',
                      imageUrl: 'images/tetmass3.png',
                      onTap: () {
                        String boDeId = boDeList[index]['Id'];
                        _startTest(context, boDeId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isLoading) // Show loading popup
            Center(
              child: AlertDialog(
                title: Text('Đang tải...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Vui lòng chờ trong giây lát.'),
                  ],
                ),
                backgroundColor: Colors.white,
                elevation: 24.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: Colors.indigo, // Replace with your desired color
          child: InkWell(
            splashColor: Colors.white, // Splash color when tapped
            child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(Icons.add, color: Colors.white)),
            onTap: _showCreateNewBoDeDialog,
          ),
        ),
      ),
    );
  }
}
