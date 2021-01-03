import 'package:flutter/material.dart';
import 'package:cttenglish/screens/authenticate/components/text_field_container.dart';
import 'package:cttenglish/constants.dart';

import '../../../constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool disabled;
  const RoundedPasswordField({Key key, this.onChanged, this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        readOnly: disabled,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: disabled ? kDisabledColor : kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: disabled ? kDisabledColor : kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
