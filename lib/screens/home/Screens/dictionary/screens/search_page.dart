import 'dart:ui';

import 'package:cttenglish/constants.dart';

import '../constant.dart';
import 'package:flutter/material.dart';
import '../services/NetworkHelper.dart';
import '../screens/word_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../widgets/not_found.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool loading = false;
  bool noData = false;
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
              NotFoundWidget(noData: noData),
            ],
          ),
        ),
      ),
    );
  }
}
