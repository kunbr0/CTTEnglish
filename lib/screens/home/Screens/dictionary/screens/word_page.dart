import 'dart:ui';

import 'package:cttenglish/constants.dart';

import '../constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/definition_list_view.dart';
import '../services/SpeakerHelper.dart';

class WordPage extends StatefulWidget {
  final wordDetails;
  final word;

  WordPage({this.wordDetails, this.word});

  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  bool saved = false;

  List<Column> definitions() {
    List<Column> definitions = [];
    for (var word in widget.wordDetails) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.word.toString().toLowerCase(),
                        style: cWordStyle,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            iconSize: 40,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: saved
                                ? Icon(Icons.star)
                                : Icon(Icons.star_border),
                            iconSize: 40,
                            onPressed: () {
                              setState(() {
                                saved = !saved;
                              });
                            },
                          ),
                        ],
                      )
                    ],
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
                      widget.wordDetails.length.toString(),
                      style: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.mic),
                      iconSize: 35,
                      onPressed: () async {
                        await SpeakerHelper.speak(this.widget.word);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: DefinitionsListView(wordDetails: widget.wordDetails),
                ),
              ],
            ),
          ),
        ));
  }
}
