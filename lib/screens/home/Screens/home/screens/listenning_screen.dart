import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:cttenglish/constants.dart';

const testUrl = 'https://www.ielts-exam.net/practice_tests/39/';

class ListeningScreen extends StatefulWidget {
  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  bool isLoading = false;
  List sectionsList = [];

  _fetchSections() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(testUrl);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var testContainer = document.getElementsByClassName('resTop')[1];
      List sections = testContainer.getElementsByClassName('alink');
      List a = sections.map((i) => i.text).toList();
      setState(() {
        isLoading = false;
        sectionsList = sections;
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
            "Listenning",
            style: TextStyle(
                fontFamily: 'Arial', fontSize: 20, color: Colors.white70),
          ),
          leading: Icon(
            Icons.menu,
            color: Colors.white70,
          ),
        ),
        body: Text("Hello"));
  }
}
