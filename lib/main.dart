import 'package:flutter/material.dart';
import 'screen/auth/login_page.dart';


void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Air Quality Detection System',
    theme: ThemeData.dark(),
    home: const LoginPage(),
  )
  );
}

