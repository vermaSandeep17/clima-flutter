import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern_task/screens/home.dart';
import 'package:intern_task/screens/otp_confirm.dart';
import 'package:intern_task/screens/sign_in.dart';
import 'package:intern_task/utilities/constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intern_task/models/firebase_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;
  String photoUrl;
  String name;
  String email;
  String phoneNumber;
  String pass;
  bool _passwordVisible;
  String userId;
  String verificationID;

  final _nameTEC = new TextEditingController();
  final _emailTEC = new TextEditingController();
  final _phoneTEC = new TextEditingController();
  final _passTEC = new TextEditingController();

  final scaffoldState = GlobalKey<ScaffoldState>();
  final ImagePicker _imagePicker = ImagePicker();
  var pickedImage;
  UploadTask task;
  String imagePath;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Widget _firstNameEntry() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'First Name',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          TextFormField(
            controller: _nameTEC,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter first name',
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onFieldSubmitted: (String value) {
              //
              name = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return '*is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _emailEntry() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          TextFormField(
            controller: _emailTEC,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter email',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSaved: (String value) {
              //
              email = value;
            },
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _newPhone() {
    return Container(
      child: Column(
        children: [
          Text(
            'Phone number',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          IntlPhoneField(
            validator: (value) {
              Pattern pattern = r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(value))
                return 'Please enter a number.';
              else
                return null;
            },
            autoValidate: true,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter phone number',
              prefixIcon: Icon(
                Icons.local_phone_outlined,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            initialCountryCode: 'US',
            onChanged: (phone) {
              phoneNumber = phone.completeNumber;
            },
          )
        ],
      ),
    );
  }

  Widget _createPassEntry() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create password',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          TextFormField(
            controller: _passTEC,
            cursorColor: Colors.black,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter password',
              suffixIcon: IconButton(
                icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSaved: (String value) {
              //
              pass = value;
            },
            validator: (value) {
              if (value.length < 8) {
                return 'Password must have atleast 8 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          _showSpinner = true;
        });

        try {
          if (_formKey.currentState.validate()) {
            final newUser = await _auth
                .createUserWithEmailAndPassword(
                    email: _emailTEC.text, password: _passTEC.text)
                .then((value) {
              FirebaseFirestore.instance
                  .collection('users')
                  .add({
                    'uid': userId,
                  })
                  .then((value) => userId = value.id)
                  .then((value) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .set({
                      'uid': userId,
                      'Name': _nameTEC.text,
                      'PhoneNumber': phoneNumber,
                      'Email': _emailTEC.text,
                      'Photo': photoUrl,
                    });
                  });
            }).then((value) async {
              await _auth.verifyPhoneNumber(
                  timeout: Duration(seconds: 120),
                  phoneNumber: phoneNumber,
                  verificationCompleted: (phoneAuthCredential) {},
                  verificationFailed: (verificationFailed) {
                    setState(() {
                      _showSpinner = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(verificationFailed.message),
                      ),
                    );
                  },
                  codeSent: (verificationId, resendingToken) {
                    setState(() {
                      verificationID = verificationId;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpConfirm(
                          phoneNumber: phoneNumber,
                          verificationID: verificationID,
                        ),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (value) {});
            });
          }
          setState(() {
            _showSpinner = false;
          });
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          'Sign up',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _confirmPassEntry() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm password',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          TextFormField(
            cursorColor: Colors.black,
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Enter password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSaved: (String value) {
              //
            },
            validator: (value) {
              if (_passTEC.text != value) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _loginAccount() {
    return InkWell(
      onTap: () {
        // log in screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign in',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          '+ Add Photo',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: kbgLinearGradient,
              ),
              height: height,
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      'Intern Task',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  _firstNameEntry(),
                  SizedBox(
                    height: 20,
                  ),
                  _emailEntry(),
                  SizedBox(
                    height: 20,
                  ),
                  _newPhone(),
                  SizedBox(
                    height: 20,
                  ),
                  _addPhotoButton(),
                  SizedBox(
                    height: 20,
                  ),
                  _createPassEntry(),
                  SizedBox(
                    height: 20,
                  ),
                  _confirmPassEntry(),
                  SizedBox(
                    height: 40,
                  ),
                  _signUpButton(),
                  _loginAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
