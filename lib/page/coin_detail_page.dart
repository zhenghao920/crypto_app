import 'dart:convert';
import 'dart:io';

import 'package:crypto_app/locator.dart';
import 'package:crypto_app/model/candle.dart';
import 'package:crypto_app/repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinDetail extends StatefulWidget {
  final List coin;
  final int index;
  final int end;
  const CoinDetail({
    Key? key,
    required this.coin,
    required this.index,
    required this.end,
  }) : super(key: key);

  @override
  _CoinDetailState createState() => _CoinDetailState();
}

class _CoinDetailState extends State<CoinDetail> {
  String interv = '1D';
  CoinRepo coinRepo = s1<CoinRepo>();
  bool bolling = false;
  bool rsi = false;

  NumberFormat formatNum = NumberFormat.compact(
    locale: 'en',
  );
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  @override
  void initState() {
    coinRepo.getCandleData1(widget.coin[widget.index].symbol, interv);
    buildChart();
    super.initState();
    //getCandleDate();
  }

  // Future<List<Candles>> getCandleData() async {
  //   var coinPair = widget.coin[widget.index].symbol.toString().toUpperCase();
  //   var endTime = widget.end;
  //   print(coinPair);
  //   print(endTime);
  //   print(
  //       'https://poloniex.com/public?command=returnChartData&currencyPair=USDT_$coinPair&start=1626652800&$endTime&period=86400');
  //   candleList = [];
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://poloniex.com/public?command=returnChartData&currencyPair=USDT_$coinPair&start=1626652800&end=$endTime&period=86400'),
  //     headers: {HttpHeaders.authorizationHeader: ''},
  //   );
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

  // Future<List<Candles>> getCandleData1(interval) async {
  //   var coinPair = widget.coin[widget.index].symbol.toString().toUpperCase();
  //   print(coinPair);
  //   print(
  //       'https://dev-api.shrimpy.io/v1/exchanges/binance/candles?quoteTradingSymbol=USDT&baseTradingSymbol=$coinPair&interval=$interval');
  //   candleList = [];
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://dev-api.shrimpy.io/v1/exchanges/binance/candles?quoteTradingSymbol=USDT&baseTradingSymbol=$coinPair&interval=$interval'),
  //     headers: {HttpHeaders.authorizationHeader: ''},
  //   );
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

  // convertDate() async {
  //   for (int index = 0; index < 2709; index ++) {
  //     var abc = candleList[index].x;
  //     var date = DateTime.fromMillisecondsSinceEpoch(abc * 1000);
  //     dynamic d24 = DateFormat('dd/MM/yyyy').format(date);
  //     dateList.add(d24);
  //   }
  //   //print(dateList);
  // }

// https://finnhub.io/api/v1/crypto/candle?symbol=BINANCE:BTCUSDT&resolution=D&from=1572651390&to=1575243390&token=cajmn4aad3icpj9q4t8g
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin[widget.index].name + '/USDT'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: Container(
                height: 100,
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.coin[widget.index].price.toString(),
                          style: TextStyle(
                            color:
                                widget.coin[widget.index].change.toDouble() < 0
                                    ? Colors.red
                                    : Colors.green,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "≈${widget.coin[widget.index].price.toString()} USD",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.coin[widget.index].changePercentage
                                          .toDouble() <
                                      0
                                  ? widget.coin[widget.index].changePercentage
                                          .toDouble()
                                          .toStringAsFixed(2) +
                                      '%'
                                  : '+' +
                                      widget.coin[widget.index].changePercentage
                                          .toDouble()
                                          .toStringAsFixed(2) +
                                      '%',
                              style: TextStyle(
                                color: widget
                                            .coin[widget.index].changePercentage
                                            .toDouble() <
                                        0
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('24hHigh  ' +
                            widget.coin[widget.index].high24.toString()),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '24hLow  ' +
                              widget.coin[widget.index].low24.toString(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '24hTurnover  ' +
                              formatNum
                                  .format(widget.coin[widget.index].turnover24),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 20),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         '24h High ',
                    //         textAlign: TextAlign.left,
                    //       ),
                    //       Text(
                    //         '24h Low ',
                    //         textAlign: TextAlign.left,
                    //       ),
                    //       Text(
                    //         '24h Turnover ',
                    //         textAlign: TextAlign.left,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 20),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     children: [
                    //       Text(
                    //         widget.coin[widget.index].high24.toString(),
                    //         textAlign: TextAlign.left,
                    //       ),
                    //       Text(
                    //         widget.coin[widget.index].low24.toString(),
                    //         textAlign: TextAlign.left,
                    //       ),
                    //       Text(
                    //         widget.coin[widget.index].turnover24.toString(),
                    //         textAlign: TextAlign.left,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildInterval(context, '1m', '1m'),
                buildInterval(context, '5m', '5m'),
                buildInterval(context, '15m', '15m'),
                buildInterval(context, '1h', '1h'),
                buildInterval(context, '6h', '6h'),
                buildInterval(context, '1d', '1d'),
              ],
            ),
            Container(height: 320, child: buildChart()),
            SizedBox(
              height: 10,
            ),
            rsi == true
                ? Container(
                    height: 120,
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat.yMd(),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        intervalType: DateTimeIntervalType.auto,
                      ),
                      primaryYAxis: NumericAxis(
                        maximum: 100,
                        minimum: 0,
                      ),
                      crosshairBehavior: CrosshairBehavior(
                        enable: true,
                      ),
                      trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.singleTap,
                          tooltipSettings: InteractiveTooltip(
                            enable: true,
                          )),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                        //enableMouseWheelZooming: true,
                        enablePinching: true,
                      ),
                      backgroundColor: Colors.black,
                      legend: Legend(isVisible: true),
                      indicators: <TechnicalIndicators<Candles, dynamic>>[
                        RsiIndicator<Candles, DateTime>(
                          upperLineColor: Colors.red,
                          lowerLineColor: Colors.red,
                          seriesName: "abcd",
                          period: 3,
                          overbought: 70,
                          oversold: 30,
                        ),
                      ],
                      series: <ChartSeries>[
                        CandleSeries<Candles, DateTime>(
                          name: "abcd",
                          dataSource: candleList,
                          xValueMapper: (Candles c, _) => c.x,
                          lowValueMapper: (Candles c, _) => c.low1,
                          highValueMapper: (Candles c, _) => c.high1,
                          openValueMapper: (Candles c, _) => c.open1,
                          closeValueMapper: (Candles c, _) => c.close1,
                        )
                      ],
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildIndicator(context, 'Bolling'),
                rsiIndicator(context, 'RSI'),
                // buildIndicator(context, '', intervals),
                // buildIndicator(context, '', intervals),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // List<Candles> createChartData(List<Candle> candles) {
  //   List<Candles> candleData = [];
  //   candles.forEach((candle) {
  //     final c = Candles(
  //       x: DateTime.parse(candle.time!),
  //       open1: double.parse(candle.candleItem!.open1),
  //       high1: double.parse(candle.candleItem!.high1),
  //       low1: double.parse(candle.candleItem!.low1),
  //       close1: double.parse(candle.candleItem!.close1),
  //     );
  //     candleData.add(c);
  //   });
  //   return candleData;
  // }

  Widget buildChart() {
    return SfCartesianChart(
      // plotAreaBackgroundColor: Colors.black,
      crosshairBehavior: CrosshairBehavior(
        enable: true,
      ),
      trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(
            enable: true,
          )),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        //enableMouseWheelZooming: true,
        enablePinching: true,
      ),
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.yMd(),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.auto,
      ),
      primaryYAxis: NumericAxis(
        minimum: widget.coin[widget.index].atl * 0.9,
        maximum: widget.coin[widget.index].ath * 1.15,
        interval: 6,
      ),
      indicators: <TechnicalIndicators<Candles, dynamic>>[
        bolling == true
            ? BollingerBandIndicator<Candles, dynamic>(
                period: 10,
                seriesName: "abc",
              )
            : BollingerBandIndicator(),
        // macd == true
        //     ? MacdIndicator<Candles, dynamic>(
        //         period: 10,
        //         seriesName: "abc",
        //       )
        //     : BollingerBandIndicator(),
      ],
      series: <ChartSeries>[
        CandleSeries<Candles, DateTime>(
          name: "abc",
          dataSource: candleList,
          xValueMapper: (Candles c, _) => c.x,
          lowValueMapper: (Candles c, _) => c.low1,
          highValueMapper: (Candles c, _) => c.high1,
          openValueMapper: (Candles c, _) => c.open1,
          closeValueMapper: (Candles c, _) => c.close1,
        )
      ],
    );
  }

  Widget buildInterval(BuildContext context, String title, intervals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: () {
          setState(
            () {
              interv = intervals;
              // context.read<CandlesBloc>()
              //   ..add(
              //     CandlesEventStated(widget.coin[widget.index].symbol, interv),
              //   );
              coinRepo.getCandleData1(widget.coin[widget.index].symbol, interv);
            },
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
          decoration: BoxDecoration(
              border: Border.all(
                color: (interv == intervals) ? Colors.black54 : Colors.white,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: () {
          setState(
            () {
              bolling == false ? bolling = true : bolling = false;
            },
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 6, top: 6),
          decoration: BoxDecoration(
              border: Border.all(
                color: (bolling == true) ? Colors.black54 : Colors.white,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }

  Widget rsiIndicator(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: () {
          setState(
            () {
              rsi == false ? rsi = true : rsi = false;
            },
          );
        },
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 6, top: 6),
          decoration: BoxDecoration(
              border: Border.all(
                color: (rsi == true) ? Colors.black54 : Colors.white,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
          child: Center(
            child: Text(title),
          ),
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
