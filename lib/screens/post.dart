import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Post'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Post'),
            SizedBox(
              height: 10,
            ),
            Text('Post text'),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.red,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
