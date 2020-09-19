import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './WordMeaning.dart';
import 'dart:convert' as convert;

class WordMeaningView extends StatefulWidget {
  final String word;
  WordMeaningView({Key key, this.word}) : super(key : key);

  @override
  _WordMeaningViewState createState() => _WordMeaningViewState(word);
}

class _WordMeaningViewState extends State<WordMeaningView> {
  final String data;
  _WordMeaningViewState(this.data);

  final wordMeaningStream = StreamController <List<WordMeaning>>();

  void getWordMeaning() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = 'https://api.kunbr0.com/en-vi.php?kInput=$data';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var sentences = jsonResponse['sentences'].map<WordMeaning>((sente){
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
      wordMeaningStream.sink.addError('Request failed with status: ${response.statusCode}.');
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
        if(!snapshot.hasData){
          return Text('Loading...');
        }
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data.map<Widget>((elm){
              return Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.blue[200])),
                child : Column(
                  children: [
                    Text(elm.viMeaning),
                    Text(elm.enMeaning),
                  ],
                )
              );
            }).toList(),
          ),
        );
      });
  }
}

