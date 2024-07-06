class User_info{
  String FullName;
  String Id_User;
  bool IsActive;
  String PassWord;
  String PhoneNumber;
  String UserName;

  User_info({
    required this.FullName,
    required this.Id_User,
    required this.IsActive,
    required this.PassWord,
    required this.PhoneNumber,
    required this.UserName,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': FullName,
      'idUser': Id_User,
      'isActive': IsActive,
      'password': PassWord,
      'phoneNumber': PhoneNumber,
      'userName': UserName,
    };
  }
}
