// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/screens/authenticate/password_reset.dart';
import 'package:info_battle/services/auth.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = 'none';

  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: transparentColor,
          elevation: 0.0,
          title: Text(
            'Sign in to Info Battle',
            style: GoogleFonts.balooDa2(
              color: textColor,
              fontSize: deviceWidth / 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.switch_account_rounded,
                color: textColor,
              ),
              label: Text(
                'Sign up',
                style: GoogleFonts.balooDa2(
                  color: textColor,
                  fontSize: deviceWidth / 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => widget.toggleView(),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(
              left: deviceWidth / 7.5,
              right: deviceWidth / 7.5,
              top: deviceHeight / 7),
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: backgroundImage,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: deviceHeight / 50),
                  TextFormField(
                    decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white54,
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: buttonActiveColor,
                            width: 4.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: buttonIdleColor,
                            width: 4.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    style: TextStyle(fontSize: 18),
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val.trim());
                    },
                  ),
                  SizedBox(height: deviceHeight / 45),
                  TextFormField(
                    decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white54,
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: buttonActiveColor,
                            width: 4.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: buttonIdleColor,
                            width: 4.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    style: TextStyle(fontSize: 18),
                    obscureText: true,
                    validator: (val) => val!.length < 6
                        ? 'Enter a password 6+ characters long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: deviceHeight / 25),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: buttonIdleColor,
                        onPrimary: buttonActiveColor,
                        shadowColor: buttonshadowColor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minimumSize: Size(150, 50),
                      ),
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error =
                                  'Could not sign in with those credentials';
                              loading = false;
                            });
                          }
                        }
                      }),
                  error != 'none'
                      ? SizedBox(
                          height: deviceHeight / 40,
                        )
                      : SizedBox(
                          height: 0.0,
                        ),
                  error != 'none'
                      ? Container(
                          margin: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: formColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 13),
                            child: Text(
                              error,
                              style: GoogleFonts.balooDa2(
                                  color: textColor,
                                  fontSize: deviceWidth / 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  error != 'none'
                      ? SizedBox(
                          height: deviceHeight / 100,
                        )
                      : SizedBox(
                          height: deviceHeight / 6,
                        ),
                  InkWell(
                      child: Text(
                        'I forgot my password... :(',
                        style: GoogleFonts.balooDa2(
                          color: buttonActiveColor,
                          fontSize: deviceWidth / 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PasswordReset()),
                          )),
                  error != 'none'
                      ? SizedBox(
                          height: deviceHeight / 17,
                        )
                      : SizedBox(
                          height: deviceHeight / 7.5,
                        ),
                  InkWell(
                      child: Text(
                        'Goanță Matei - Cosmin © 2022',
                        style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 26,
                        ),
                      ),
                      onTap: () => launchUrlString(
                          'https://www.facebook.com/mateicosmin.goanta')),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                      child: Text(
                        'Contact: infobattle.team@gmail.com',
                        style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 26,
                        ),
                      ),
                      onTap: () =>
                          launchUrlString('mailto:infobattle.team@gmail.com'))
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
