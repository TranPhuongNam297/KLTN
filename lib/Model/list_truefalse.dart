import 'package:cloud_firestore/cloud_firestore.dart';

class list_truefalse {
  bool CorrectAnswer;
  String Id_Question;
  String Question;
  String Type;

  list_truefalse({
    required this.CorrectAnswer,
    required this.Id_Question,
    required this.Question,
    required this.Type,
  });

  factory list_truefalse.fromMap(Map<String, dynamic> data, String documentId) {
    return list_truefalse(
      Id_Question: documentId,
      Question: data['Question'] ?? '',
      Type: data['Type'] ?? '',
      CorrectAnswer: data['CorrectAnswer'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CorrectAnswer': CorrectAnswer,
      'Id_Question': Id_Question,
      'Question': Question,
      'Type': Type,
    };
  }

  static Future<list_truefalse> getListTrueFalseById(String idQuestion) async {
    try {
      // Truy vấn Firestore để lấy dữ liệu
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('list_truefalse')
          .doc(idQuestion)
          .get();

      // Kiểm tra nếu document tồn tại thì trả về đối tượng list_truefalse
      if (doc.exists) {
        return list_truefalse.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print('Document does not exist');
        return list_truefalse(
          CorrectAnswer: false,
          Id_Question: '',
          Question: '',
          Type: '',
        );
      }
    } catch (e) {
      print('Error getting document: $e');
      return list_truefalse(
        CorrectAnswer: false,
        Id_Question: '',
        Question: '',
        Type: '',
      );
    }
  }
}
