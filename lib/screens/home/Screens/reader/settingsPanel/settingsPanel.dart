import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import './settings.dart';

class SettingsPanel extends StatefulWidget {
  @override
  _SettingsPanelState createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final _formKey = GlobalKey<FormState>();

  // form values


  @override
  Widget build(BuildContext context) {
    //Settings settings = Provider.of<Settings>(context);
    return StreamBuilder<Settings>(
        //stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
      if (snapshot.hasData) {
        Settings settingsData = snapshot.data;
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Update your brew settings.',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              Text(settingsData.fontSize.toString()),
              SizedBox(height: 10.0),
              SizedBox(height: 10.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    debugPrint('Save settings');
                  }),
            ],
          ),
        );
      } else {
        return Text('Loading settings...');
      }
    });
  }
}
