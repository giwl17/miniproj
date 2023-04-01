import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproj/forgetpass.dart';
import 'package:miniproj/login.dart';
import 'package:miniproj/register.dart';
import 'package:miniproj/foodlist.dart';
import 'package:miniproj/shopOwnDetail.dart';
import 'package:provider/provider.dart';
import 'package:miniproj/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProviderMaps()..getUserLocation()),
        // ChangeNotifierProvider(create: (_) => Send())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(title: 'เข้าสู่ระบบ'),
          '/register': (context) => const RegisterPage(),
          '/forget': (context) => const ForgetPassPage(),
          '/foodlist': (context) => const FoodListPage(),
        },
      ),
    );
  }
}
