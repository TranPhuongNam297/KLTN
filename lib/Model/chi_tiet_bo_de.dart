class chi_tiet_bo_de {
  String Id;
  String Id_bo_de;
  String Id_cau_hoi;
  String Type_cau_hoi; // Change this to String

  chi_tiet_bo_de({
    required this.Id,
    required this.Id_bo_de,
    required this.Id_cau_hoi,
    required this.Type_cau_hoi,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Id_bo_de': Id_bo_de,
      'Id_cau_hoi': Id_cau_hoi,
      'Type_cau_hoi': Type_cau_hoi,
    };
  }

  factory chi_tiet_bo_de.fromMap(Map<String, dynamic> map, String id) {
    return chi_tiet_bo_de(
      Id: id,
      Id_bo_de: map['Id_bo_de'],
      Id_cau_hoi: map['Id_cau_hoi'],
      Type_cau_hoi: map['Type_cau_hoi'],
    );
  }
}
