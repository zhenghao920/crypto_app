class News {
  final String title;
  final String summary;
  final String url;

  News({required this.title, required this.summary, required this.url});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      summary: json['summary'],
      url: json['url'],
    );
  }
}

List<News> newsList = [];

class New {
  String? items;
  String? sentimentScoreDefinition;
  String? relevanceScoreDefinition;
  List<Feed>? feed;

  New(
      {this.items,
      this.sentimentScoreDefinition,
      this.relevanceScoreDefinition,
      this.feed});

  New.fromJson(Map<String, dynamic> json) {
    items = json['items'];
    sentimentScoreDefinition = json['sentiment_score_definition'];
    relevanceScoreDefinition = json['relevance_score_definition'];
    if (json['feed'] != null) {
      feed = <Feed>[];
      json['feed'].forEach((v) {
        feed!.add(new Feed.fromJson(v));
      });
    }
  }
}

List<New> newsList1 = [];
List<Feed> feedList = [];

class Feed {
  String? title;
  String? url;
  String? timePublished;
  List<String>? authors;
  String? summary;
  String? bannerImage;
  String? source;
  String? categoryWithinSource;
  String? sourceDomain;
  double? overallSentimentScore;
  String? overallSentimentLabel;

  Feed(
      {this.title,
      this.url,
      this.timePublished,
      this.authors,
      this.summary,
      this.bannerImage,
      this.source,
      this.categoryWithinSource,
      this.sourceDomain,
      this.overallSentimentScore,
      this.overallSentimentLabel,});

  Feed.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    timePublished = json['time_published'];
    authors = json['authors'].cast<String>();
    summary = json['summary'];
    bannerImage = json['banner_image'];
    source = json['source'];
    categoryWithinSource = json['category_within_source'];
    sourceDomain = json['source_domain'];
    overallSentimentScore = json['overall_sentiment_score'];
    overallSentimentLabel = json['overall_sentiment_label'];
  }
}