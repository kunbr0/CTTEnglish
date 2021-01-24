import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:cttenglish/constants.dart';

import 'package:flutter_html/flutter_html.dart';

const testUrl =
    'https://www.ielts-exam.net/docs/reading/IELTS_Reading_2_Passage_1.htm';

class ReadingScreen extends StatefulWidget {
  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool isLoading = false;
  var readingContent;

  _fetchSections() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(testUrl);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var content = document.querySelector('#wideCol');
      print(content);
      setState(() {
        isLoading = false;
        readingContent = content;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          toolbarHeight: 70,
          title: Text(
            "Reading",
            style: TextStyle(
                fontFamily: 'Arial', fontSize: 20, color: Colors.white70),
          ),
          leading: Icon(
            Icons.menu,
            color: Colors.white70,
          ),
        ),
        body: Html(data: readingContent));
  }
}
