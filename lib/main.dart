import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usg_app_user/screens/main_screen.dart';
import 'package:usg_app_user/screens/rate_driver_screen.dart';
import 'package:usg_app_user/screens/search_places_screen.dart';
import 'package:usg_app_user/splashScreen/splash_screen.dart';
import 'package:usg_app_user/themeProvider/theme_provider.dart';
import 'package:usg_app_user/widgets/pay_fare_amount_dialog.dart';

import 'infoHandler/app_info.dart';

// Future<void> main() async{
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

void main() async{

  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>AppInfo(),
      child: MaterialApp(
        title: 'USG USER APP',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ); //ChangeNotifierProvider
  }
}
