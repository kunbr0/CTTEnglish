import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../services/NetworkHelper.dart';
import '../screens/word_page.dart';
import '../constant.dart';
import '../widgets/not_found.dart';
import 'package:cttenglish/constants.dart';

enum DictionaryCategories { EnEn, EnVi, ViEn }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool loading = false;
  bool noData = false;
  DictionaryCategories _currentCategory = DictionaryCategories.EnEn;

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
      case DictionaryCategories.ViEn:
        result = "Vietnamese-English";
        break;
      default:
        break;
    }
    return result;
  }

  List<Map> generateWordDetails() {
    return [
      {
        "type": "exclamation",
        "def":
            "used as a greeting or to begin a telephone conversation.",
        "eg": "hello there, Katie!",
        "image_url": null,
        "emoji": null
      },
      {
        "type": "noun",
        "def": "an utterance of ; a greeting.",
        "eg": "she was getting polite nods and hellos from people",
        "image_url": null,
        "emoji": null
      },
      {
        "type": "verb",
        "def": "say or shout âhelloâ",
        "eg": "I pressed the phone button and helloed",
        "image_url": null,
        "emoji": null
      }
    ];
  }

  void searchWord(String word) async {
    NetworkHelper networkHelper = NetworkHelper();
    List<Map> wordDetails = [];
    switch (_currentCategory) {
      case DictionaryCategories.EnEn:
        wordDetails = await networkHelper.getData(word);
        break;
      case DictionaryCategories.EnVi:
        wordDetails = generateWordDetails();
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
      body: _currentCategory != DictionaryCategories.ViEn
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
          : Text('ViEn'),
    );
  }
}
