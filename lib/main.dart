import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ganit/pages/home_page.dart';

void main() async{
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Ganit",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
