import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import './WordMeaning.dart';

class WordMeaningView extends StatefulWidget {
  final String word;
  WordMeaningView({Key key, this.word}) : super(key: key);

  @override
  _WordMeaningViewState createState() => _WordMeaningViewState(word);
}

class _WordMeaningViewState extends State<WordMeaningView> {
  final String data;
  _WordMeaningViewState(this.data);

  final wordMeaningStream = StreamController<List<WordMeaning>>();

  void getWordMeaning() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = 'https://api.kunbr0.com/en-vi.php?kInput=$data';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var sentences = jsonResponse['sentences'].map<WordMeaning>((sente) {
        return WordMeaning(
          id: int.parse(sente['_id']),
          enMeaning: sente['fields']['en'],
          viMeaning: sente['fields']['vi'],
        );
      }).toList();

      print('Get wordmeaning successfully .');
      wordMeaningStream.sink.add(sentences);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      wordMeaningStream.sink
          .addError('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    getWordMeaning();
  }

  @override
  void dispose() {
    super.dispose();
    wordMeaningStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: wordMeaningStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          }
          return SingleChildScrollView(
            child: ListView.builder(
                // crossAxisAlignment: CrossAxisAlignment.start,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  // snapshot.data.map<Widget>((elm) {
                  return Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                          // border: Border.all(width: 1, color: Colors.blue[200])
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2.0, color: Colors.amber),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(Icons.star),
                                    Text("English: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                  ],
                                ),
                                Html(
                                    data: snapshot.data[index].viMeaning,
                                    style: {
                                      "*": Style(fontSize: FontSize.large),
                                      "em": Style(
                                          fontSize: FontSize.large,
                                          fontStyle: FontStyle.italic),
                                    }),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(Icons.star),
                                    Text("Vietnamese: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data[index].enMeaning,
                                      style: TextStyle(fontSize: 15.75)),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ));
                }
                // children: ).toList(),
                ),
          );
        });
  }
}
