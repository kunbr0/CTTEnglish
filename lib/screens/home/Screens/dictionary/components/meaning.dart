import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../../../../../models/Sentences.dart';

class SentenceList extends StatelessWidget {
  const SentenceList({
    Key key,
    @required this.sentenceList,
  }) : super(key: key);

  final List<Sentences> sentenceList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: sentenceList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    sentenceList[index].fields.en,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Html(data: sentenceList[index].fields.vi, style: {
                    "em": Style(
                      color: Colors.blue,
                    ),
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
