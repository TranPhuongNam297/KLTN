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
}
