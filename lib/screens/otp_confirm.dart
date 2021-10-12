import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intern_task/screens/home.dart';
import 'package:intern_task/utilities/constants.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class OtpConfirm extends StatefulWidget {
  const OtpConfirm({Key key, this.phoneNumber, this.verificationID})
      : super(key: key);
  final String phoneNumber;
  final String verificationID;

  @override
  _OtpConfirmState createState() => _OtpConfirmState();
}

class _OtpConfirmState extends State<OtpConfirm> {
  final _auth = FirebaseAuth.instance;

  final _oneTEC = new TextEditingController();
  final _twoTEC = new TextEditingController();
  final _threeTEC = new TextEditingController();
  final _fourTEC = new TextEditingController();
  final _fiveTEC = new TextEditingController();
  final _sixTEC = new TextEditingController();
  bool _showSpinner = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      _showSpinner = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        _showSpinner = false;
      });

      if (authCredential?.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showSpinner = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        // back function
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: ShaderMask(
          shaderCallback: (bounds) => kLinearGradient.createShader(bounds),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _applyButton() {
    return InkWell(
      onTap: () async {
        //
        setState(() {
          _showSpinner = true;
        });
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: widget.verificationID,
            smsCode:
                '${_oneTEC.text}${_twoTEC.text}${_threeTEC.text}${_fourTEC.text}${_fiveTEC.text}${_sixTEC.text}');
        print(widget.verificationID);

        signInWithPhoneAuthCredential(phoneAuthCredential);
        // print(phoneAuthCredential);
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
          'Apply',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _otpEntry() {
    return Container(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _oneTEC,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8.0),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    fillColor: Color(0xfff4f4f4),
                    filled: true),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _twoTEC,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8.0),
                    fillColor: Color(0xfff4f4f4),
                    filled: true),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _threeTEC,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8.0),
                    fillColor: Color(0xfff4f4f4),
                    filled: true),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _fourTEC,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8.0),
                    fillColor: Color(0xfff4f4f4),
                    filled: true),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _fiveTEC,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8.0),
                    fillColor: Color(0xfff4f4f4),
                    filled: true),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _sixTEC,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(8.0),
                    fillColor: Color(0xfff4f4f4),
                    filled: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: kbgLinearGradient,
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Intern Task',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  'Please enter the text that we have sent to',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                Text(
                  '${widget.phoneNumber}',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                SizedBox(
                  height: 10,
                ),
                _otpEntry(),
                SizedBox(
                  height: 40,
                ),
                _applyButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
