import 'package:flutter/material.dart';
import 'package:usg_app_drivers/splashScreen/splash_screen.dart';
import '../global/global.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));
          },
          child:const Text("Log Out"),
        ),
      ),
    );
  }
}
