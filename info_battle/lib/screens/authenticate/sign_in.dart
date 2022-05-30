// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String error = '';

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
              left: deviceWidth / 6,
              right: deviceWidth / 6,
              top: deviceHeight / 7),
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: backgroundImage,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val.trim());
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val!.length < 6
                        ? 'Enter a password 6+ characters long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 40.0),
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
                  SizedBox(height: deviceHeight / 2.7),
                  InkWell(
                      child: Text(
                        'Goanță Matei - Cosmin © 2022',
                        style: GoogleFonts.balooDa2(
                          color: textColor,
                          fontSize: deviceWidth / 26,
                        ),
                      ),
                      onTap: () => launchUrlString(
                          'https://www.facebook.com/mateicosmin.goanta'))
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
