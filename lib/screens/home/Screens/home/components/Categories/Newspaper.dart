class Newspaper {
  final bool isInvalid;
  final String title;
  final int id;
  final String thumbnailUrl;
  final int publishTime;
  final String lead;
  final String urlFull;

  Newspaper(
      {this.id,
      this.publishTime,
      this.thumbnailUrl,
      this.title,
      this.lead,
      this.urlFull,
      this.isInvalid});
}
