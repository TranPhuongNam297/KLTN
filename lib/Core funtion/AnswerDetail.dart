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
  }

  void _navigateToDetail() {

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
                  onTap: () => _navigateToDetail(),
                );
              },
            );
          }
        },
      ),
    );
  }
}