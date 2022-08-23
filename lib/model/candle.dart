class Candles {
  final x;
  final high1;
  final low1;
  final open1;
  final close1;

  Candles(
      {required this.x,
      required this.high1,
      required this.low1,
      required this.open1,
      required this.close1});

  factory Candles.fromJson(Map<String, dynamic> json) {
    return Candles(
      //x: DateTime.fromMillisecondsSinceEpoch(int.parse(json['date']) * 1000),
      x: DateTime.parse(json['time']),
      high1: num.parse(json['high']),
      low1: num.parse(json['low']),
      open1: num.parse(json['open']),
      close1: num.parse(json['close']),
    );
  }
}

List<Candles> candleList = [];