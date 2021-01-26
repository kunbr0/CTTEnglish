import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/NetworkHelper.dart';
import '../screens/word_page.dart';
import '../constant.dart';
import '../widgets/not_found.dart';
import './../../../../../models/Service.dart';
import '../screens/paraphrase_example.dart';
import 'package:cttenglish/constants.dart';

enum DictionaryCategories { EnEn, EnVi, TranslateParagraph, EnglishParaphrase }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

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
        result = "En-En Dictionary";
        break;
      case DictionaryCategories.EnVi:
        result = "En-Vi Dictionary";
        break;
      case DictionaryCategories.TranslateParagraph:
        result = "Translate Paragraph";
        break;
      case DictionaryCategories.EnglishParaphrase:
        result = "English Paraphrase";
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

  void searchParaphrase(String phrase) async {
    var res =
        await http.get('https://api.kunbr0.com/en-vi.php?kInput=' + phrase);
    loading = false;
    setState(() {});
    var examplesList = jsonDecode(res.body)["sentences"];

    setState(() {
      loading = false;
    });

    if (wordDetails == null) {
      setState(() {
        noData = true;
      });
    } else {
      noData = false;
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ParapharaseExamplePage(
                      phrase: phrase, examplesList: examplesList)))
          .then((value) => setState(() {}));
    }
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

    all.sort();
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

  Widget _buildSettingDialog(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        title: Center(
            child: Text('Dictionary Settings',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                  height: 260,
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

  Widget _buildVoicePanel(BuildContext context) {
    return SafeArea(
      child: AlertDialog(content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _text,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AvatarGlow(
                    animate: _isListening,
                    glowColor: Theme.of(context).primaryColor,
                    endRadius: 75.0,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (!_isListening) {
                          bool available = await _speech.initialize(
                            onStatus: (val) => print('onStatus: $val'),
                            onError: (val) => print('onError: $val'),
                          );
                          if (available) {
                            setState(() => _isListening = true);
                            await _speech.listen(
                              onResult: (val) => setState(() {
                                _text = val.recognizedWords;
                                print(_text);
                                print("Hu");
                                if (val.hasConfidenceRating &&
                                    val.confidence > 0) {
                                  _confidence = val.confidence;
                                }
                              }),
                            );

                            Future.delayed(const Duration(milliseconds: 4000),
                                () {
                              // Here you can write your code
                              Navigator.pop(context);
                              setState(() {
                                // Here you can write your code for open new view
                                txt.text = _text;
                              });
                              _isListening = false;
                              _text = "";
                            });
                          }
                        } else {
                          setState(() => _isListening = false);
                          _speech.stop();
                        }
                      },
                      child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    ),
                  ),
                  Text("Press the micro button to start to speak")
                ],
              ),
            );
          },
        ),
      )),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        await _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            // Navigator.pop(context, true);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
                      icon: SvgPicture.asset(
                        "assets/icons/settings.svg",
                        width: 25,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _buildSettingDialog(context),
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
                        generateTitle(_currentCategory),
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

                          _currentCategory ==
                                  DictionaryCategories.EnglishParaphrase
                              ? searchParaphrase(value)
                              : searchWord(value);
                        },
                        decoration: _currentCategory ==
                                DictionaryCategories.EnglishParaphrase
                            ? cParaphraseDecoration
                            : InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFEAEAEA),
                                hintText: 'search here',
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 30.0,
                                  color: Colors.black26,
                                ),
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.mic),
                                    iconSize: 30,
                                    color: Colors.black26,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _buildVoicePanel(context),
                                      );
                                    }),
                                border: InputBorder.none,
                              ),
                      ),
                      Flexible(child: buildSuggestions()),
                      NotFoundWidget(noData: noData),
                    ],
                  ),
                ),
              )
            :
            //  (_currentCategory == DictionaryCategories.TranslateParagraph)
            //     ?
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                            controller: txt,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter a phrase, a sentence or a paragraph',
                            )),
                      ),
                    ),
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                            maxLines: 6,
                            enabled: false,
                            decoration: InputDecoration(hintText: meaning)),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
