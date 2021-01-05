import 'dart:ui';

import 'package:cttenglish/constants.dart';
import 'package:translator/translator.dart';

import '../constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/definition_list_view.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordPage extends StatelessWidget {
  final wordDetails;
  final word;
  FlutterTts tts = new FlutterTts();

  WordPage({this.wordDetails, this.word});

  Future _speak() async {
    await tts.setSpeechRate(.8);
    await tts.setPitch(1);
    await tts.setLanguage("en-US");

    if ("_newVoiceText" != null) {
      if ("_newVoiceText".isNotEmpty) {
        await tts.awaitSpeakCompletion(true);
        await tts.speak(word);
      }
    }
  }

  List<Column> definitions() {
    List<Column> definitions = [];
    for (var word in wordDetails) {
      String singleDefinition = word['def'];

      var oneDefinition = Column(
        children: <Widget>[
          Text(
            singleDefinition,
            style: cDefinitionTextStyle,
          ),
          Divider(),
        ],
      );
      definitions.add(oneDefinition);
    }
    return definitions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: kPrimaryColor,
            title: Text(
              "Search Result",
              style: TextStyle(color: Colors.white70),
            )),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    word.toString().toLowerCase(),
                    // wordDetails['word'],
                    style: cWordStyle,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Text(
                      'DEFINITIONS',
                      style: cCategoryTextStyle,
                    ),
                    SizedBox(width: 3.0),
                    Text(
                      wordDetails.length.toString(),
                      style: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.mic),
                      iconSize: 35,
                      onPressed: () async {
                        await _speak();
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: DefinitionsListView(wordDetails: wordDetails),
                ),
              ],
            ),
          ),
        ));
  }
}
