// import 'package:flutter/material.dart';
// import 'package:cttenglish/screens/authenticate/register.dart';
// import 'package:cttenglish/screens/authenticate/sign_in.dart';

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

import 'package:flutter/material.dart';
import 'package:cttenglish/screens/authenticate/Screens/Welcome/welcome_screen.dart';
import 'package:cttenglish/constants.dart';

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
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


