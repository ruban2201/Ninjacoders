import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usg_app_user/Assistants/assistant_methods.dart';
import 'package:usg_app_user/global/global.dart';
import 'package:usg_app_user/screens/login_screen.dart';
import 'package:usg_app_user/screens/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(Duration(seconds: 3), () async {
      if(await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null ? AssistantMethods
            .readCurrentOnlineUserInfo() : null;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
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
          'USG APP',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }
}
