import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern_task/screens/home.dart';
import 'package:intern_task/screens/sign_up.dart';
import 'package:intern_task/utilities/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailTEC = new TextEditingController();
  final _passTEC = new TextEditingController();
  bool _passwordVisible;
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
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
                Icons.phone_android_outlined,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSaved: (String value) {
              //
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

  Widget _enterPassField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter password',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
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

  Widget _signInButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          _showSpinner = true;
        });
        try {
          final user = await _auth.signInWithEmailAndPassword(
              email: _emailTEC.text, password: _passTEC.text);
          if (user != null) {
            String id = user.user.uid;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
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
          'Sign in',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _signUpAccount() {
    return InkWell(
      onTap: () {
        // log in screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(),
          ),
        );
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign up',
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(gradient: kbgLinearGradient),
            height: height,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Intern Task',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                _emailEntry(),
                SizedBox(
                  height: 20,
                ),
                _enterPassField(),
                SizedBox(
                  height: 40,
                ),
                _signInButton(),
                SizedBox(
                  height: height * 0.17,
                ),
                Align(
                    alignment: Alignment.bottomCenter, child: _signUpAccount()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
