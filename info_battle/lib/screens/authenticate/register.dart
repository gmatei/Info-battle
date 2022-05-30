// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_battle/services/auth.dart';
import 'package:info_battle/utils/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
            'Sign up to Info Battle',
            style: GoogleFonts.balooDa2(
              color: textColor,
              fontSize: deviceWidth / 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.switch_account_rounded, color: textColor),
              label: Text(
                'Sign In',
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
                        'Sign Up',
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
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
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
// Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//         Container(
//           height: 510,
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 45),
//                 userInput(emailController, 'Email', TextInputType.emailAddress),
//                 userInput(passwordController, 'Password', TextInputType.visiblePassword),
//             Container(
//               height: 55,
//               // for an exact replicate, remove the padding.
//               // pour une réplique exact, enlever le padding.
//               padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
//               child: RaisedButton(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                 color: Colors.indigo.shade800,
//                 onPressed: () {
//                   print(emailController);
//                   print(passwordController);
//                   Provider.of<Auth>(context, listen: false).signup(emailController.text, passwordController.text);
//                   Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SuccessfulScreen()));
//                 },
//                 child: Text('Sign up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),),
//                 ),
//               ),
//                 SizedBox(height: 20),