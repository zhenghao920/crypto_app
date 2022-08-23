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
  num ath;
  num atl;

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
    required this.ath,
    required this.atl,
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
      turnover24: json['total_volume'],
      ath: json['ath'],
      atl: json['atl'],
    );
  }
}

List<CoinModel> coinList = [];