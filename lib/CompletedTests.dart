// import 'package:flutter/material.dart';
// import 'AnswerDetail.dart';
//
// class CompletedTests extends StatelessWidget {
//   final List<Map<String, dynamic>> completedTests;
//
//   CompletedTests({required this.completedTests});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bài đã hoàn thành'),
//         backgroundColor: Colors.indigo,
//       ),
//       body: ListView.builder(
//         itemCount: completedTests.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(completedTests[index]['subtitle']!),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AnswerDetail(
//                     totalQuestions: completedTests[index]['totalQuestions'],
//                     questionResults: completedTests[index]['questionResults'],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
