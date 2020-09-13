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
import 'package:flutter_svg/flutter_svg.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // This widget is the root of your application.

  // void initState() {
  //   loadPictures();
  //   super.initState();
  // }

  Future<bool> loadPictures() async {
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/login.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/signup.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/icons/chat.svg'),
        null);
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      builder: (context, projectSnap) {
        if (projectSnap.data == true)
          return  MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Flutter Auth',
                    theme: ThemeData(
                      primaryColor: kPrimaryColor,
                      scaffoldBackgroundColor: Colors.white,
                    ),
                    home: WelcomeScreen(),
                  );
        else {
          return Text("Loading...");
        }
      },
      future: loadPictures(),
    );
  }
}


