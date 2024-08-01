class Key_Active {
  int Date;
  String Id_Key;
  String Id_User;
  int Month;
  String Time_End;
  String Time_Start;
  bool Used;
  int Practice;
  int Test;

  Key_Active({
    required this.Date,
    required this.Id_Key,
    required this.Id_User,
    required this.Month,
    required this.Time_End,
    required this.Time_Start,
    required this.Used,
    required this.Practice,
    required this.Test
  });

  Map<String, dynamic> toMap() {
    return {
      'Date': Date,
      'Id_Key': Id_Key,
      'Id_User': Id_User,
      'Month': Month,
      'Time_End': Time_End,
      'Time_Start': Time_Start,
      'Used': Used,
      'Practice': Practice,
      'Test': Test
    };
  }

  factory Key_Active.fromMap(Map<String, dynamic> map, String id) {
    return Key_Active(
        Date: map['Date'],
        Id_Key: id,
        Id_User: map['Id_User'],
        Month: map['Month'],
        Time_End: map['Time_End'],
        Time_Start: map['Time_Start'],
        Used: map['Used'],
        Practice: map['Practice'],
        Test: map['Test']
    );
  }
}