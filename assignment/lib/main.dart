import 'package:flutter/material.dart';
import 'customer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomerForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}
