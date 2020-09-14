import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:async';
import '../../../../models/Sentences.dart';
import '../../../../models/Service.dart';
import 'package:flutter_html/style.dart';
import 'package:http/http.dart' as http;

class DictionaryScreen extends StatefulWidget {
  DictionaryScreen() : super();

  final String title = "Translator";

  @override
  DictionaryScreenState createState() => DictionaryScreenState();
}

//debound effect when
class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class DictionaryScreenState extends State<DictionaryScreen> {
  // https://jsonplaceholder.typicode.com/users

  final _debouncer = Debouncer(milliseconds: 500);

  List<Sentences> sentenceList = List<Sentences>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter a sentence',
              ),
              onChanged: (string) {
                _debouncer.run(() async {
                  sentenceList = await Services.getSentences(string);
                  setState(() {});
                });
              },
            ),
          ),
          Expanded(
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
//              color: Colors.white,
                          ),
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
