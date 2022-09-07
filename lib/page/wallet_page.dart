import 'dart:async';
import 'dart:convert';

import 'package:crypto_app/google_signup_provider.dart';
import 'package:crypto_app/locator.dart';
import 'package:crypto_app/model/news.dart';
import 'package:crypto_app/repo.dart';
import 'package:crypto_app/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  CoinRepo coinRepo = s1<CoinRepo>();
  late final PageController pageController;
  int page = 0;
  Timer? carasouelTimer;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   //coinRepo.fetchNews();
  //   pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  //   carasouelTimer = timer();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   pageController.dispose();
  //   super.dispose();
  // }

  // Timer timer() {
  //   return Timer.periodic(Duration(seconds: 3), (timer) {
  //     if (page == 4) {
  //       page = 0;
  //     }
  //     pageController.animateToPage(page,
  //         duration: Duration(seconds: 1), curve: Curves.easeInOutCirc);
  //     page++;
  //   });
  // }

  Future<List<New>> getNews() async {
    final news = await http.get(
        'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=CRYPTO:BTC&topics=blockchain&apikey=233fae3a7amsh105b58bae6d1fddp1d6c86jsn28c980dab593');
    // final List response = jsonDecode(news.body);
    // return response.map((e) => New.fromJson(e)).toList();
    final Map<String, dynamic> response = jsonDecode(news.body);
    final List newlist = New.fromJson(response) as List;
    return newsList1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 250,
        //   child: FutureBuilder<List<New>>(
        //       future: getNews(),
        //       builder: (context, snapshot) {
        //         if (!snapshot.hasData) {
        //           return Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         }
        //         final data = snapshot.data;
        //         return PageView.builder(
        //             controller: pageController,
        //             onPageChanged: (index) {
        //               page = index;
        //               setState(() {});
        //             },
        //             itemCount: 5,
        //             itemBuilder: (_, index) {
        //               return AnimatedBuilder(
        //                 animation: pageController,
        //                 builder: (context, child) {
        //                   return child!;
        //                 },
        //                 child: GestureDetector(
        //                   onPanDown: (d) {
        //                     carasouelTimer?.cancel();
        //                     carasouelTimer = null;
        //                   },
        //                   onPanCancel: () {
        //                     carasouelTimer = timer();
        //                   },
        //                   child: Container(
        //                     child: Text(data![0].feed![index].title ?? ""),
        //                     margin: const EdgeInsets.all(12),
        //                     height: 200,
        //                     decoration: BoxDecoration(
        //                       color: Theme.of(context).shadowColor,
        //                       borderRadius: BorderRadius.circular(5),
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             });
        //       }),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: List.generate(
        //         5,
        //         (index) => Container(
        //               margin: EdgeInsets.all(2),
        //               child: Icon(
        //                 Icons.circle,
        //                 size: 12,
        //                 color: page == index
        //                     ? Theme.of(context).accentColor
        //                     : Theme.of(context).shadowColor,
        //               ),
        //             ))),
        SizedBox(
          height: 60,
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  FirebaseAuth.instance.currentUser.email,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 150,),
              Consumer<ThemeProvider>(
                builder: (context, provider, child) {
                  return SwitchListTile(
                    title: Text('Color Theme'),
                    value: provider.darkTheme,
                    onChanged: (value) {
                      provider.toggleTheme();
                    },
                    activeColor: Colors.yellow,
                    inactiveThumbImage: AssetImage("assets/images/sunny.png"),
                    activeThumbImage: AssetImage("assets/images/half-moon.png"),
                  );
                },
              ),
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    // final provider =
                    //     Provider.of<GoogleSignup>(context, listen: false);
                    // provider.logout();
                  },
                  child: Text('Logout')),
            ],
          ),
        ),
      ],
    );
  }
}
