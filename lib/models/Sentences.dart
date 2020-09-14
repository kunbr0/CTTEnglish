import 'Fields.dart';

class Sentences {
  String sId;
  Fields fields;

  Sentences({this.sId, this.fields});

  Sentences.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fields =
        json['fields'] != null ? new Fields.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.fields != null) {
      data['fields'] = this.fields.toJson();
    }
    return data;
  }
}
