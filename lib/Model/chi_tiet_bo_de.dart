import 'package:cloud_firestore/cloud_firestore.dart';

class chi_tiet_bo_de {
  String Id;
  String Id_bo_de;
  String Id_cau_hoi;
  String Type_cau_hoi;
  bool IsCorrect;

  chi_tiet_bo_de({
    required this.Id,
    required this.Id_bo_de,
    required this.Id_cau_hoi,
    required this.Type_cau_hoi,
    required this.IsCorrect,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Id_bo_de': Id_bo_de,
      'Id_cau_hoi': Id_cau_hoi,
      'Type_cau_hoi': Type_cau_hoi,
      'IsCorrect': IsCorrect,
    };
  }

  factory chi_tiet_bo_de.fromMap(Map<String, dynamic> map, String id) {
    return chi_tiet_bo_de(
      Id: id,
      Id_bo_de: map['Id_bo_de'],
      Id_cau_hoi: map['Id_cau_hoi'],
      Type_cau_hoi: map['Type_cau_hoi'],
      IsCorrect: map['IsCorrect'],
    );
  }

  static Future<List<chi_tiet_bo_de>> getChiTietBoDeByBoDeId(String idBoDe) async {
    List<chi_tiet_bo_de> result = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chi_tiet_bo_de')
          .where('Id_bo_de', isEqualTo: idBoDe)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Thêm type casting để đảm bảo kiểu dữ liệu
          if (data != null) {
            chi_tiet_bo_de chiTiet = chi_tiet_bo_de.fromMap(data, doc.id);
            result.add(chiTiet);
          }
        });
      }
    } catch (e) {
      print('Error getting chi_tiet_bo_de: $e');

    }

    return result;
  }
}