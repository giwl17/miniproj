import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproj/main.dart';

class ForgetPassPage extends StatelessWidget {
  const ForgetPassPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ลืมรหัสผ่าน',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyForgerPassPage(title: 'ลืมรหัสผ่าน'),
    );
  }
}

class MyForgerPassPage extends StatefulWidget {
  const MyForgerPassPage({super.key, required this.title});
  final String title;

  @override
  State<MyForgerPassPage> createState() => _MyForgerPassPageState();
}

class _MyForgerPassPageState extends State<MyForgerPassPage> {
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  "ลิ้งค์รีเซ็ตรหัสผ่านถูกส่งไปแล้วกรุณาเช็คที่ Email ของคุณ"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 500,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Icon(
                      Icons.abc_outlined,
                      size: 70.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Text('ลืมรหัสผ่าน', style: TextStyle(fontSize: 32)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text('ป้อน Email สำหรับการรีเซ็ตรหัสผ่าน',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Email for reset password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        passwordReset();
                      },
                      child: Text('รีเซ็ตรหัสผ่าน',
                          style: TextStyle(fontSize: 20)),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 5,
                  )),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
