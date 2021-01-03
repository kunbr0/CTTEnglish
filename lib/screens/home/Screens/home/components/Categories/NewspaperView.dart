import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cttenglish/screens/home/Screens/home/components/Categories/Newspaper.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'Newspaper.dart';
import 'package:cttenglish/constants.dart';

// import '../../../../../../constants.dart';
// import 'package:cttenglish/constants.dart';

class NewspaperView extends StatefulWidget {
  final String word;
  NewspaperView({Key key, this.word}) : super(key: key);

  @override
  _NewspaperViewState createState() => _NewspaperViewState(word);
}

class _NewspaperViewState extends State<NewspaperView> {
  final String data;
  _NewspaperViewState(this.data);

  final ariclesList = StreamController<List<Newspaper>>();

  void getNewspaper() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
        '$vnEndpoint/article?type=get_rule_2&cate_id=1003894&limit=60&offset=0&option=video_autoplay&app_id=9e304d';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      List<Newspaper> articlesData =
          jsonResponse['data']['1003894'].map<Newspaper>((news) {
        var newsId = news['article_id'].toString();

        return Newspaper(
            id: news['article_id'],
            isInvalid: news['article_type'] == 1 ? true : false,
            title: news['title'],
            lead: news['lead'],
            thumbnailUrl: news['thumbnail_url'],
            publishTime: news['publish_time'],
            urlFull:
                '$vnEndpoint/article?type=get_full&article_id=$newsId&app_id=9e304d');
      }).toList();

      List<Newspaper> filterArticles =
          articlesData.where((i) => i.isInvalid).toList();

      ariclesList.sink.add(filterArticles);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      ariclesList.sink
          .addError('Request failed with status: ${response.statusCode}.');
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
    ariclesList.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ariclesList.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          }
          return Scaffold(
            backgroundColor: Colors.grey,
            body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(0.0)),
                          color: Colors.white
                      ),
                    child: new Material(
                      child: new InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/reader',
                            arguments: snapshot.data[index].urlFull);
                        },
                        child: new Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CachedNetworkImage(
                                  height: 200,
                                  width: 1000,
                                  imageUrl: snapshot.data[index].thumbnailUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data[index].title,
                                  style: TextStyle(
                                      color: cArticleTitle,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    
                                    Text(
                                    timeago.format(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            snapshot.data[index].publishTime *
                                                1000)),
                                    style: TextStyle(
                                        color: cArticleTime,
                                        fontStyle: FontStyle.normal)
                                    ),

                                  ],
                                ),
                               
                                SizedBox(height: 10),
                                Text(snapshot.data[index].lead,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                
                                SizedBox(height: 10),
                              ]
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                    
                  );
                }),
          );
        });
  }
}
