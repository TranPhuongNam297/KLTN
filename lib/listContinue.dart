import 'package:flutter/material.dart';
import 'ActivityItemMain.dart';

class listContinue extends StatelessWidget {
  final List<Map<String, String>> data = [
    {'subtitle': 'Test 1'},
    {'subtitle': 'Test 2'},
    {'subtitle': 'Test 3'},
    {'subtitle': 'Test 4'},
    {'subtitle': 'Test 5'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(
            'Danh sách bài tập',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Tiếp tục làm bài',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ActivityItemMain(
                    subtitle: data[index]['subtitle']!,
                  );
                },
              ),
            ),
          ],
        ));
  }
}
