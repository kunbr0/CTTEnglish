import 'package:flutter/material.dart';
import 'package:cttenglish/screens/authenticate/components/text_field_container.dart';
import 'package:cttenglish/constants.dart';

import '../../../constants.dart';

class RoundedInputField extends StatelessWidget {
  final bool disabled;
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField(
      {Key key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        readOnly: disabled,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: disabled ? kDisabledColor : kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
