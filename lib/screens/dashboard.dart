import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern_task/models/firebase_storage.dart';
import 'package:intern_task/screens/post.dart';
import 'package:intern_task/utilities/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key, this.uID}) : super(key: key);
  final String uID;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _titleTEC = new TextEditingController();
  final _textTEC = new TextEditingController();
  bool _showSpinner = false;
  String photoUrl;
  String text;
  String title;
  String newUserID;
  final ImagePicker _imagePicker = ImagePicker();
  var pickedImage;
  UploadTask task;
  String imagePath;
  final _auth = FirebaseAuth.instance;
  User currentUser;
  // void getUser() async {
  //   if (_auth != null) {
  //     currentUser = _auth.currentUser;
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getUser();
  // }

  Widget _titleEntry() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Title',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: _titleTEC,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSaved: (String value) {
              title = value;
            },
            validator: (String value) {
              if (value.isEmpty) {
                return '*is required';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _textEntry() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Text',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: _textTEC,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter text...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSaved: (String value) {
              text = value;
            },
            validator: (String value) {
              if (value.isEmpty) {
                return '*is required';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _addPhotoButton() {
    return InkWell(
      onTap: () async {
        try {
          final XFile image =
              await _imagePicker.pickImage(source: ImageSource.gallery);

          setState(() {
            if (image != null) {
              imagePath = image.path;
              pickedImage = XFile(imagePath);
              print(json.encode(imagePath));
              print('filePath....');
            }

            setState(() {
              _showSpinner = true;
            });
            if (pickedImage != null) {
              File file = File(pickedImage.path);

              final destination = 'files/verify_images/${pickedImage.path}';

              task = FirebaseApi.uploadFile(destination, file);
            }
          });
          if (task != null) {
            final snapshot = await task.whenComplete(() {});
            final urlDownload = await snapshot.ref.getDownloadURL();
            photoUrl = urlDownload;
            print('Download-Link: $urlDownload');

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HomeScreen(),
            //   ),
            // );
            setState(() {
              _showSpinner = false;
            });
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          '+ Add Photo',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _createPostButton() {
    return InkWell(
      onTap: () async {
        final db = await FirebaseFirestore.instance
            .collection('users')
            .doc()
            .collection('posDetails')
            .add({
          'Title': _titleTEC.text,
          'Text': _textTEC.text,
          'PhotoUrl': photoUrl
        }).then((value) => print(value.id));
        // .doc(newUserID)
        // .set({'Title': title, 'Text': text, 'PhotoUrl': photoUrl});

        // Future<String> get_data(DocumentReference doc_ref) async {
        //   DocumentSnapshot docSnap = await doc_ref.get();
        //   var doc_id2 = docSnap.reference.id;
        //   return doc_id2;
        // }

        // String id = await get_data(doc_ref);

        // print('.......id......$get_data');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: kbgLinearGradient,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          'Create post',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Post'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _titleEntry(),
            SizedBox(
              height: 20,
            ),
            _textEntry(),
            SizedBox(
              height: 30,
            ),
            _addPhotoButton(),
            SizedBox(
              height: 60,
            ),
            _createPostButton(),
          ],
        ),
      ),
    );
  }
}
