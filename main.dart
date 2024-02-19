import 'package:flutter/material.dart';
import 'laskin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskulaskin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const LaskinRuutu(),
    );
  }
}