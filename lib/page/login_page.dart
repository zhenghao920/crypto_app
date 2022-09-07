import 'package:crypto_app/google_signup_provider.dart';
import 'package:crypto_app/page/email_signup_page.dart';
import 'package:crypto_app/page/reset_password_page.dart';
import 'package:crypto_app/page/root_page.dart';
import 'package:crypto_app/page/signup_page.dart';
import 'package:crypto_app/theme/theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  bool showPassword = false;
  bool isEmail = false;
  final firebase = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    // TabController _tabController = TabController(
    //   vsync: this,
    //   length: 2,
    // );
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          // Container(
          //   padding: const EdgeInsets.only(left: 16),
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     'Welcome',
          //     style: TextStyle(
          //       fontSize: 30,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          Container(
            width: double.maxFinite,
            height: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => EmailSignUpPage()));
                    },
                    child: Container(
                      height: 20,
                      width: 100,
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 5),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     setState(() {
                      //       isEmail == false ? isEmail = true : isEmail = false;
                      //     });
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: Theme.of(context).accentColor),
                      //         borderRadius: BorderRadius.circular(3)),
                      //     height: 45,
                      //     width: 40,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Icon(isEmail
                      //             ? Icons.email_outlined
                      //             : Icons.phone_android_outlined)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                              )
                            ],
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (email) => email != null &&
                                        !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    border: InputBorder.none),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value != null && value.length < 6
                                      ? 'Required at least 6 characters'
                                      : null,
                              controller: passWordController,
                              obscureText: showPassword == false ? true : false,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showPassword == false
                                  ? showPassword = true
                                  : showPassword = false;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  showPassword == false ? "SHOW" : "HIDE",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ResetPasswordPage()));
                    },
                    child: Container(
                      height: 20,
                      width: 170,
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Forgot password",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                    height: 120,
                    child: Column(
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () async {
                              try {
                                await firebase.signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passWordController.text.trim());
                              } on FirebaseAuthException catch (e) {
                                // Fluttertoast.showToast(
                                //     msg: "Error: ${e.message}",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.CENTER,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor: Colors.red,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('Warning!'),
                                          content: Text(e.message.toString()),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Ok')),
                                          ],
                                        ));
                              }
                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(
                              //         builder: (context) => RootPage()));
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).accentColor),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  minimumSize: Size(250, 50)),
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              icon: FaIcon(
                FontAwesomeIcons.phoneAlt,
              ),
              label: Text('Continue with Phone Number')),
          SizedBox(height: 10),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  minimumSize: Size(250, 50)),
              onPressed: () async {
                try {
                  final provider =
                      Provider.of<GoogleSignup>(context, listen: false);
                  await provider.googleSignup();
                } on FirebaseAuthException catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Warning!'),
                            content: Text(e.message.toString()),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Ok')),
                            ],
                          ));
                }
              },
              icon: FaIcon(
                FontAwesomeIcons.google,
              ),
              label: Text('Continue with Google')),
        ],
      ),
    );
  }
}
