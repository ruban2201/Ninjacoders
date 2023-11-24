import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usg_app_user/Assistants/assistant_methods.dart';
import 'package:usg_app_user/global/global.dart';
import 'package:usg_app_user/screens/login_screen.dart';
import 'package:usg_app_user/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(const Duration(seconds: 3), () async {
      if(firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null ? AssistantMethods
            .readCurrentOnlineUserInfo() : null;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const MainScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'USG APP HUHU',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }
}
