import 'package:flutter/material.dart';
import 'ActivityItemMain.dart';

class Home extends StatelessWidget {
  final List<Map<String, String>> data = [
    {'subtitle': 'Rất là dài '},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Những hoạt động gần đây',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.5),
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(height: 30,),
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
      ),
    );
  }
}
