import 'package:crypto_app/page/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({Key? key}) : super(key: key);

  @override
  _EmailSignUpPageState createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  bool showPassword = false;
  bool showCPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, top: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30,
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Email", border: InputBorder.none),
                    ),
                  )),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordController,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Required at least 6 characters'
                                  : null,
                          // onChanged: (x) {
                          //   setState(() {
                          //     password = x.trim();
                          //   });
                          // },
                          obscureText: showPassword == false ? true : false,
                          decoration: InputDecoration(
                              hintText: "Password", border: InputBorder.none),
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
                                  fontSize: 15, fontWeight: FontWeight.bold),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: cPasswordController,
                          validator: (v) {
                            return v != passwordController.text
                                ? 'Not Match'
                                : null;
                          },
                          // onChanged: (x) {
                          //   setState(() {
                          //     password = x.trim();
                          //   });
                          // },
                          obscureText: showCPassword == false ? true : false,
                          decoration: InputDecoration(
                              hintText: "Confirm Password",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showCPassword == false
                              ? showCPassword = true
                              : showCPassword = false;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              showCPassword == false ? "SHOW" : "HIDE",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: InkWell(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: cPasswordController.text.trim());
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Success!'),
                              content: Text('Account created successfully'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                          (route) => false);
                                    },
                                    child: Text('Ok')),
                              ],
                            ));
                  } on FirebaseAuthException catch (e) {
                    await showDialog(
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
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Confirm",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
