import 'package:crypto_app/page/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;
  int screenState = 0;
  String? countryCode;
  bool showPassword = false;
  bool isEmail = false;
  String? otp;
  String? vID;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 20),
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP Sent!");
        vID = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout!");
      },
    );
  }

  Future<void> verifyOTP() async {
    // await FirebaseAuth.instance
    //     .signInWithCredential(
    //   PhoneAuthProvider.credential(
    //     verificationId: vID,
    //     smsCode: otp,
    //   ),
    // )
    await FirebaseAuth.instance.verifyPasswordResetCode(otp).whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        body: SizedBox(
          height: 330,
          width: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    height: 400,
                    width: double.infinity,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          screenState == 0 ? stateRegister() : stateOTP(),
                          GestureDetector(
                            onTap: () {
                              if (screenState == 0) {
                                if (phoneController.text.isEmpty) {
                                  showSnackBarText(
                                      "Phone number is still empty!");
                                } else {
                                  verifyPhone(
                                      countryCode! + phoneController.text);
                                }
                              } else {
                                if (otp!.length >= 6) {
                                  verifyOTP();
                                } else {
                                  showSnackBarText("Enter OTP correctly!");
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).accentColor),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                child: Text(
                                  "CONTINUE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 15),
          child: Text(
            'Continue with phone number',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
              //         border: Border.all(color: Theme.of(context).accentColor),
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
                      child: Container(
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
                      )),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 25,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.circular(3)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "BACK",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "We just sent a code to ",
              ),
              TextSpan(
                text: countryCode! + phoneController.text,
              ),
              TextSpan(
                text: "\nEnter the code here and we can continue!",
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              otp = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: Colors.blue,
            selectedColor: Colors.blue,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't receive the code? ",
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenState = 0;
                    });
                  },
                  child: Text(
                    "Resend",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget emailLogin() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'Enter a valid email'
          : null,
      onChanged: (x) {
        setState(() {
          email = x.trim();
        });
      },
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
