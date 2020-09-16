import 'package:flutter/material.dart';

class KWord {
  String data;
  GestureDetector word;
  double fontSize;


  KWord(String str, {Function onTap ,double fontSize = 15}) {
    this.data = str;
    this.fontSize = fontSize;
    this.word = GestureDetector(
      onTap: ()=>onTap(str),
      child: Container(
        margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Text(
          str,
          style: TextStyle(
            fontSize: fontSize,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}

class KSentence {
  String data;
  List sentence;

  KSentence({this.sentence, this.data});
}
