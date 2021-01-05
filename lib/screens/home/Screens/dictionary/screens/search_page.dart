import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../services/NetworkHelper.dart';
import '../screens/word_page.dart';
import '../constant.dart';
import '../widgets/not_found.dart';
import 'package:cttenglish/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool loading = false;
  bool noData = false;
  List<String> suggestionList = [];
  TextEditingController txt = TextEditingController();

  void searchWord(String word) async {
    NetworkHelper networkHelper = NetworkHelper();

    List<Map> wordDetails = await networkHelper.getData(word);
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
            builder: (BuildContext context) =>
                WordPage(wordDetails: wordDetails, word: word),
          ));
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
          return ListTile(
            leading: const Icon(Icons.history),
            title: RichText(
              text: TextSpan(
                text: suggestion,
                style: TextStyle(color: Colors.black),
              ),
            ),
            onTap: () {
              txt.text = suggestion;
              suggestionList.clear();
              setState(() {});
            },
          );
        });
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
          )),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        color: Colors.black26,
        progressIndicator: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
          backgroundColor: Colors.black12,
          strokeWidth: 5,
        ),
        opacity: 0.2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Dictionary',
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
                  fontSize: 17.0,
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
      ),
    );
  }
}
