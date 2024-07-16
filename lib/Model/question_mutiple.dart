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
}
