class bo_de {
  String Id;
  String Id_user_tao;
  String Ngay_tao;
  bool Tinh_trang;

  bo_de({
    required this.Id,
    required this.Id_user_tao,
    required this.Ngay_tao,
    required this.Tinh_trang,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Id_user_tao': Id_user_tao,
      'Ngay_tao': Ngay_tao,
      'Tinh_trang': Tinh_trang,
    };
  }
}