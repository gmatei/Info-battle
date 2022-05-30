// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:info_battle/utils/constants.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 8.0),
      child: Center(
        child: Stack(
          children: [
            buildImage(),
            Positioned(
              bottom: 0,
              right: 4,
              child: buildEditIcon(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: transparentColor,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: deviceWidth / 1.8,
          height: deviceWidth / 1.8,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon() => buildCircle(
        color: Color.fromARGB(255, 229, 138, 73),
        all: 3.5,
        child: buildCircle(
          color: textColor,
          all: 10,
          child: Icon(
            isEdit ? Icons.add_a_photo_rounded : Icons.edit_rounded,
            color: Color.fromARGB(255, 229, 138, 73),
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
