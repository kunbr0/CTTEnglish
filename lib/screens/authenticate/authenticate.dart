import 'package:flutter/material.dart';
import 'package:cttenglish/screens/authenticate/Screens/Welcome/welcome_screen.dart';
import 'package:cttenglish/constants.dart';

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
