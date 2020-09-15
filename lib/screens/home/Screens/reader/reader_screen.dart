import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'wordMeaning/wordMeaning.dart';
import 'settingsPanel/settingsPanel.dart';
import 'package:cttenglish/models/sentence.dart';

class ReaderScreen extends StatefulWidget {
  final String data;
  ReaderScreen({Key key, @required this.data}) : super(key: key);
  @override
  _ReaderScreenState createState() => _ReaderScreenState(data: data);
}

class _ReaderScreenState extends State<ReaderScreen> {
  final String data;
  double fontSize = 19.0;
  _ReaderScreenState({Key key, @required this.data});
  void initState() {
    super.initState();
    fontSize = fontSize ?? 0.0;
  }

  void _changeFontSize(double newFontSize) {
    setState(() {
      fontSize = newFontSize;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SettingsPanel(
                fontSize: fontSize,
                changeFontSize: _changeFontSize,
              ),
            );
          });
    }

    void _showWordMeaning(String data) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 10),
              child: WordMeaning(
                word: data,
              ),
            );
          });
    }

    void onTapWord(String word) {
      debugPrint(word);
      _showWordMeaning(word);
    }

    KSentence sentence = new KSentence(
        data: data,
        sentence: data
            .split(" ")
            .map((word) =>
                KWord(word, fontSize: fontSize, onTap: onTapWord).word)
            .toList());

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
        body: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Wrap(
              children: sentence.sentence,
            )));
  }
}
