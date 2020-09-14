import 'Sentences.dart';

class Translator {
  String language;
  List<Sentences> sentences;

  Translator({this.language, this.sentences});

  Translator.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    if (json['sentences'] != null) {
      sentences = new List<Sentences>();
      json['sentences'].forEach((v) {
        sentences.add(new Sentences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    if (this.sentences != null) {
      data['sentences'] = this.sentences.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
