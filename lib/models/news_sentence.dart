import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

// class _KWord {
//   String data;
//   GestureDetector word;
//   static double fontSize = 18;
//   static Function onTapWord = () {};

//   _KWord(String str) {
//     this.data = str;
//     this.word = GestureDetector(
//       onTap: () => onTapWord(data),
//       child: Container(
//         margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
//         child: Text(
//           str,
//           style: TextStyle(
//             fontSize: _KWord.fontSize,
//           ),
//           overflow: TextOverflow.fade,
//         ),
//       ),
//     );
//   }
// }

class _KSentence {
    String _data;
    RichText kData;
    static double fontSize = 18;
    static Function onTapWord = () {};

    void _mapDataToListWord() {
        List<TextSpan> listWord = <TextSpan>[];
        _data.split(" ").forEach((element) {
        final TextSpan word = new TextSpan(
            text: element.toString() + " ",
            recognizer: TapGestureRecognizer()..onTap = () => onTapWord(element.toString())
        );
        listWord.add(word);
        });

        kData = RichText(text: TextSpan(
            style: TextStyle(fontSize: fontSize, color: Colors.black),
            children: listWord
        ));
    }

    _KSentence();
    _KSentence.init(String data) {
        this._data = data;
        _mapDataToListWord();
    }
}

class KSentences {
  String _data;
  List<_KSentence> listSentence = <_KSentence>[];
  static Function onTranslateButtonPressed = () {};

  void _mapDataToListSentence() {
    final htmlDocument = parse(_data);
    final sentences = htmlDocument.querySelectorAll("p");

    for (final sentence in sentences) {
      _KSentence stringSentence = new _KSentence.init(sentence.text);
      listSentence.add(stringSentence);
    }
  }

  void onChangeFontSize(double newSize) {
    _KSentence.fontSize = newSize;
  }

  KSentences();

  // Init CallBack Functions
  onCallback(Function onTapWord, Function onTranslateButtonPressed) {
    _KSentence.onTapWord = onTapWord;
    KSentences.onTranslateButtonPressed = onTranslateButtonPressed;
  }

  KSentences.initData(String data) {
    this._data = data;
    _mapDataToListSentence();
  }

  List<Widget> getAllTextContent() {
    List<Widget> result = <Widget>[];

    listSentence.forEach((sentence) {
      
      result.add(SizedBox(
        height: 20,
      ));
      result.add(sentence.kData);
      result.add(FlatButton.icon(
          onPressed: () => onTranslateButtonPressed(sentence._data),
          icon: Icon(Icons.search),
          label: Text(
            "Translate this paragraph",
            style: TextStyle(fontSize: 18),
          )));
    });
    return result;
  }
}
