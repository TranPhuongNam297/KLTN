import 'package:cloud_firestore/cloud_firestore.dart';

class list_answer {
  String Dap_An;
  String Id_DapAn;
  String Id_Question;
  bool Is_Correct;

  list_answer({
    required this.Dap_An,
    required this.Id_DapAn,
    required this.Id_Question,
    required this.Is_Correct,
  });

  Map<String, dynamic> toMap() {
    return {
      'Dap_An': Dap_An,
      'Id_DapAn': Id_DapAn,
      'Id_Question': Id_Question,
      'Is_Correct': Is_Correct,
    };
  }

  factory list_answer.fromMap(Map<String, dynamic> map, String id) {
    return list_answer(
      Dap_An: map['Dap_An'],
      Id_DapAn: id,
      Id_Question: map['Id_Question'],
      Is_Correct: map['Is_Correct'],
    );
  }

  static Future<List<list_answer>> getListAnswerById(String idAnswer) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('list_answer').where('Id_Question', isEqualTo: idAnswer).get();
      List<list_answer> answers = [];
      snapshot.docs.forEach((doc) {
        answers.add(list_answer.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      });
      return answers;
    } catch (e) {
      throw Exception('Error getting list_answer data: $e');
    }
  }

}
