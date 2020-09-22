import 'package:flutter/material.dart';
import 'package:html/parser.dart';


class _KWord {
  String data;
  GestureDetector word;
  double fontSize;


  _KWord(String str, {Function onTap ,double fontSize = 15}) {
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

class _KSentence {
  String _data;
  List<_KWord> listWord = new List<_KWord>();

  void _mapDataToListWord(){
//    debugPrint("Beginnnn" + this._data + "Endddddd");
    _data.split(" ").forEach((element) {
      final word = new _KWord(element, onTap: (){}, fontSize: 15);
      listWord.add(word);
    });
  }

  _KSentence();
  _KSentence.init(String data){
    this._data = data;
    _mapDataToListWord();
  }
}

class KSentences extends _KSentence{
  String _data;
  List<_KSentence> listSentence = new List<_KSentence>();

  void _mapDataToListSentence(){
    final htmlDocument = parse(_data);
    final sentences = htmlDocument.querySelectorAll("p");
    for (final sentence in sentences) {
      var stringSentence = new _KSentence.init(sentence.text);
      listSentence.add(stringSentence);
    }
    
  }

  KSentences(String data){
    this._data = data;
    _mapDataToListSentence();
  }

  List<Widget> getAllTextContent(){
    List<Widget> result = new List<Widget>(); 
    listSentence.forEach((sentence) {
      List<Widget> sente = new List<Widget>();

      sentence.listWord.forEach((word) {
        sente.add(word.word);
        
      });
      result.add(SizedBox(height: 10,));
      result.add(Wrap(children: sente));

    });
    return result;
  }


}
