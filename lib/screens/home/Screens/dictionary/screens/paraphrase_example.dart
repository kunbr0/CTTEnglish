import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:cttenglish/constants.dart';
import '../services/SpeakerHelper.dart';

class ParapharaseExamplePage extends StatelessWidget {
  final examplesList;
  final String phrase;
  List<Map<String, dynamic>> parseList = List<Map<String, dynamic>>();

  ParapharaseExamplePage({this.phrase, this.examplesList}) {
    parseList = examplesList.cast<Map<String, dynamic>>();
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: kPrimaryColor,
            title: Text(
              "Paraphrase example",
              style: TextStyle(color: Colors.white70),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(this.phrase,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 45)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: parseList
                      .map((e) => Card(
                            shadowColor: kPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          (parseList.indexOf(e) + 1)
                                                  .toString() +
                                              ".",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 22)),
                                      IconButton(
                                          icon: Icon(FontAwesome.volume_up),
                                          onPressed: () {
                                            SpeakerHelper.speak(
                                                removeAllHtmlTags(
                                                    e["fields"]["en"]));
                                          }),
                                    ],
                                  ),
                                  Html(data: "-" + e["fields"]["en"], style: {
                                    "*": Style(fontSize: FontSize(16)),
                                    "em": Style(
                                        fontSize: FontSize(17),
                                        color: kPrimaryColor)
                                  }),
                                  Html(
                                      data: "<b>Meaning:</b> " +
                                          e["fields"]["vi"],
                                      style: {
                                        "*": Style(fontSize: FontSize(16)),
                                        "em": Style(
                                            fontSize: FontSize(17),
                                            color: kPrimaryColor),
                                        "b": Style(
                                            fontSize: FontSize(17),
                                            color: Colors.black)
                                      })
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
