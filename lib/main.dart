import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xff075E54),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25d366)),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
