import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  final Function(String) customFunction;

  const DropdownButtonExample({Key key, this.customFunction}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  //menu items
  static const menuItems = <String>['Google Translate', 'Kunbr0'];

  //
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
                color: Color(0xff696b9e),
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto"),
          ),
        ),
      )
      .toList();

  String value = 'Kunbr0';

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Choose dictionary: ',
              style: TextStyle(
                  color: Color(0xff696b9e),
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto"),
            ),
            trailing: DropdownButton(
              value: value,
              onChanged: ((String newValue) {
                widget.customFunction(newValue);
                setState(() {
                  value = newValue;
                });
              }),
              items: _dropDownMenuItems,
            ),
          ),
        ],
      ),
    );
  }
}
