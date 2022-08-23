import 'dart:async';
import 'dart:convert';

import 'package:crypto_app/helper.dart';
import 'package:crypto_app/locator.dart';
import 'package:crypto_app/model/candle.dart';
import 'package:crypto_app/model/news.dart';
import 'package:crypto_app/page/coin_detail_page.dart';
import 'package:crypto_app/model/data.dart';
import 'package:crypto_app/repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //CoinRepo coinRepo = s1<CoinRepo>();
  List<CoinModel> _searchResult = [];
  List<CoinModel> _newList = [];
  final controller = TextEditingController();
  bool _marketCapDesc = true;
  bool _nameDesc = false;
  bool isload = false;
  late int endTime;

  getCurrentTime() {
    DateTime now = DateTime.now();
    endTime = (now.millisecondsSinceEpoch / 1000).round();
    print(endTime);
    return endTime;
  }

  Future<List<CoinModel>> fetchCoin() async {
    isload = true;
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
        if (mounted) {
          setState(() {});
        }
      }
      print("Fetched");
      isload = false;
      return coinList;
    } else if (response.statusCode == 110) {
      print("Already 110, fetched");
      return fetchCoin();
    } else {
      throw Exception('Failed to load coins');
    }
  }

  Future<List<News>> fetchNews() async {
    newsList = [];
    final response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=CRYPTO:BTC&topics=blockchain&apikey=233fae3a7amsh105b58bae6d1fddp1d6c86jsn28c980dab593'));
    if (response.statusCode == 200) {
      //List<dynamic> values = [];
      // values = json.decode(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          if (data[i] != null) {
            newsList.add(News.fromJson(data[i]));
          }
        }
      }
      //print(newsList[0].title);
      print("Fetched news");
      return newsList;
    } else if (response.statusCode == 110) {
      print("Already 110, fetched");
      return fetchNews();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load coins');
    }
  }

  @override
  void initState() {
    fetchCoin();
    fetchNews();
    getCurrentTime();
    Timer.periodic(Duration(seconds: 120), (timer) => getCurrentTime());
    super.initState();
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    setState(() {
      coinList.where((element) {
        var coinName = element.name.toLowerCase();
        return coinName.contains(text.toLowerCase());
      }).toList();
    });

    // coinList.forEach((userDetail) {
    //   if (userDetail.name.toLowerCase().contains(text.toLowerCase()))
    //     _searchResult.add(userDetail);
    // });

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 45,
          ),
          Container(
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              'Watchlist',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.only(top: 5),
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_outlined),
                    hintText: 'Coin Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black))),
                onChanged: searchFood,
              ),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          return setState(() => _nameDesc = !_nameDesc);
                        },
                        icon: RotatedBox(
                          quarterTurns: 0,
                          child: Icon(_nameDesc
                              ? CupertinoIcons.chevron_down
                              : CupertinoIcons.chevron_up),
                        ),
                        label: Text('Name')),
                    TextButton.icon(
                        onPressed: () {
                          return setState(
                              () => _marketCapDesc = !_marketCapDesc);
                        },
                        icon: RotatedBox(
                          quarterTurns: 0,
                          child: Icon(!_marketCapDesc
                              ? CupertinoIcons.chevron_down
                              : CupertinoIcons.chevron_up),
                        ),
                        label: Text('Market Cap')),
                  ],
                ),
              ),
              _searchResult.length != 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: isload == true
                            ? const CircularProgressIndicator()
                            : new ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                            color: Colors.black,
                                            endIndent: 16,
                                            indent: 16),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _searchResult.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => CoinDetail(
                                                    index: index,
                                                    coin: _searchResult,
                                                    end: endTime,
                                                  )));
                                    },
                                    child: CoinCard(
                                      name: _searchResult[index].name,
                                      symbol: _searchResult[index].symbol,
                                      imageUrl: _searchResult[index].image,
                                      price:
                                          _searchResult[index].price.toDouble(),
                                      change: _searchResult[index]
                                          .change
                                          .toDouble(),
                                      changePercentage: _searchResult[index]
                                          .changePercentage
                                          .toDouble(),
                                    ),
                                  );
                                },
                              ),
                      )),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: isload == true
                            ? Padding(
                                padding: const EdgeInsets.only(top: 120),
                                child: Center(
                                    child: Lottie.asset(
                                        'assets/images/loading.json', height: 120, width: 160,),),
                              )
                            : new ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                            color: Colors.black,
                                            endIndent: 16,
                                            indent: 16),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: coinList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => CoinDetail(
                                                    index: index,
                                                    coin: coinList,
                                                    end: endTime,
                                                  )));
                                    },
                                    child: CoinCard(
                                      name: coinList[index].name,
                                      symbol: coinList[index].symbol,
                                      imageUrl: coinList[index].image,
                                      price: coinList[index].price.toDouble(),
                                      change: coinList[index].change.toDouble(),
                                      changePercentage: coinList[index]
                                          .changePercentage
                                          .toDouble(),
                                    ),
                                  );
                                },
                              ),
                      )),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void searchFood(String query) {
    final suggestion = coinList.where((food) {
      final coinName = food.name.toLowerCase();
      final input = query.toLowerCase();
      return coinName.contains(input);
    }).toList();
    setState(() => _searchResult = suggestion);
  }

  _searchItem() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
          decoration: InputDecoration(hintText: 'Typing..'),
          onChanged: (text) {
            setState(() {
              _searchResult = _newList.where((element) {
                var coinName = element.name.toLowerCase();
                return coinName.contains(text.toLowerCase());
              }).toList();
            });
          }),
    );
  }

  // _listItem(index) {
  //   return GestureDetector(
  //     onTap: () async {
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => CoinDetail(index: index, coin: coinList)));
  //     },
  //     child: CoinCard(
  //       name: _searchResult[index].name,
  //       symbol: _searchResult[index].symbol,
  //       imageUrl: _searchResult[index].image,
  //       price: _searchResult[index].price.toDouble(),
  //       change: _searchResult[index].change.toDouble(),
  //       changePercentage: _searchResult[index].changePercentage.toDouble(),
  //     ),
  //   );
  // }
}
// _searchResult.length !=
                    //         0 //|| controller.text.isNotEmpty
                    //     ? Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 5),
                    //         child: new ListView.separated(
                    //           separatorBuilder:
                    //               (BuildContext context, int index) =>
                    //                   const Divider(
                    //                       color: Colors.black,
                    //                       endIndent: 16,
                    //                       indent: 16),
                    //           physics: NeverScrollableScrollPhysics(),
                    //           shrinkWrap: true,
                    //           itemCount: _searchResult.length,
                    //           itemBuilder: (context, index) {
                    //             return CoinCard(
                    //               name: coinList[index].name,
                    //               symbol: coinList[index].symbol,
                    //               imageUrl: coinList[index].image,
                    //               price: coinList[index].price.toDouble(),
                    //               change: coinList[index].change.toDouble(),
                    //               changePercentage:
                    //                   coinList[index].changePercentage.toDouble(),
                    //             );
                    //           },
                    //         ),
                    //       )
                    //     : Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 5),
                    //         child: new ListView.separated(
                    //           separatorBuilder:
                    //               (BuildContext context, int index) =>
                    //                   const Divider(
                    //                       color: Colors.black,
                    //                       endIndent: 8,
                    //                       indent: 8),
                    //           physics: NeverScrollableScrollPhysics(),
                    //           shrinkWrap: true,
                    //           itemCount: coinList.length,
                    //           itemBuilder: (context, index) {
                    //             final sorted = coinList
                    //               ..sort((a, b) => !_marketCapDesc
                    //                   ? b.marketCap.compareTo(a.marketCap)
                    //                   : a.marketCap.compareTo(b.marketCap));
                    //             return GestureDetector(
                    //               onTap: () async {
                    //                 Navigator.of(context).push(MaterialPageRoute(
                    //                     builder: (context) => CoinDetail(
                    //                         index: index, coin: sorted)));
                    //               },
                    //               child: CoinCard(
                    //                 name: sorted[index].name,
                    //                 symbol: sorted[index].symbol,
                    //                 imageUrl: sorted[index].image,
                    //                 price: sorted[index].price.toDouble(),
                    //                 change: sorted[index].change.toDouble(),
                    //                 changePercentage:
                    //                     sorted[index].changePercentage.toDouble(),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),

// itemCount: _searchResult.length + 1,
                    // itemBuilder: (context, index) {
                    //   return index == 0
                    //       ? _searchItem()
                    //       : GestureDetector(
                    //           onTap: () async {
                    //             Navigator.of(context).push(MaterialPageRoute(
                    //                 builder: (context) => CoinDetail(
                    //                     index: index, coin: coinList)));
                    //           },
                    //           child: CoinCard(
                    //             name: _searchResult[index].name,
                    //             symbol: _searchResult[index].symbol,
                    //             imageUrl: _searchResult[index].image,
                    //             price: _searchResult[index].price.toDouble(),
                    //             change: _searchResult[index].change.toDouble(),
                    //             changePercentage: _searchResult[index]
                    //                 .changePercentage
                    //                 .toDouble(),
                    //           ),
                    //         );
                    // },

/*
class FirstScreen extends StatefulWidget {
  const FirstScreen({
    Key? key,
  }) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late Future<BigDataModel> _futureCoins;
  late Repository repository;
  @override
  void initState() {
    repository = Repository();
    _futureCoins = repository.getCoins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BigDataModel>(
      future: _futureCoins,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var coinsData = snapshot.data!.dataModel;
            return CoinListWidget(coins: coinsData);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CoinListWidget extends StatelessWidget {
  final List<DataModel> coins;

  const CoinListWidget({
    Key? key,
    required this.coins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Text(
              "Crypto Currency",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: ListView.builder(
              itemExtent: 160,
              itemCount: coins.length,
              itemBuilder: (context, index) {
                var coin = coins[index];
                var coinPrice = coin.quoteModel.usdModel;
                var data = [
                  ChartData(coinPrice.percentChange_90d, 2160),
                  ChartData(coinPrice.percentChange_60d, 1440),
                  ChartData(coinPrice.percentChange_30d, 720),
                  ChartData(coinPrice.percentChange_24h, 24),
                  ChartData(coinPrice.percentChange_1h, 1),
                ];
                return GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    height: 160.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CoinLogoWidget(coin: coin),
                        CoinChartWidget(
                          data: data,
                          coinPrice: coinPrice,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CoinLogoWidget extends StatelessWidget {
  final DataModel coin;
  const CoinLogoWidget({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var coinIconUrl =
        "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/";
    TextTheme textStyle = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      height: 96.0,
      width: 96.0,
      //78 Remaining
      child: Column(
        children: [
          Container(
              height: 50.0,
              width: 50.0,
              child: CachedNetworkImage(
                imageUrl: ((coinIconUrl + coin.symbol + ".png").toLowerCase()),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    SvgPicture.asset('assets/icons/dollar.svg'),
              )),
          const SizedBox(height: 4.0),
          Text(
            coin.symbol,
            style: textStyle.subtitle1,
          ),
          const SizedBox(height: 2.0),
          Text(
            "\$" + coin.quoteModel.usdModel.price.toStringAsFixed(2),
            style: textStyle.subtitle2,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final num value;
  final int year;

  ChartData(this.value, this.year);
}

class CoinChartWidget extends StatelessWidget {
  const CoinChartWidget({
    Key? key,
    required this.data,
    required this.coinPrice,
    required this.color,
  }) : super(key: key);

  final List<ChartData> data;
  final UsdModel coinPrice;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0),
              height: 96.0,
              width: double.infinity,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(isVisible: false),
                primaryYAxis: CategoryAxis(isVisible: false),
                legend: Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: false),
                series: <ChartSeries<ChartData, String>>[
                  LineSeries<ChartData, String>(
                    dataSource: data,
                    xValueMapper: (ChartData sales, _) => sales.year.toString(),
                    yValueMapper: (ChartData sales, _) => sales.value,
                  ),
                ],
              ),
            ),
          ),
          color == Colors.green
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(right: 16.0),
                  alignment: Alignment.center,
                  width: 72,
                  height: 36,
                  decoration: BoxDecoration(
                      color: coinPrice.percentChange_7d >= 0
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Text(
                    coinPrice.percentChange_7d.toStringAsFixed(2) + "%",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }
}
*/