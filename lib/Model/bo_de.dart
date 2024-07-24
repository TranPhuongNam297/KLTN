class bo_de {
  String Id;
  String Id_user_tao;
  String Ngay_tao;
  bool Tinh_trang;
  bool Generate;
  int DiemSo;
  bool Mode;

  bo_de({
    required this.Id,
    required this.Id_user_tao,
    required this.Ngay_tao,
    required this.Tinh_trang,
    required this.Generate,
    required this.DiemSo,
    required this.Mode
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Id_user_tao': Id_user_tao,
      'Ngay_tao': Ngay_tao,
      'Tinh_trang': Tinh_trang,
      'Generate': Generate,
      'DiemSo': DiemSo,
      'Mode': Mode,
    };
  }

  factory bo_de.fromMap(Map<String, dynamic> map, String id) {
    return bo_de(
        Id: id,
        Id_user_tao: map['Id_user_tao'],
        Ngay_tao: map['Ngay_tao'],
        Tinh_trang: map['Tinh_trang'],
        Generate: map['Generate'],
        DiemSo: map['DiemSo'],
        Mode: map['Mode']
    );
  }
}