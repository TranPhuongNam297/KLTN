import 'package:flutter/material.dart';
import 'package:khoa_luan_tot_nghiep/Core%20funtion/SortQuestion.dart';
import 'package:khoa_luan_tot_nghiep/LayoutDetailHistory/MatchingDetail.dart';
import 'package:khoa_luan_tot_nghiep/LayoutDetailHistory/TrueFalseDetail.dart';
import 'package:khoa_luan_tot_nghiep/test.dart';
import 'LayoutDetailHistory/MultipleChoiceDetail.dart';
import 'LoadingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'App thi trắc nghiệm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingScreen(),
    );
  }
}
