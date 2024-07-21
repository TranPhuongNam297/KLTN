import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/LayoutDetailHistory/MatchingDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LayoutDetailHistory/MultipleChoiceDetail.dart';
import '../LayoutDetailHistory/TrueFalseDetail.dart';

class AnswerDetail extends StatefulWidget {
  final int totalQuestions;
  final List<bool?> questionResults;

  AnswerDetail({required this.totalQuestions, required this.questionResults});

  @override
  _AnswerDetailState createState() => _AnswerDetailState();
}

class _AnswerDetailState extends State<AnswerDetail> {
  late Future<List<Map<String, dynamic>>> _completedBoDeList;

  @override
  void initState() {
    super.initState();
    _completedBoDeList = _fetchCompletedBoDeList();
  }

  Future<List<Map<String, dynamic>>> _fetchCompletedBoDeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idBoDe = prefs.getString('boDeId');
    if (idBoDe == null) {
      return [];
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chi_tiet_bo_de')
        .where('Id_bo_de', isEqualTo: idBoDe)
        .get();

    List<Map<String, dynamic>> completedBoDeList = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();
    return completedBoDeList;
  }

  void _navigateToDetail(BuildContext context, String questionType, String id) {
    print(id+"trc luc bam");
    switch (questionType) {
      case 'matching':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchingDetail(id: id),
        ));
        break;
      case 'truefalse':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrueFalseDetail(id: id)),
        );
        break;
      case 'multiple_choice':
      case 'multiple_answer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MultipleChoiceDetail(id: id)),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết đáp án',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _completedBoDeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi khi tải dữ liệu'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            var completedBoDeList = snapshot.data!;
            return ListView.builder(
              itemCount: completedBoDeList.length,
              itemBuilder: (context, index) {
                var item = completedBoDeList[index];
                final questionNumber = index + 1;
                final isCorrect = item['IsCorrect'] as bool? ?? false;
                final questionType = item['Type_cau_hoi'] as String? ?? 'N/A';
                final questionId = item['Id_cau_hoi'] as String? ?? 'N/A';

                return ListTile(
                  title: Text('Câu hỏi $questionNumber:'),
                  trailing: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCorrect ? 'Đúng' : 'Sai',
                        style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                  onTap: () => _navigateToDetail(context, questionType, questionId),
                );
              },
            );
          }
        },
      ),
    );
  }
}