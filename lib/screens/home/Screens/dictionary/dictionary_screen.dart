import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import './../../../../models/Service.dart';
import './../../../../models/Sentences.dart';
import 'components/debouncer.dart';
import 'package:cttenglish/constants.dart';
import './screens/search_page.dart';

class DictionaryScreen extends StatefulWidget {
  DictionaryScreen({Key key}) : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final _debouncer = Debouncer(milliseconds: 500);
  final translator = GoogleTranslator();
  List<Sentences> sentenceList = List<Sentences>();
  var txt = TextEditingController();

  bool loading;
  String input;
  String meaning;
  String dictionary;

  @override
  void initState() {
    super.initState();
    meaning = "";
    dictionary = "Kunbr0";
    input = "";
    loading = false;
  }

  void changeDictionary(String string) {
    setState(() {
      dictionary = string;
      txt.text = "";
      loading = false;
      if (dictionary == "Google Translate") {
        meaning = "";
      } else if (dictionary == "Kunbr0") {
        sentenceList = List();
      }
    });
  }

  void setStateWithDictionary(String string) {
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

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 24);

  final primary = kPrimaryColor;
  final secondary = Color(0xfff29a94);

  @override
  Widget build(BuildContext context) {
    return SearchPage();
  }
}
