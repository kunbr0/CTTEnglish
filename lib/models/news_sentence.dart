import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class _KWord {
  String data;
  GestureDetector word;
  static double fontSize = 18;
  static Function onTapWord = (){};
  _KWord(String str) {
    this.data = str;
    this.word = GestureDetector(
      onTap: () => onTapWord(data),
      child: Container(
        margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Text(
          str,
          style: TextStyle(
            fontSize: _KWord.fontSize,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}

class _KSentence {
  String _data;
  List<_KWord> listWord = new List<_KWord>();

  void _mapDataToListWord() {
//    debugPrint("Beginnnn" + this._data + "Endddddd");
    _data.split(" ").forEach((element) {
      final word = new _KWord(element);
      listWord.add(word);
    });
  }

  _KSentence();
  _KSentence.init(String data) {
    this._data = data;
    _mapDataToListWord();
  }
}

class KSentences extends _KSentence {
  String _data;
  List<_KSentence> listSentence = new List<_KSentence>();
  static Function callback;

  void _mapDataToListSentence() {
    final htmlDocument = parse(_data);
    final sentences = htmlDocument.querySelectorAll("p");
    for (final sentence in sentences) {
      _KSentence stringSentence = new _KSentence.init(sentence.text);
      listSentence.add(stringSentence);
    }
  }

  void onChangeFontSize(double newSize) {
    _KWord.fontSize = newSize;
  }

  KSentences();

  onCallback(Function f) {
    KSentences.callback = f;
    _KWord.onTapWord = f;
  }

  KSentences.initData(String data){
    this._data = data;
    _mapDataToListSentence();
  }

  



  List<Widget> getAllTextContent() {
    List<Widget> result = new List<Widget>();

    listSentence.forEach((sentence) {
      List<Widget> sente = new List<Widget>();

      sentence.listWord.forEach((word) {
        sente.add(word.word);
      });
      result.add(SizedBox(
        height: 20,
      ));
      result.add(Wrap(children: sente));
    });
    return result;
  }
}
