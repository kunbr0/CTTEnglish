import 'package:http/http.dart' as http;
import './post.dart';



class PostRepository {
  
  Future<List<Post>> getPosts(String url) async {
    final response =
        await http.get(url);
    return postFromJson(response.body);
  }
}
