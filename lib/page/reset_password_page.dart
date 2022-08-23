import 'package:crypto_app/page/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isEmail = false;
  String? countryCode;

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
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isEmail == false ? isEmail = true : isEmail = false;
                  });
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
                        isEmail ? "Switch to Email" : "Switch to Mobile",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 7,
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
                    child: isEmail ? phoneLogin() : emailLogin()),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: InkWell(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text.trim());
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Success!'),
                              content: Text('Password reset link have sent to your email, open the link to set new password.'),
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
                      border: Border.all(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
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

  Widget emailLogin() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'Enter a valid email'
          : null,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: "Email", border: InputBorder.none),
    );
  }

  Widget phoneLogin() {
    return Container(
      child: Stack(
        children: [
          InternationalPhoneNumberInput(
            initialValue: PhoneNumber(isoCode: 'MY'),
            inputDecoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Phone Number",
            ),
            autoValidateMode: AutovalidateMode.disabled,
            onInputChanged: (value) {
              setState(() {
                countryCode = value.dialCode;
              });
            },
            textFieldController: phoneController,
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
          ),
        ],
      ),
    );
  }
}
