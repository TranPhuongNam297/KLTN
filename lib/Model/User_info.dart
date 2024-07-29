class User_info {
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

  factory User_info.fromMap(Map<String, dynamic> map) {
    return User_info(
      FullName: map['fullName'] ?? '',
      Id_User: map['idUser'] ?? '',
      IsActive: map['isActive'] ?? false,
      PassWord: map['password'] ?? '',
      PhoneNumber: map['phoneNumber'] ?? '',
      UserName: map['userName'] ?? '',
    );
  }
}
