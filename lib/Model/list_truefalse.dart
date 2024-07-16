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
}
