import 'dart:convert';

import 'package:crypto_app/model/candle.dart';
import 'package:crypto_app/model/data.dart';
import 'package:crypto_app/model/news.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CoinRepo {
  // Future<List<News>> fetchNews() async {
  //   newsList = [];
  //   final response = await http.get(Uri.parse(
  //       'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=CRYPTO:BTC&topics=blockchain&apikey=233fae3a7amsh105b58bae6d1fddp1d6c86jsn28c980dab593'));
  //   if (response.statusCode == 200) {
  //     List<dynamic> values = [];
  //     values = json.decode(response.body);
  //     if (values.length > 0) {
  //       for (int i = 0; i < values.length; i++) {
  //         if (values[i] != null) {
  //           Map<String, dynamic> map = values[i];
  //           newsList.add(News.fromJson(map));
  //         }
  //       }
  //     }
  //     print("Fetched news");
  //     return newsList;
  //   } else if (response.statusCode == 110) {
  //     print("Already 110, fetched");
  //     return fetchNews();
  //   } else {
  //     print(response.statusCode);
  //     throw Exception('Failed to load coins');
  //   }
  // }

  Future<List<Candles>> getCandleData1(coinpair, interval) async {
    var coinPair = coinpair.toString().toUpperCase();
    print(coinPair);
    print(
        'https://dev-api.shrimpy.io/v1/exchanges/binance/candles?quoteTradingSymbol=USDT&baseTradingSymbol=$coinPair&interval=$interval');
    candleList = [];
    final response = await http.get(
      Uri.parse(
          'https://dev-api.shrimpy.io/v1/exchanges/binance/candles?quoteTradingSymbol=USDT&baseTradingSymbol=$coinPair&interval=$interval'),
    );
    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            candleList.add(Candles.fromJson(map));
          }
        }
      }
      return candleList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  Future<List<CoinModel>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(CoinModel.fromJson(map));
          }
        }
      }
      print("Fetched");
      return coinList;
    } else if (response.statusCode == 110) {
      print("Already 110, fetched");
      return fetchCoin();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load coins');
    }
  }

  // Future<List<CoinModel>> coinMarketCap() async {
  //   coinList = [];
  //   final response = await http.get(Uri.parse(
  //       'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));
  //   if (response.statusCode == 200) {
  //     List<dynamic> values = [];
  //     values = json.decode(response.body);
  //     if (values.length > 0) {
  //       for (int i = 0; i < values.length; i++) {
  //         if (values[i] != null) {
  //           Map<String, dynamic> map = values[i];
  //           coinList.add(CoinModel.fromJson(map));
  //         }
  //       }
  //     }
  //     return coinList;
  //   } else {
  //     throw Exception('Failed to load coins');
  //   }
  // }

  // Future<List<Candles>> getCandleData() async {
  //   candleList = [];
  //   final response = await http.get(Uri.parse(
  //       'https://poloniex.com/public?command=returnChartData&currencyPair=USDT_BTC&start=1346300800&period=86400'));
  //   if (response.statusCode == 200) {
  //     List<dynamic> values = [];
  //     values = json.decode(response.body);
  //     if (values.length > 0) {
  //       for (int i = 0; i < values.length; i++) {
  //         if (values[i] != null) {
  //           Map<String, dynamic> map = values[i];
  //           candleList.add(Candles.fromJson(map));
  //         }
  //       }
  //     }
  //     return candleList;
  //   } else {
  //     throw Exception('Failed to load coins');
  //   }
  // }

}
