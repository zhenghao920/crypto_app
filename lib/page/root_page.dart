import 'package:crypto_app/page/home_page.dart';
import 'package:crypto_app/page/login_page.dart';
import 'package:crypto_app/theme/color.dart';
import 'package:crypto_app/page/wallet_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final items = <Widget>[
    Icon(
      Icons.home_outlined,
      size: 25,
      //color: Colors.black,
    ),
    Icon(
      Icons.account_balance_wallet_outlined,
      size: 25,
      //color: Colors.black,
    ),
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
        // StreamBuilder(
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     } else if (snapshot.hasData) {
        //       return screen[pageIndex];
        //     } else if (snapshot.hasError) {
        //       return Center(
        //         child: Text('Error'),
        //       );
        //     } else
        //       return SignUpPage();
        //   },
        //   stream: FirebaseAuth.instance.authStateChanges(),
        // ),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.transparent,
          height: 60,
          backgroundColor: Colors.transparent,
          items: items,
          index: pageIndex,
          onTap: (index) => setState(() => this.pageIndex = index),
        ));
  }

  // Widget getBody() {
  //   return IndexedStack(
  //     index: pageIndex,
  //     children: [
  //       HomePage(),
  //       WalletPage(),
  //     ],
  //   );
  // }

  // Widget getFooter() {
  //   return Container();
  // }
}
