import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:cttenglish/constants.dart';

import 'package:flutter_html/flutter_html.dart';

class SectionDetailScreen extends StatefulWidget {
  final sectionDetailUrl;
  final String sectionCategory;

  @override
  _SectionDetailScreenState createState() => _SectionDetailScreenState();

  SectionDetailScreen({Key key, this.sectionDetailUrl, this.sectionCategory})
      : super(key: key);
}

class _SectionDetailScreenState extends State<SectionDetailScreen> {
  bool isLoading = false;
  var sectionContent = "";
  var readingQuestions = "";

  _fetchSections() async {
    setState(() {
      isLoading = true;
    });

    final response1 = await http.get(widget.sectionDetailUrl);
    var document1, questions;
    if (response1.statusCode == 200) {
      document1 = parse(response1.body);
      questions = document1.querySelector('#main');
      setState(() {
        readingQuestions = questions.outerHtml;
      });
    } else {
      throw Exception('Failed to load photos');
    }

    if (questions == null) return;
    var paragraphTag = questions.querySelector(".g-ul-icons");
    var paragraphLink =
        paragraphTag.querySelector(".reading-link").attributes["href"];

    final response2 = await http.get(paragraphLink);
    if (response2.statusCode == 200) {
      var document2 = parse(response2.body);
      var content = document2.querySelector('#wideCol');
      setState(() {
        isLoading = false;
        sectionContent = content.outerHtml;
      });
    } else {
      throw Exception('Failed to load photos');
    }
    // print(questions);
  }

  @override
  void initState() {
    super.initState();
    _fetchSections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          toolbarHeight: 70,
          title: Text(
            widget.sectionCategory + " Screen",
            style: TextStyle(
                fontFamily: 'Arial', fontSize: 20, color: Colors.white70),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white70,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:
            // isLoading
            // ? Container(height: 0)
            // :
            SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              sectionContent != ""
                  ? Html(data: sectionContent)
                  : Container(
                      height: 0,
                    ),
              Html(data: readingQuestions)
            ],
          ),
        )));
  }
}
