import 'package:cloud_firestore/cloud_firestore.dart';

class list_matching {
  String CorrectAnswer;
  String Id_Question;
  String Question;
  String Type;

  list_matching({
    required this.CorrectAnswer,
    required this.Id_Question,
    required this.Question,
    required this.Type,
  });

  factory list_matching.fromMap(Map<String, dynamic> data, String documentId) {
    return list_matching(
      Id_Question: documentId,
      Question: data['Question'] ?? '',
      Type: data['Type'] ?? '',
      CorrectAnswer: data['CorrectAnswer'] ?? '',
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
  static Future<list_matching> getListMatchingById(String idCauHoi) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('list_matching')
          .doc(idCauHoi)
          .get();

      if (doc.exists) {
        return list_matching.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print('Document does not exist');
        return list_matching(
          CorrectAnswer: '',
          Id_Question: '',
          Question: '',
          Type: '',
        );
      }
    } catch (e) {
      print('Error getting document: $e');
      return list_matching(
        CorrectAnswer: '',
        Id_Question: '',
        Question: '',
        Type: '',
      );
    }
  }
}
