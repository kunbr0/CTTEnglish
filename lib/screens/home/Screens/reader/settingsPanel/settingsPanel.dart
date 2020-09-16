import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SettingsPanel extends StatefulWidget {
  final Function changeFontSize;
  double fontSize;
  SettingsPanel({Key key, this.changeFontSize, this.fontSize})
      : super(key: key);

  @override
  _SettingsPanelState createState() => _SettingsPanelState(fontSize: fontSize, changeFontSize: changeFontSize);
}

class _SettingsPanelState extends State<SettingsPanel> {
  double fontSize;
  final Function changeFontSize;
  // form values
  _SettingsPanelState({Key key, this.changeFontSize, this.fontSize});

  @override
  Widget build(BuildContext context) {
    //Settings settings = Provider.of<Settings>(context);
    return Container(
      child: Column(
        children: [
          Text('Settings'),
          RaisedButton(
            onPressed: () {
              fontSize++;
              changeFontSize(fontSize);
            },
            child: Text('Increase size'),
          ),
          Slider(
            value: fontSize,
            onChanged: (value) {
              setState(() {
                fontSize = value;
              });
              changeFontSize(value);
            },
            min: 15,
            max: 30,
            divisions: 30,
          )
        ],
      ),
    );
  }
}
