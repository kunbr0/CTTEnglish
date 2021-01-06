import 'package:cached_network_image/cached_network_image.dart';
import 'package:cttenglish/constants.dart';
import 'package:cttenglish/models/news_sentence.dart';
import 'package:flutter/material.dart';


import './vnexpress_article.dart';

class KReader extends StatelessWidget {
  final String url;
  
  KReader({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KReaderScreen(url: url),
    );
  }
}

class KReaderScreen extends StatelessWidget {
  final String url;
  KReaderScreen({Key key, @required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: FutureBuilder<KVnexpressArticle>(
        future: ArticleGenerator().getVnexpressArticle(url),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("error");
          } else if (snapshot.hasData) {
            KSentences kSentences = new KSentences.initData(snapshot.data.content);
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
                                
                              ],
                            ));
                      
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
