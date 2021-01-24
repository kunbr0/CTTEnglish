import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as Dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'test_detail_screen.dart';

const testUrl = 'https://www.ielts-exam.net/practice_tests';

class IeltsHome extends StatefulWidget {
  @override
  _IeltsHomeState createState() => _IeltsHomeState();
}

class _IeltsHomeState extends State<IeltsHome> {
  List testTitles = [];
  List testSubtitles = [];
  bool isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(testUrl);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var testContainer = document.getElementsByClassName('resTop')[1];
      List titles = testContainer.getElementsByClassName('xlink');
      List subTitles = testContainer
          .getElementsByClassName('d')
          .map((item) => item.getElementsByTagName('p')[0])
          .toList();

      setState(() {
        isLoading = false;
        testTitles = titles;
        testSubtitles = subTitles;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: ListView.builder(
          itemCount: testTitles.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  color: Colors.white),
              child: new Material(
                child: new InkWell(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TestDetailScreen()))
                        .then((value) => setState(() {}));
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
                          Text(testTitles[index].attributes["title"],
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
          }),
    );
  }
}