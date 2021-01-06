import 'package:cttenglish/constants.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:html/parser.dart' show parse;

class Definition extends StatelessWidget {
  final int index;
  final wordDetails;

  Definition({this.index, this.wordDetails});

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    print(wordDetails[index]['def'].toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Type Text
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
          child: Text(
            '(${wordDetails[index]['type']}) ',
            style: TextStyle(color: kPrimaryColor, fontStyle: FontStyle.italic),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Index Text
            Text(
              '${(index + 1).toString()}.  ',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.0),
            ),

            //Definition Text
            Expanded(
              child: Text(
                wordDetails[index]['def'].toString(),
                style: cDefinitionTextStyle,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.0),

        //Example text
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            _parseHtmlString('${wordDetails[index]['eg'].toString()}'),
            style: cExampleTextStyle,
          ),
        ),

        Divider(
          height: 40.0,
//          thickness: 2.0,
        ),
      ],
    );
  }
}
