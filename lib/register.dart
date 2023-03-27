import 'package:flutter/material.dart';
import 'package:miniproj/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'สมัครสมาชิก';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          title: const Text(appTitle, style: TextStyle(color: Colors.black)),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formstate = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

  final auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formstate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildTextFieldFname(),
          buildTextFieldLname(),
          buildTextFieldEmail(),
          buildTextFieldPass(),
          buildTextFieldRePass(),
          registerButton()
        ],
      ),
    );
  }

  ElevatedButton registerButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text(
        'สมัครสมาชิก',
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () async {
        print('Register new account');

        if (_formstate.currentState!.validate()) {
          print(email.text);
          print(password.text);

          Map<String, String> data = {
            'email': email.text.trim(),
            'name': fname.text.trim(),
            'lastname': lname.text.trim(),
          };

          //db.collection('users').add(data);
          db.collection('users').doc(email.text.trim().toString()).set(data);
        }
        try {
          final user =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password providede is too weak');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email');
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  Padding buildTextFieldRePass() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          hintText: 'ยืนยัน Password',
        ),
      ),
    );
  }

  Widget buildTextFieldPass() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: TextFormField(
        controller: password,
        validator: (value) {
          if (value!.length < 8) {
            return 'Please Enter more than 8 Character';
          } else {
            return null;
          }
        },
        obscureText: true,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          hintText: 'Password',
        ),
      ),
    );
  }

  Padding buildTextFieldEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: TextFormField(
        controller: email,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill in E-mail field';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          hintText: 'Email',
        ),
      ),
    );
  }

  Padding buildTextFieldLname() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: TextFormField(
        controller: lname,
        validator: (value) {
          if (value!.isEmpty) {
            return 'โปรดใส่นามสกุลของคุณ';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          hintText: 'นามสกุล',
        ),
      ),
    );
  }

  Padding buildTextFieldFname() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: TextFormField(
        controller: fname,
        validator: (value) {
          if (value!.isEmpty) {
            return 'โปรดใส่ชื่อของคุณ';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          errorStyle: TextStyle(
            color: Colors.white,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          hintText: 'ชื่อ',
        ),
      ),
    );
  }
}
