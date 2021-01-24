import 'package:cttenglish/screens/authenticate/Screens/Signup/components/or_divider.dart';
import 'package:cttenglish/screens/authenticate/Screens/Signup/components/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:cttenglish/screens/authenticate/Screens/Login/components/background.dart';
import 'package:cttenglish/screens/authenticate/Screens/Login/login_screen.dart';
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
  String repassword = '';

  Function getPressAction() {
    if (loading) {
      return () {};
    } else {
      return () async {
        setState(() => loading = true);
        if(password.length < 6){
          _showMyDialog("Error", "Password length must be greater than 6 characters !");
          setState(() {
            loading = false;
          });
          return;
        }
        else if(password != repassword){
          _showMyDialog("Error", "Retype password is not same !");
          setState(() {
            loading = false;
          });
          return;
        }
        

        dynamic result =
          await _auth.signUpWithEmailAndPassword(email, password);
        if(result["Status"] == 0){
          _showMyDialog("Signup failed", "Please check your credential again!");
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
                "SIGN UP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
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
              RoundedPasswordField(
                onChanged: (value) {
                  setState(() => repassword = value);
                },
                disabled: loading,
                placeholder: "Retype password",
              ),
              RoundedButton(
                text: loading ? "Loading..." : "Sign Up",
                press: getPressAction(),
                color: loading ? kDisabledColor : kPrimaryColor,
              ),
              

              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              )
            ],
          ),
      )
    );
  }
}
