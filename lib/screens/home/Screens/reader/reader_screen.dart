import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'wordMeaning/wordMeaningPanel.dart';
import 'settingsPanel/settingsPanel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/style.dart';

import 'package:cttenglish/constants.dart';
import '../../../../constants.dart';
import './articleContent.dart';

class ReaderScreen extends StatefulWidget {
  final String data;
  ReaderScreen({Key key, @required this.data}) : super(key: key);
  @override
  _ReaderScreenState createState() => _ReaderScreenState(articleUrl: data);
}

class _ReaderScreenState extends State<ReaderScreen> {
  final String articleUrl;
  double fontSize = 19.0;
  final articleContentStream = StreamController<ArticleContent>();

  _ReaderScreenState({Key key, @required this.articleUrl});

  void getNewspaper() async {
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
      articleContentStream.sink.add(artContent);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      articleContentStream.sink
          .addError('Request failed with status: ${response.statusCode}.');
    }
  }

  void _changeFontSize(double newFontSize) {
    setState(() {
      fontSize = newFontSize;
    });
  }

  @override
  void initState() {
    super.initState();
    fontSize = fontSize ?? 0.0;
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
              ),
            );
          });
    }

    void _showWordMeaning(String data, BuildContext screenContext) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          elevation: 10,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.7,
              child: WordMeaningView(
                word: data,
              ),
            );
          });
    }

    void onTapWord(String word) {
      debugPrint(word);
      debugPrint(MediaQuery.of(context).size.height.toString());
      _showWordMeaning(word, context);
    }

    // KSentence sentence = new KSentence(
    //     data: data,
    //     sentence: data
    //         .split(" ")
    //         .map((word) =>
    //             KWord(word, fontSize: fontSize, onTap: onTapWord).word)
    //         .toList());

    return Scaffold(
      appBar: AppBar(
        title: Text('Reader Screen'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/settings.svg",
              width: 25,
            ),
            onPressed: () => _showSettingsPanel(),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: articleContentStream.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      height: 200,
                      width: 360,
                      imageUrl: snapshot.data.thumbnailUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data.title,
                        style: TextStyle(
                            color: cArticleTitle,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    snapshot.data.content != null
                        ? Html(data: snapshot.data.content, style: {
                            "p": Style(
                              fontSize: FontSize.larger,
                            ),
                            "img": Style()
                          })
                        : Container(height: 0)
                  ],
                ),
              ),
            );
          }),
    );
  }
}
