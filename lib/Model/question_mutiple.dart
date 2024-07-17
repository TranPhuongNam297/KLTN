import 'package:cloud_firestore/cloud_firestore.dart';

class list_question {
  String Id_Question;
  String Question;
  String Type;

  list_question({
    required this.Id_Question,
    required this.Question,
    required this.Type,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id_Question': Id_Question,
      'Question': Question,
      'Type': Type,
    };
  }

  factory list_question.fromMap(Map<String, dynamic> map, String id) {
    return list_question(
      Id_Question: id,
      Question: map['Question'] ?? '',
      Type: map['Type'] ?? '',
    );
  }

  static Future<list_question> getListQuestionById(String idQuestion) async {
    try {
      // Truy vấn Firestore để lấy dữ liệu
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('list_question').doc(idQuestion).get();

      // Kiểm tra nếu document tồn tại thì trả về đối tượng list_question
      if (snapshot.exists) {
        return list_question.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      throw Exception('Error getting list_question data: $e');
    }
  }

}
