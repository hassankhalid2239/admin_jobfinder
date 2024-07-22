import 'package:admin_jobfinder/Login&Signup/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_page.dart';

class SplashService {
  final user = FirebaseAuth.instance.currentUser;
  void isLogin(BuildContext context) {
    if (user != null) {
      Future.delayed(const Duration(seconds: 1)).then((value) => {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainPage()))
          });
    } else {
      Future.delayed(const Duration(seconds: 1)).then((value) => {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()))
          });
    }
  }
}
