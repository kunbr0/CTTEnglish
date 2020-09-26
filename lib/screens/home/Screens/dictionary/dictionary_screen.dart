import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import './../../../../models/Service.dart';
import './../../../../models/Sentences.dart';
import 'components/debouncer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'components/drop_down.dart';
import 'package:cttenglish/constants.dart';
import 'package:cttenglish/shared/beautiful_appbar.dart';

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
  var meaning;
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
      TextStyle(color: Colors.black, fontSize: 18);

  final primary = kPrimaryColor;
  final secondary = Color(0xfff29a94);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              buildMeaningList(context),
              BeautifulAppBar(),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 125,
                    ),
                    DropdownButtonExample(
                      customFunction: changeDictionary,
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 133,
                    ),
                    loading
                        ? LinearProgressIndicator(
                            backgroundColor: primary,
                          )
                        : Container(
                            height: 0,
                          ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          controller: txt,
                          onChanged: (string) {
                            setStateWithDictionary(string);
                          },
                          cursorColor: Theme.of(context).primaryColor,
                          style: dropdownMenuItem,
                          decoration: InputDecoration(
                              hintText: "Enter Text",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                elevation: 0.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMeaningList(BuildContext context) {
    if (dictionary == "Kunbr0") {
      return Container(
          padding: EdgeInsets.only(top: 170),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: ListView.builder(
              itemCount: sentenceList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildKunbr0Item(context, index);
              }));
    } else if (dictionary == "Google Translate") {
      return Container(
          padding: EdgeInsets.only(top: 170),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      meaning,
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ));
                ;
              }));
    } else
      return null;
  }

  Widget buildKunbr0Item(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      // height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   // schoolLists[index]['name'],
                //   sentenceList[index].fields.en,
                //   style: TextStyle(
                //       color: primary,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18),
                // ),
                Wrap(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Html(data: sentenceList[index].fields.en, style: {
                      "em": Style(
                          color: Colors.red,
                          letterSpacing: .3,
                          fontSize: FontSize.medium),
                    }),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Wrap(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Html(data: sentenceList[index].fields.vi, style: {
                      "em": Style(
                          color: Colors.red,
                          letterSpacing: .3,
                          fontSize: FontSize.medium),
                    }),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
