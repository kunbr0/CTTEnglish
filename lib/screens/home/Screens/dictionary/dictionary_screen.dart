import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import '../../../../models/Service.dart';
import './components/SentenceList.dart';
import '../../../../models/Sentences.dart';
import './components/Debouncer.dart';
import './components/DropDown.dart';

class DictionaryScreen extends StatefulWidget {
  DictionaryScreen() : super();

  final String title = "Dictionary";

  @override
  DictionaryScreenState createState() => DictionaryScreenState();
}

class DictionaryScreenState extends State<DictionaryScreen> {
  // https://jsonplaceholder.typicode.com/users

  final _debouncer = Debouncer(milliseconds: 500);

  final translator = GoogleTranslator();

  List<Sentences> sentenceList = List<Sentences>();

  var txt = TextEditingController();

  bool loading = false;
  String input = "";
  var meaning;
  String dictionary = "";

  @override
  void initState() {
    super.initState();
    meaning = "";
  }

  void changeDictionary(String string) {
    setState(() {
      dictionary = string;
      txt.text = "";
      meaning = "";
      loading = false;
    });
  }

  Widget buildDictionary() {
    if (dictionary == "Kunbr0") {
      print(input);
      return SentenceList(sentenceList: sentenceList);
    }
    if (dictionary == "Google Translate")
      return Text(meaning);
    else
      return Text("Not found");
  }

  void setStateWithDictionary(String string) {
    print(string);
    setState(() {
      loading = true;
      input = string;
    });
    _debouncer.run(() async {
      //Kunbr0 api
      if (dictionary == "Kunbr0")
        sentenceList = await Services.getSentences(string);

      //google api
      if (dictionary == "Google Translate") {
        if (input != "") {
          Translation result =
              await translator.translate(input, from: 'en', to: 'vi');
          setState(() {
            meaning = result.toString();
          });
        } else {
          setState(() {
            meaning = "";
          });
        }
      }
      setState(() {
        loading = false;
      });
    });
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
          DropdownButtonExample(
            customFunction: changeDictionary,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: txt,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter text',
              ),
              onChanged: (string) {
                setStateWithDictionary(string);
              },
            ),
          ),
          loading
              ? LinearProgressIndicator()
              : Container(
                  height: 0,
                ),
          buildDictionary()
        ],
      ),
    );
  }
}
