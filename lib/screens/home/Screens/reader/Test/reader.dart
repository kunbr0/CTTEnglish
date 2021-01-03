import 'package:flutter/material.dart';
import './post_repo.dart';
import './post.dart';
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
      body: FutureBuilder<List<Post>>(
        future: PostRepository().getPosts(url),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text("Error"),
                content: Text(snapshot.error.toString()),
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data[index].title),
                subtitle: Text(
                  snapshot.data[index].body,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}