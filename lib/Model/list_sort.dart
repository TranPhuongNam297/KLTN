import 'package:cloud_firestore/cloud_firestore.dart';

class ListSort {
  String Id;
  List<dynamic> Answer;
  String CorrectAnswer;
  String Question;

  ListSort({
    required this.Id,
    required this.Answer,
    required this.CorrectAnswer,
    required this.Question,
  });

  factory ListSort.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ListSort(
      Id: data['Id'],
      Answer: List.from(data['Answer']),
      CorrectAnswer: data['CorrectAnswer'],
      Question: data['Question'],
    );
  }

  // Method to convert ListSort object to a Firestore map
  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Answer': Answer,
      'CorrectAnswer': CorrectAnswer,
      'Question': Question,
    };
  }
}
