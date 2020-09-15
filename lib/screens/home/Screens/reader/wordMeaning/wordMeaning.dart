import 'package:flutter/material.dart';

class WordMeaning extends StatelessWidget {
  final String word;
  // form values
  WordMeaning({Key key, this.word});

  @override
  Widget build(BuildContext context) {
    //Settings settings = Provider.of<Settings>(context);
    return Container(
      child: Text(word)
    );
  }
}
