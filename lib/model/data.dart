class CoinModel {
  String name;
  String symbol;
  String image;
  num price;
  num change;
  num changePercentage;
  int marketCap;
  num high24;
  num low24;
  num turnover24;

  CoinModel({
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.change,
    required this.changePercentage,
    required this.marketCap,
    required this.high24,
    required this.low24,
    required this.turnover24,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      price: json['current_price'],
      change: json['price_change_24h'],
      changePercentage: json['price_change_percentage_24h'], 
      marketCap: json['market_cap'],
      high24: json['high_24h'],
      low24: json['low_24h'],
      turnover24: json['total_volume']
    );
  }
}

List<CoinModel> coinList = [];

/*class BigDataModel {
  final StatusModel statusModel;
  final List<DataModel> dataModel;

  BigDataModel({
    required this.statusModel,
    required this.dataModel,
  });
  factory BigDataModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<DataModel> dataModelList =
        dataList.map((e) => DataModel.fromJson(e)).toList();
    return BigDataModel(
      statusModel: StatusModel.fromJson(json["status"]),
      dataModel: dataModelList,
    );
  }
  BigDataModel.withError(String error)
      : statusModel = StatusModel(error, 0, error, 0, 0, error, 0),
        dataModel = [];
}

class StatusModel {
  final String timestamp;
  final int errorCode;
  final String errorMessage;
  final int elapsed;
  final int creditCount;
  final String notice;
  final int totalCount;

  StatusModel(this.timestamp, this.errorCode, this.errorMessage, this.elapsed,
      this.creditCount, this.notice, this.totalCount);
  StatusModel.fromJson(Map<String, dynamic> json)
      : timestamp = json["timestamp"] == null ? "" : json["timestamp"],
        errorCode = json["error_code"] == null ? 0 : json["error_code"],
        errorMessage =
            json["error_message"] == null ? "" : json["error_message"],
        elapsed = json["elapsed"] == null ? 0 : json["elapsed"],
        creditCount = json["credit_count"] == null ? 0 : json["credit_count"],
        notice = json["notice"] == null ? "" : json["notice"],
        totalCount = json["total_count"] == null ? 0 : json["total_count"];
}

class DataModel {
  final int id;
  final String name;
  final String symbol;
  final String slug;
  final int numMarketPairs;
  final String dateAdded;
  final List<dynamic> tags;
  final int maxSupply;
  final num circulatingSupply;
  final num totalSupply;

  final int cmcRank;
  final String lastUpdated;
  final QuoteModel quoteModel;

  DataModel(
      this.id,
      this.name,
      this.symbol,
      this.slug,
      this.numMarketPairs,
      this.dateAdded,
      this.tags,
      this.maxSupply,
      this.circulatingSupply,
      this.totalSupply,
      this.cmcRank,
      this.lastUpdated,
      this.quoteModel);
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      json["id"],
      json["name"],
      json["symbol"],
      json["slug"],
      json["num_market_pairs"],
      json["date_added"],
      json["tags"],
      json["max_supply"] == null ? 0 : json["max_supply"],
      json["circulating_supply"],
      json["total_supply"],
      json["cmc_rank"],
      json["last_updated"],
      QuoteModel.fromJson(json["quote"]),
    );
  }
}

class QuoteModel {
  final UsdModel usdModel;

  QuoteModel({
    required this.usdModel,
  });
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      usdModel: UsdModel.fromJson(json["USD"]),
    );
  }
}

class UsdModel {
  final num price;
  final num volume24h;
  final num percentChange_1h;
  final num percentChange_24h;
  final num percentChange_7d;
  final num percentChange_30d;
  final num percentChange_60d;
  final num percentChange_90d;
  final num marketCap;
  final String lastUpdated;

  UsdModel(
      {required this.price,
      required this.volume24h,
      required this.percentChange_1h,
      required this.percentChange_24h,
      required this.percentChange_7d,
      required this.percentChange_30d,
      required this.percentChange_60d,
      required this.percentChange_90d,
      required this.marketCap,
      required this.lastUpdated});

  factory UsdModel.fromJson(Map<String, dynamic> json) {
    return UsdModel(
      price: json["price"] == null ? 0.0 : json["price"],
      volume24h: json["volume_24"] == null ? 0.0 : json["volume_24"],
      percentChange_1h:
          json["percent_change_1h"] == null ? 0.0 : json["percent_change_1h"],
      percentChange_24h:
          json["percent_change_24h"] == null ? 0.0 : json["percent_change_24h"],
      percentChange_7d:
          json["percent_change_7d"] == null ? 0.0 : json["percent_change_7d"],
      percentChange_30d:
          json["percent_change_30d"] == null ? 0.0 : json["percent_change_7d"],
      percentChange_60d:
          json["percent_change60d"] == null ? 0.0 : json["percent_change60d"],
      percentChange_90d:
          json["percent_change90d"] == null ? 0.0 : json["percent_change90d"],
      marketCap: json["market_cap"] == null ? 0.0 : json["market_cap"],
      lastUpdated: json["last_updated"],
    );
  }
}
*/