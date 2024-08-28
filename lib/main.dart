import 'package:flutter/material.dart';
import 'package:movieapi/Des/Deshome.dart';
import 'package:movieapi/Homepage.dart';
import 'package:movieapi/Resposive.dart';
import 'package:movieapi/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Api',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: ResponsiveLayout(
            mobileScaffold: HomePage(),
            desktopScaffold: DesHomePage(),
            tabletScaffold: DesHomePage()));
  }
}
