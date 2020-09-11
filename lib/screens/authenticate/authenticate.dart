//import 'package:cttenglish/screens/authenticate/register.dart';
//import 'package:cttenglish/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cttenglish/screens/auth/Screens/Welcome/welcome_screen.dart';
import 'package:cttenglish/screens/auth/constants.dart';


// class Authenticate extends StatefulWidget {
//   @override
//   _AuthenticateState createState() => _AuthenticateState();
// }

// class _AuthenticateState extends State<Authenticate> {

//   bool showSignIn = true;
//   void toggleView(){
//     //print(showSignIn.toString());
//     setState(() => showSignIn = !showSignIn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showSignIn) {
//       return SignIn(toggleView:  toggleView);
//     } else {
//       return Register(toggleView:  toggleView);
//     }
//   }
// }

class Authenticate extends StatelessWidget {
  // This widget is the root of your application.
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
