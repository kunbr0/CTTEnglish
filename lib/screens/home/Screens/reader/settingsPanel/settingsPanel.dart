import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

//import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SettingsPanel extends StatefulWidget {
  final Function changeFontSize;
  final Function changeBackgroundColor;
  double fontSize;
  SettingsPanel({Key key, this.changeFontSize, this.fontSize, this.changeBackgroundColor})
      : super(key: key);

  @override
  _SettingsPanelState createState() => _SettingsPanelState(fontSize: fontSize, changeFontSize: changeFontSize, changeBackgroundColor: changeBackgroundColor);
}

class _SettingsPanelState extends State<SettingsPanel> {
  double fontSize;
  final Function changeFontSize;
  final Function changeBackgroundColor;
  // form values
  _SettingsPanelState({Key key, this.changeFontSize, this.fontSize, this.changeBackgroundColor});

  @override
  Widget build(BuildContext context) {
    //Settings settings = Provider.of<Settings>(context);
    return Container(
      child: Column(
        children: [
          Text('Background Color'),
          
          Expanded(child: 
            MaterialColorPicker(
              onColorChange: (Color color) {
                  // Handle color changes
                  changeBackgroundColor(color);
              },
              onMainColorChange: (ColorSwatch color) {
                  // Handle main color changes
                  
              },
              selectedColor: Colors.red
            ),
          ),
          Text('Font size'),
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
