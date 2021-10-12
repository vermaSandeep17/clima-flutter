import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Name: Sandeep'),
              SizedBox(
                height: 10,
              ),
              Text('Email: email'),
              SizedBox(
                height: 10,
              ),
              Text('mobil: 8459346994')
            ],
          ),
        ),
      ),
    );
  }
}
