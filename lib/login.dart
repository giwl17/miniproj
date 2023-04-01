import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproj/forgetpass.dart';
import 'package:miniproj/register.dart';
import 'package:miniproj/foodlist.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formstate = GlobalKey<FormState>();
  String? email;
  String? password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(255, 244, 43, 29),
            Color.fromARGB(255, 255, 82, 73)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formstate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 39),
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: GoogleFonts.kanit(
                                  textStyle: TextStyle(fontSize: 48.0)),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          buildTextFieldEmail(),
                          SizedBox(
                            height: 12.0,
                          ),
                          buildTextFieldPass(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              registerInkWell(context),
                              forgetInkWell(context)
                            ],
                          ),
                          SizedBox(height: 20.0),
                          loginButton(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell forgetInkWell(BuildContext context) {
    return InkWell(
      child: Text(
        'ลืมรหัสผ่าน',
        style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18.0)),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/forget');
      },
    );
  }

  InkWell registerInkWell(BuildContext context) {
    return InkWell(
      child: Text(
        'สมัครสมาชิก',
        style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18.0)),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/register');
      },
    );
  }

  Padding loginButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
            ),
            backgroundColor: Colors.green,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'เข้าสู่ระบบ',
              style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 20.0)),
            ),
          ),
          onPressed: () async {
            await btLogin_Click();
          },
        ),
      ),
    );
  }

  Future<void> btLogin_Click() async {
    if (_formstate.currentState!.validate()) {
      print('Valid Form');

      _formstate.currentState!.save();

      try {
        print('Can login');
        await auth.signInWithEmailAndPassword(
            email: email!, password: password!);
        print('Login: ${auth.currentUser?.email} success');
        Navigator.pushReplacementNamed(context, '/foodlist');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          final snackBar = const SnackBar(
            content: Text('ไม่พบอีเมล กรุณาใส่ใหม่อีกครั้ง'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          final snackBar = const SnackBar(
            content: Text('รหัสผ่านผิด กรุณาใส่ใหม่อีกครั้ง'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } else {
      print('Invalid Form');
      final snackBar = const SnackBar(
        content: Text('กรุณากรอกอีเมลและรหัสผ่านให้ถูกต้อง'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget buildTextFieldPass() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        onSaved: (value) {
          password = value!.trim();
        },
        validator: (value) {
          if (value!.length < 8) {
            return 'Please Enter more than 8 Character';
          } else {
            return null;
          }
        },
        obscureText: true,
        keyboardType: TextInputType.text,
        style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18.0)),
        decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            hintText: 'รหัสผ่าน'),
      ),
    );
  }

  Widget buildTextFieldEmail() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        email = value!.trim();
      },
      validator: (value) {
        if (!validateEmail(value!)) {
          return 'โปรดกรอกอีเมล';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.kanit(textStyle: TextStyle(fontSize: 18.0)),
      decoration: const InputDecoration(
        errorStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        hintText: 'อีเมล',
      ),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return (!regex.hasMatch(value)) ? false : true;
  }
}
