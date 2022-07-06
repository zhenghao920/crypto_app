import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoinDetail extends StatefulWidget {
  final List coin;
  final int index;
  const CoinDetail({Key? key, required this.coin, required this.index})
      : super(key: key);

  @override
  _CoinDetailState createState() => _CoinDetailState();
}

class _CoinDetailState extends State<CoinDetail> {
  List<Candle> candles = [];

  Future<List<Candle>> fetchCandles() async {
    final uri = Uri.parse(
        "https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1h");
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Candle.fromJson(e))
        .toList()
        .reversed
        .toList();
  }

  @override
  void initState() {
    fetchCandles().then((value) {
      setState(() {
        candles = value;
      });
    });
    super.initState();
  }
// https://finnhub.io/api/v1/crypto/candle?symbol=BINANCE:BTCUSDT&resolution=D&from=1572651390&to=1575243390&token=cajmn4aad3icpj9q4t8g
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin[widget.index].name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.coin[widget.index].price.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '24h High ',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '24h Low ',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '24h Turnover ',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.coin[widget.index].high24.toString(),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            widget.coin[widget.index].low24.toString(),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            widget.coin[widget.index].turnover24.toString(),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 250,
              child: Candlesticks(
                candles: candles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* 

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: [
        HomePage(),
        //NutritionPage(),
        DietPage(),
        //BmiCalculator(),
        ArConfirmPage(),
        ProfilePage(),
      ],
    );
  }

  Widget getFooter() {
    List items = [
      LineIcons.home,
      LineIcons.fruitApple,
      LineIcons.camera,
      LineIcons.user
    ];
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: black,
        border:
            Border(top: BorderSide(width: 1, color: black.withOpacity(0.06))),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            return InkWell(
              onTap: (){
                setState(() {
                  pageIndex = index;
                });
              },
              child: Column(
                children: [
                  Icon(items[index],size: 28,
                  color: pageIndex == index ? thirdColor: white,),
                  SizedBox(height: 5,),
                  pageIndex == index ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: thirdColor,
                      shape: BoxShape.circle
                    ),
                  ) : Container()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
*/