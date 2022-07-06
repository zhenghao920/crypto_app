import 'package:crypto_app/theme/color.dart';
import 'package:crypto_app/pages/home_page.dart';
import 'package:crypto_app/page/wallet_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final items = <Widget>[
    Icon(Icons.home_outlined, size: 25),
    Icon(Icons.account_balance_wallet_outlined, size: 25),
  ];

  final screen = [
    HomePage(),
    WalletPage(),
  ];

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screen[pageIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          items: items,
          index: pageIndex,
          onTap: (index) => setState(() => this.pageIndex = index),
        ));
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: [
        HomePage(),
        WalletPage(),
      ],
    );
  }

  Widget getFooter() {
    return Container();
  }
}
