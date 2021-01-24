import 'package:flutter/material.dart';
import 'package:cttenglish/screens/authenticate/Screens/Login/components/background.dart';
import 'package:cttenglish/screens/authenticate/Screens/Signup/signup_screen.dart';
import 'package:cttenglish/screens/authenticate/components/already_have_an_account_acheck.dart';
import 'package:cttenglish/screens/authenticate/components/rounded_button.dart';
import 'package:cttenglish/screens/authenticate/components/rounded_input_field.dart';
import 'package:cttenglish/screens/authenticate/components/rounded_password_field.dart';
import 'package:cttenglish/services/auth.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../constants.dart';

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

  Function getPressAction() {
    if (loading) {
      return () {};
    } else {
      return () async {
        setState(() => loading = true);
        dynamic result =
            await _auth.signInWithEmailAndPassword(email, password);
        if(result["Status"] == 0){
          _showMyDialog("Login failed", "Please check your username or password!");
        }
        debugPrint(result["Data"].toString());
        
        setState(() {
          loading = false;
        });
        
      };
    }
  }

  Future<void> _showMyDialog(String title,String errorDetails) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(errorDetails)
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

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
                disabled: loading,
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  setState(() => password = value);
                },
                disabled: loading,
              ),
              RoundedButton(
                text: loading ? "Loading..." : "Login",
                press: getPressAction(),
                color: loading ? kDisabledColor : kPrimaryColor,
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
      )
    );
  }
}
