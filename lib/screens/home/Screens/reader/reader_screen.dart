import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cttenglish/models/Translator.dart';
import 'package:cttenglish/services/remove_special_charater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'wordMeaning/wordMeaningPanel.dart';
import 'settingsPanel/settingsPanel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/style.dart';
import 'package:translator/translator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:cttenglish/constants.dart';
import '../../../../constants.dart';
import './articleContent.dart';
import 'package:cttenglish/models/news_sentence.dart';
import 'package:cttenglish/utils/sleep.dart';

import 'package:cttenglish/shared/round_box_decoration.dart';

class ReaderScreen extends StatefulWidget {
  final String data;
  ReaderScreen({Key key, @required this.data}) : super(key: key);
  @override
  _ReaderScreenState createState() => _ReaderScreenState(articleUrl: data);
}

class _ReaderScreenState extends State<ReaderScreen> {
  final String articleUrl;
  static double fontSize = 19.0;
  static Color backgroundColor = cBackgroundColor;
  KSentences kSentences = new KSentences();
  final articleContentStream = StreamController<ArticleContent>();
  static const List<String> redundantString = [".", ",", '"', "!", "?", "' "];
  bool isLoading;

  _ReaderScreenState({Key key, @required this.articleUrl});

  void getNewspaper() async {
    setState(() {
      this.isLoading = true;
    });
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = articleUrl;

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var dataResponse = convert.jsonDecode(response.body)['data'];
      var artContent = new ArticleContent(
        title: dataResponse['title'],
        content: dataResponse['content'],
        thumbnailUrl: dataResponse['thumbnail_url'],
      );

      await uSleep(700);
      articleContentStream.sink.add(artContent);
      await uSleep(1300);
      setState(() {
        this.isLoading = false;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      articleContentStream.sink
          .addError('Request failed with status: ${response.statusCode}.');
    }
  }

  void _changeFontSize(double newFontSize) {
    this.kSentences.onChangeFontSize(newFontSize);
    setState(() {
      _ReaderScreenState.fontSize = newFontSize;
    });
  }

  void _onChangeBackgroundColor(Color color) {
    setState(() {
      _ReaderScreenState.backgroundColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    _ReaderScreenState.fontSize = fontSize ?? 0.0;
    this.isLoading = isLoading ?? false;
    _ReaderScreenState.backgroundColor =
        _ReaderScreenState.backgroundColor ?? Color.fromRGBO(38, 38, 38, 0.4);

    getNewspaper();
  }

  @override
  void dispose() {
    super.dispose();
    articleContentStream.close();
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SettingsPanel(
                fontSize: fontSize,
                changeFontSize: _changeFontSize,
                changeBackgroundColor: _onChangeBackgroundColor,
              ),
            );
          });
    }

    void cShowModalBottomSheet(Widget kChild) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          elevation: 10,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              height: MediaQuery.of(context).size.height * 0.7,
              child: SizedBox.expand(
                  child: SingleChildScrollView(
                child: kChild,
              )),
            );
          });
    }

    void _showWordMeaning(String data, BuildContext screenContext) async {
      bool check = false;
      cShowModalBottomSheet(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Wrap(children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Text(
                          removeSpecialCharater(
                                  data, _ReaderScreenState.redundantString, "")
                              .toLowerCase(),
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: kTextColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                          icon: check == true
                              ? Icon(Icons.star, size: 30)
                              : Icon(Icons.star_border, size: 30),
                          onPressed: () {
                            setModalState(() {
                              check = !check;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12),
                  RoundBoxDecoration(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Meaning: ",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            )),
                        FutureBuilder<Translation>(
                          future: () async {
                            final translator = GoogleTranslator();
                            Future<Translation> meaning = translator
                                .translate(data, from: 'en', to: 'vi');
                            await uSleep(700);
                            return meaning;
                          }(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("No internet connection!"),
                              );
                            }
                            if (snapshot.hasData) {
                              return Text(
                                removeSpecialCharater(snapshot.data.toString(),
                                    redundantString, ""),
                                style: TextStyle(fontSize: 20),
                              );
                            }
                            return Center(
                                child: SpinKitThreeBounce(
                              size: 15.0,
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: kPrimaryColor),
                                );
                              },
                            ));
                          },
                        )
                      ],
                    ),
                  )),
                  SizedBox(height: 20),
                  RoundBoxDecoration(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Example: ",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: kTextColor)),
                          SizedBox(height: 10),
                          WordMeaningView(
                            word: data,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              )
            ]);
          },
        ),
      );
    }

    void _showParagraphMeaning(
        String paragraph, BuildContext screenContext) async {
      cShowModalBottomSheet(
        Column(children: [
          SizedBox(height: 10),
          Text("Translate sentences",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              )),
          SizedBox(height: 20),
          RoundBoxDecoration(
            child: Column(
              children: [
                Text("English: ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    )),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    paragraph,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          RoundBoxDecoration(
              child: Column(
            children: [
              Text("Vietnamese: ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  )),
              SizedBox(height: 10),
              FutureBuilder<Translation>(
                future: () async {
                  final translator = GoogleTranslator();
                  Future<Translation> meaning =
                      translator.translate(paragraph, from: 'en', to: 'vi');
                  await uSleep(700);
                  return meaning;
                }(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("No internet connection!"),
                    );
                  }
                  if (snapshot.hasData) {
                    uSleep(700);
                    return Html(data: snapshot.data.toString(), style: {
                      "*": Style(fontSize: FontSize(20)),
                    });
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            ],
          )),
          SizedBox(height: 10)
        ]),
      );
    }

    void onTapWord(String word) {
      _showWordMeaning(word, context);
    }

    void onTranslateButtonPressed(String paragraph) {
      _showParagraphMeaning(paragraph, context);
      // print("Hello");
    }

    this.kSentences.onCallback(onTapWord, onTranslateButtonPressed);
    // KSentence sentence = new KSentence(
    //     data: data,
    //     sentence: data
    //         .split(" ")
    //         .map((word) =>
    //             KWord(word, fontSize: fontSize, onTap: onTapWord).word)
    //         .toList());
    AppBar appBar = AppBar(
      title: Center(
          child: Text(
        'CTTEnglish',
        style: TextStyle(
            color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
      )),
      backgroundColor: kPrimaryColor,
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/settings.svg",
            width: 25,
          ),
          onPressed: () => _showSettingsPanel(),
        ),
      ],
    );
    return Scaffold(
        appBar: appBar,
        body: Container(
          color: _ReaderScreenState.backgroundColor,
          child: SingleChildScrollView(
            child: IndexedStack(
              index: this.isLoading ? 0 : 1,
              children: [
                this.isLoading
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            appBar.preferredSize.height,
                        //color: Colors.red[100],
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: kPrimaryColor,
                        )),
                      )
                    : SizedBox(),
                StreamBuilder(
                    stream: articleContentStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        this.kSentences =
                            new KSentences.initData(snapshot.data.content);
                        return Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  height: 200,
                                  width: 360,
                                  imageUrl: snapshot.data.thumbnailUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data.title,
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: kSentences.getAllTextContent(),
                                  ),
                                ),
                              ],
                            ));
                      }
                      return SizedBox();
                    }),
              ],
            ),
          ),
        ));
  }
}
