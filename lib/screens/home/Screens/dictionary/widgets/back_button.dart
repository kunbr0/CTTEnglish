import 'package:cttenglish/constants.dart';
import 'package:flutter/material.dart';

class BackSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: kPrimaryColor,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (BuildContext context) => Se(),
        //     ));
        //Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Search',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white70,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
