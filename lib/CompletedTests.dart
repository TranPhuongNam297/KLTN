import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoa_luan_tot_nghiep/CountdownTimer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Core funtion/Result.dart'; // Import the Result page

class CompletedTests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchCompletedBoDeList(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có bộ đề nào đã hoàn thành.'));
          }

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Danh sách đã hoàn thành',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var boDe = snapshot.data![index];
                    return GestureDetector(
                      onTap: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Result(
                              totalQuestions: 40, // Placeholder value; update as needed
                              correctAnswers: boDe['DiemSo'], // Placeholder value; update as needed
                              questionResults: List.generate(10, (index) => true),
                              timeSpent:  parseDuration(boDe['Time_finish']), // Placeholder value; update as needed
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.indigo[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'images/tetmass3.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Bộ đề ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Ngày tạo: ${boDe['Ngay_tao']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCompletedBoDeList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Bo_de')
        .where('Tinh_trang', isEqualTo: true)
        .get();
    // Khởi tạo biến để lưu tổng điểm
    int totalScore = 0;
    String timefinish ="";
    String Id="";
    List<Map<String, dynamic>> completedBoDeList = querySnapshot.docs
        .map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      // Lấy giá trị của trường 'DiemSo' và cộng vào tổng điểm
      if (data.containsKey('DiemSo')) {
        // Ép kiểu từ num sang int
        totalScore += (data['DiemSo'] as num).toInt(); // Sử dụng toInt() để ép kiểu
      }
      if(data.containsKey('Time_finish')){
        timefinish =(data['Time_finish']).toString();
      }
      if(data.containsKey('Id')){
        Id =(data['Id']).toString();
      }
      return data;
    })
        .toList();
    // Cập nhật biến toàn cục
    Globals.score = totalScore;
    Globals.timeDuration = parseDuration(timefinish);
    Globals.Id_Bo_de = Id;
    return completedBoDeList;
  }
}
class Globals {
  static int score = 0;
  static Duration timeDuration = Duration();
  static String Id_Bo_de = "";
}
Duration parseDuration(String durationString) {
  // Tách chuỗi dựa trên dấu hai chấm
  List<String> parts = durationString.split(':');
  // Phần giây có thể có phần thập phân
  String secondsPart = parts.last;
  // Phần giờ và phút có thể có hoặc không
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  if (parts.length == 3) {
    hours = int.parse(parts[0]);
    minutes = int.parse(parts[1]);
    seconds = int.parse(secondsPart.split('.')[0]);
  } else if (parts.length == 2) {
    minutes = int.parse(parts[0]);
    seconds = int.parse(secondsPart.split('.')[0]);
  } else if (parts.length == 1) {
    seconds = int.parse(secondsPart.split('.')[0]);
  }
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}