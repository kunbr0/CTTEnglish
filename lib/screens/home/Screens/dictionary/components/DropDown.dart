import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  final Function(String) customFunction;

  const DropdownButtonExample({Key key, this.customFunction}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  //menu items
  static const menuItems = <String>[
    'Cambridge',
    'Oxford',
    'Google Translate',
    'Kunbr0'
  ];

  //
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String value = 'Cambridge';

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Choose dictionary: '),
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
    );
  }
}
