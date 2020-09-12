import 'package:flutter/material.dart';
import 'package:cttenglish/screens/auth/Screens/Login/components/background.dart';
import 'package:cttenglish/screens/auth/Screens/Signup/signup_screen.dart';
import 'package:cttenglish/screens/auth/components/already_have_an_account_acheck.dart';
import 'package:cttenglish/screens/auth/components/rounded_button.dart';
import 'package:cttenglish/screens/auth/components/rounded_input_field.dart';
import 'package:cttenglish/screens/auth/components/rounded_password_field.dart';
import 'package:cttenglish/services/auth.dart';

import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() => email = value);
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() => password = value);
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {      
                setState(() => loading = true);
                dynamic result = await _auth
                    .signInWithEmailAndPassword(email, password);
                if (result == null) {
                  setState(() {
                    loading = false;
                    error =
                        'Could not sign in with those credentials';
                  });
                }
              }
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

