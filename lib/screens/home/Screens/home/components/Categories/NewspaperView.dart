import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cttenglish/screens/home/Screens/home/components/Categories/Newspaper.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewspaperView extends StatefulWidget {
  final String word;
  NewspaperView({Key key, this.word}) : super(key : key);

  @override
  _NewspaperViewState createState() => _NewspaperViewState(word);
}

class _NewspaperViewState extends State<NewspaperView> {
  final String data;
  _NewspaperViewState(this.data);

  final wordMeaningStream = StreamController <List<Newspaper>>();

  void getNewspaper() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = 'https://api3.vnexpress.net/api/article?type=get_rule_2&cate_id=1003894&limit=60&offset=0&option=video_autoplay&app_id=9e304d';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var sentences = jsonResponse['data']['1003894'].map<Newspaper>((news){
        var newsId = news['article_id'].toString();
        
        return Newspaper(
          id: news['article_id'],
          title: news['title'],
          thumbnailUrl: news['thumbnail_url'],
          publishTime: news['publish_time'],
          urlFull: 'https://api3.vnexpress.net/api/article?type=get_full&article_id=$newsId&app_id=9e304d'
        );
      }).toList();

      print('Get wordmeaning successfully .');
      wordMeaningStream.sink.add(sentences);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      wordMeaningStream.sink.addError('Request failed with status: ${response.statusCode}.');
    }
  }
  
  @override
  void initState() {
    super.initState();
    getNewspaper();
  }

  @override
  void dispose() {
    super.dispose();
    wordMeaningStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: wordMeaningStream.stream,
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Text('Loading...');
        }
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data.map<Widget>((elm){
              return InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed('/reader', arguments: elm.urlFull);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.blue[200])),
                  child : Row(
                    children: [
                     
                      // CachedNetworkImage(
                      //   height: 55,
                      //   width: 90,
                      //   imageUrl:  elm.thumbnailUrl,
                      //   imageBuilder: (context, imageProvider) => Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       image: DecorationImage(
                      //           image: imageProvider,
                      //           fit: BoxFit.cover,
                                
                      //       ),
                      //     ),
                      //   ),
                        
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      // ),
                      SizedBox(width: 10,),
                      Expanded(child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Vnexpress', style: TextStyle(color: Color(0xff911f20)),),
                                Text(
                                  timeago.format(new DateTime.fromMillisecondsSinceEpoch(elm.publishTime*1000)),
                                  style: TextStyle(color: Color(0xff696969)))
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              elm.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              );
            }).toList(),
          ),
        );
      });
  }
}

