import 'package:flutter/material.dart';
import 'package:cttenglish/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'settingsPanel/settingsPanel.dart';

class ReaderScreen extends StatelessWidget {
  final String data;
  ReaderScreen({Key key, @required this.data}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 380.0, horizontal: 60.0),
          child: SettingsPanel(),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Reader Screen'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/settings.svg",
              width: 25,
            ),
            onPressed: () => _showSettingsPanel(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Reader content',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              data,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
