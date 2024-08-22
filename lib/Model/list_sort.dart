import 'package:cloud_firestore/cloud_firestore.dart';

class list_sort {
  String Id;
  List<String> Answer;
  String CorrectAnswer;
  String Question;
  String Type;

  list_sort({
    required this.Id,
    required this.Answer,
    required this.CorrectAnswer,
    required this.Question,
    required this.Type,
  });

  factory list_sort.fromMap(Map<String, dynamic> data, String documentId) {
    return list_sort(
      Id: documentId,
      Answer: List<String>.from(data['Answer'] ?? []),
      CorrectAnswer: data['CorrectAnswer'] ?? '',
      Question: data['Question'] ?? '',
      Type: data['Type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Answer': Answer,
      'CorrectAnswer': CorrectAnswer,
      'Question': Question,
      'Type': Type,
    };
  }

  static Future<list_sort> getListSortById(String idCauHoi) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('list_sort')
          .doc(idCauHoi)
          .get();

      if (doc.exists) {
        return list_sort.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print('Document does not exist');
        return list_sort(
          Id: '',
          Answer: [],
          CorrectAnswer: '',
          Question: '',
          Type: '',
        );
      }
    } catch (e) {
      print('Error getting document: $e');
      return list_sort(
        Id: '',
        Answer: [],
        CorrectAnswer: '',
        Question: '',
        Type: '',
      );
    }
  }
}
