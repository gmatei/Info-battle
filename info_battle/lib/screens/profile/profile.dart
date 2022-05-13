import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final Function toggleView;
  const Profile({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Info Battle'),
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Profile'),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ],
        ),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
    );
  }
}
