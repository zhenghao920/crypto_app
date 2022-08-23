import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CoinCard extends StatelessWidget {
  CoinCard({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
  });

  String name;
  String symbol;
  String imageUrl;
  double price;
  double change;
  double changePercentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
          ],
        ),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(20), // Image radius
                    child: Image.network(imageUrl, fit: BoxFit.fitHeight),
                  ),
                )
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     borderRadius: BorderRadius.circular(20),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey,
                //         offset: Offset(4, 4),
                //         blurRadius: 10,
                //         spreadRadius: 1,
                //       ),
                //       BoxShadow(
                //         color: Colors.white,
                //         offset: Offset(-4, -4),
                //         blurRadius: 10,
                //         spreadRadius: 1,
                //       ),
                //     ],
                //   ),
                //   height: 60,
                //   width: 60,
                //   child: Padding(
                //     padding: const EdgeInsets.all(0),
                //     child: Image.network(imageUrl),
                //   ),
                // ),
                ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      symbol,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price.toDouble() <= 1
                        ? price.toDouble().toStringAsFixed(4)
                        : price.toDouble().toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        change.toDouble() < 0
                            ? change.toDouble().toStringAsFixed(2)
                            : '+' + change.toDouble().toStringAsFixed(2),
                        style: TextStyle(
                          color:
                              change.toDouble() < 0 ? Colors.red : Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        changePercentage.toDouble() < 0
                            ? changePercentage.toDouble().toStringAsFixed(2) +
                                '%'
                            : '+' +
                                changePercentage.toDouble().toStringAsFixed(2) +
                                '%',
                        style: TextStyle(
                          color: changePercentage.toDouble() < 0
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
            ),
          ],
        ),
      ),
    );
  }
}