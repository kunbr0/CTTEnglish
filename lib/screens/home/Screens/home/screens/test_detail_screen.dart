import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:cttenglish/constants.dart';

import 'reading_screen.dart';
import 'writing_screen.dart';
import 'speaking_screen.dart';
import 'listenning_screen.dart';

const testUrl = 'https://www.ielts-exam.net/practice_tests/39/';

class TestDetailScreen extends StatefulWidget {
  @override
  _TestDetailScreenState createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
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
            "Ielts Test",
            style: TextStyle(
                fontFamily: 'Arial', fontSize: 20, color: Colors.white70),
          ),
          leading: Icon(
            Icons.menu,
            color: Colors.white70,
          ),
        ),
        body: ListView.builder(
            itemCount: sectionsList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    color: Colors.white),
                child: new Material(
                  child: new InkWell(
                    onTap: () {
                      String category = sectionsList[index].text.split(' ')[1];

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  category == "Reading"
                                      ? ReadingScreen()
                                      : category == "Listening"
                                          ? ListeningScreen()
                                          : category == "Speaking"
                                              ? SpeakingScreen()
                                              : WritingScreen()));
                      // ParapharaseExamplePage(
                      //     phrase: phrase,
                      //     examplesList: examplesList)))
                    },
                    child: new Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                            ),
                            SizedBox(height: 10),
                            Text(sectionsList[index].text,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ]),
                    ),
                  ),
                  color: Colors.transparent,
                ),
              );
            }));
  }
}
