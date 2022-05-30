// ignore_for_file: prefer_const_constructors
//@dart = 2.9
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:info_battle/models/user_data.dart';
import 'package:info_battle/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/loading.dart';
import 'profile_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String _currentName;
  String _currentImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool pressedButton = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
                resizeToAvoidBottomInset: false,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: textColor,
                  ),
                  elevation: 10.0,
                  backgroundColor: buttonIdleColor,
                ),
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
                      image: homeImage,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth / 6,
                            vertical: deviceHeight / 9.8),
                        physics: BouncingScrollPhysics(),
                        children: [
                          ProfileWidget(
                            imagePath: _currentImageUrl ?? userData.imagePath,
                            isEdit: true,
                            onClicked: () async {
                              _selectPhoto(userData.uid);
                            },
                          ),
                          SizedBox(height: deviceHeight / 50),
                          TextFormField(
                            style: GoogleFonts.balooDa2(
                                color: textColor,
                                fontSize: deviceWidth / 23,
                                fontWeight: FontWeight.bold),
                            initialValue: userData.name,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceWidth / 28,
                                ),
                                filled: true,
                                fillColor: formColor,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: buttonActiveColor,
                                    width: 4.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: buttonIdleColor,
                                    width: 4.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                            validator: (val) =>
                                val.isEmpty ? 'Please enter a nickname' : null,
                            onChanged: (val) =>
                                setState(() => _currentName = val.trim()),
                          ),
                          SizedBox(height: deviceHeight / 50),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: buttonIdleColor,
                                onPrimary: buttonActiveColor,
                                shadowColor: buttonshadowColor,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                minimumSize:
                                    Size(deviceWidth / 1.7, deviceHeight / 14),
                              ),
                              child: Text(
                                'Update',
                                style: GoogleFonts.balooDa2(
                                    color: textColor,
                                    fontSize: deviceWidth / 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(
                                          _currentName ?? userData.name,
                                          _currentImageUrl ??
                                              userData.imagePath,
                                          userData.email);
                                }
                                setState(() {
                                  pressedButton = true;
                                });
                              }),
                          SizedBox(
                            height: deviceHeight / 50,
                          ),
                          if (pressedButton)
                            Center(
                              child: Text(
                                'Profile updated!',
                                style: GoogleFonts.balooDa2(
                                    color: textColor,
                                    fontSize: deviceWidth / 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }

  Future _selectPhoto(String userID) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
            onClosing: () {},
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.camera, userID);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.filter),
                      title: Text('Pick a file'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.gallery, userID);
                      },
                    ),
                  ],
                )));
  }

  Future _pickImage(ImageSource source, String userID) async {
    final pickedFile = await _picker.pickImage(
        source: source, imageQuality: 50); //picture compressed by 50%
    if (pickedFile == null) return;

    var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));

    if (file == null) return;

    await _uploadFile(file.path, userID);
  }

  _uploadFile(String path, String userID) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${userID}_${DateTime.now().toIso8601String()}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      _currentImageUrl = fileUrl;
    });
  }
}
