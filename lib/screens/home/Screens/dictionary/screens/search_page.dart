import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/NetworkHelper.dart';
import '../screens/word_page.dart';
import '../constant.dart';
import '../widgets/not_found.dart';
import 'package:cttenglish/constants.dart';
import './../../../../../models/Service.dart';

enum DictionaryCategories { EnEn, EnVi, TranslateParagraph }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool loading = false;
  bool noData = false;
  DictionaryCategories _currentCategory = DictionaryCategories.EnEn;
  final translator = GoogleTranslator();
  List<Map> wordDetails = [];
  String meaning = "";

  List<String> suggestionList = [];
  TextEditingController txt = TextEditingController();

  String generateTitle(DictionaryCategories cate) {
    String result = "";
    switch (cate) {
      case DictionaryCategories.EnEn:
        result = "English-English";
        break;
      case DictionaryCategories.EnVi:
        result = "English-Vietnamese";
        break;
      case DictionaryCategories.TranslateParagraph:
        result = "Translate Paragraph";
        break;
      default:
        break;
    }
    return result;
  }

  Future generateWordDetails(String word) async {
    wordDetails.clear();
    Translation result = await translator.translate(word, from: 'en', to: 'vi');
    var eg;
    try {
      var sentences = await Services.getSentences(word);
      eg = (sentences[1].fields.toJson());
    } catch (e) {
      // throw Exception(e.toString());
      print('Timeout');
    }
    setState(() {
      wordDetails.add({
        "type": "nouns",
        "def": result.toString(),
        "eg": 'Eg: ${eg["en"]} (${eg["vi"]})',
        "image_url": null,
        "emoji": null
      });
    });
  }

  void searchWord(String word) async {
    NetworkHelper networkHelper = NetworkHelper();
    switch (_currentCategory) {
      case DictionaryCategories.EnEn:
        wordDetails = await networkHelper.getData(word);
        break;
      case DictionaryCategories.EnVi:
        await generateWordDetails(word);
        break;
      default:
        break;
    }

    setState(() {
      loading = false;
    });

    if (wordDetails == null) {
      setState(() {
        suggestionList.clear();
        noData = true;
      });
    } else {
      noData = false;
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      WordPage(wordDetails: wordDetails, word: word)))
          .then((value) => setState(() {}));
    }
  }

  void generateSuggestion(String word) async {
    suggestionList.clear();
    int suggestionListLength = 5;

    if (word != "" && word != null) {
      for (int i = 0; i < all.length; i++) {
        String suggestion = all[i];

        if (suggestionListLength >= 0 && suggestion.startsWith(word)) {
          if (!suggestionList.contains(suggestion)) {
            suggestionList.add(suggestion);
            suggestionListLength--;
          }
        }
      }
    }

    setState(() {});
  }

  void translateParagraph(paragragh, bool isEnEn) async {
    Translation result;
    if (isEnEn) {
      result = await translator.translate(paragragh, from: 'en', to: 'vi');
    } else {
      print("Hello");
      result = await translator.translate(paragragh, from: 'vi', to: 'en');
    }
    setState(() {
      meaning = result.toString();
    });
    print(result.toString());
  }

  Widget buildSuggestions() {
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (BuildContext context, int i) {
          final String suggestion = suggestionList[i];
          final tailPart = suggestion.split(txt.text)[1];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: RichText(
                text: TextSpan(
                    text: txt.text,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    children: [
                      TextSpan(
                          text: tailPart,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ]),
              ),
              onTap: () {
                txt.text = suggestion;
                suggestionList.clear();
                setState(() {});
              },
            ),
          );
        });
  }

  Widget _buildPopupDialog(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        title: Center(
            child: Text('Dictionary Settings',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 200,
                child: Column(
                    children: DictionaryCategories.values
                        .map((value) => Card(
                              child: (ListTile(
                                title: Text(generateTitle(value),
                                    style: TextStyle(fontSize: 14)),
                                trailing: Radio(
                                  value: value,
                                  groupValue: _currentCategory,
                                  onChanged: (DictionaryCategories cate) {
                                    setState(() {
                                      txt.text = "";
                                      _currentCategory = cate;
                                    });
                                  },
                                ),
                              )),
                            ))
                        .toList()));
          },
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
              setState(() {});
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        toolbarHeight: 70,
        title: Text(
          "Dictionary Screen",
          style: TextStyle(
              fontFamily: 'Arial', fontSize: 20, color: Colors.white70),
        ),
        leading: Icon(
          Icons.menu,
          color: Colors.white70,
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: IconButton(
                    icon: Icon(Icons.settings),
                    iconSize: 35,
                    color: Colors.white70,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => _buildPopupDialog(context),
                      );
                    }),
              ))
        ],
      ),
      body: _currentCategory != DictionaryCategories.TranslateParagraph
          ? ModalProgressHUD(
              inAsyncCall: loading,
              color: Colors.black26,
              progressIndicator: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                backgroundColor: Colors.black12,
                strokeWidth: 5,
              ),
              opacity: 0.2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dictionary",
                      style: cTitleStyle,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: txt,
                      onTap: () {
                        setState(() {
                          noData = false;
                        });
                      },
                      onChanged: generateSuggestion,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                        fontFamily: 'ContentFont',
                      ),
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        setState(() {
                          loading = true;
                        });

                        searchWord(value);
                      },
                      decoration: cSearchBoxDecoration,
                    ),
                    Flexible(child: buildSuggestions()),
                    NotFoundWidget(noData: noData),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                      controller: txt,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Enter a phrase, a sentence or a paragraph',
                      )),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          child: Text("English-Vienamese",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            print("En-Vi");
                            translateParagraph(txt.text, true);
                          },
                          color: Color.fromARGB(255, 146, 89, 155),
                        ),
                        FlatButton(
                            child: Text("Vietnamese-English",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              print("Vi-En");
                              translateParagraph(txt.text, false);
                            },
                            color: Color.fromARGB(255, 146, 89, 155))
                      ],
                    ),
                  ),
                  TextField(
                      maxLines: 10,
                      enabled: false,
                      decoration: InputDecoration(hintText: meaning)),
                ],
              ),
            ),
    );
  }
}
