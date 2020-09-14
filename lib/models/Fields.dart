class Fields {
  String en;
  String vi;

  Fields({this.en, this.vi});

  Fields.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    vi = json['vi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['vi'] = this.vi;
    return data;
  }
}
