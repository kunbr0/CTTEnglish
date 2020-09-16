//get api of translator

import 'dart:convert';
import 'package:cttenglish/models/Translator.dart';
import 'package:http/http.dart' as http;
import 'Sentences.dart';

class Services {
  static const String url = 'https://api.kunbr0.com/en-vi.php?kInput=';

  static Future<List<Sentences>> getSentences(String query) async {
    List<Sentences> list = List<Sentences>();
    if (query == '') {
      return list;
    }
    try {
      final response = await http.get(url + query);
      if (response.statusCode == 200) {
        list = parseUsers(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Sentences> parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody);
    Translator translator = Translator.fromJson(parsed);
    return translator.sentences;
  }
}
