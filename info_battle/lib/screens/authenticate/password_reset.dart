// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/services/auth.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/constants.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = 'none';

  bool loading = false;

  // text field state
  String email = '';

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
            'Reset password',
            style: GoogleFonts.balooDa2(
              color: textColor,
              fontSize: deviceWidth / 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                  SizedBox(height: 20.0),
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
                    validator: (val) => val!.isEmpty
                        ? 'Enter an email'
                        : error != 'none'
                            ? error
                            : null,
                    onChanged: (val) {
                      setState(() => email = val.trim());
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
                        'Reset Password',
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
                          dynamic result = await _auth.resetPassword(email);
                          if (result == null) {
                            setState(() {
                              error = 'No account exists with that adress';
                              loading = false;
                            });
                          } else {
                            setState(() {
                              error = 'clear';
                              loading = false;
                            });
                          }
                        }
                      }),
                  error == 'clear'
                      ? Container(
                          margin: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: formColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Text(
                              'We\'ve sent you a reset link to your email adress',
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
                  error != 'clear'
                      ? SizedBox(height: deviceHeight / 2.3)
                      : SizedBox(height: deviceHeight / 4),
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
