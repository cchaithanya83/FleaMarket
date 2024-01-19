import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleamarket/screens/homescreen.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
    var auth=FirebaseAuth.instance;
  var islogin =false;

  loginstatus(){
    auth.authStateChanges().listen((User? user) {
      if(user!=null &&mounted){
        setState(() {
          islogin=true;
        });
      }
     });
  }
  @override
  void initState() {
    super.initState();

    loginstatus();
    Timer(
        const Duration(seconds: 3),
        () { islogin? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            )):Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDEEFFD),
      ),
      backgroundColor: const Color(0xFFDEEFFD),
      body: Center(
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              // applogoL5X (41:195)
              width: 72,
              height: 80.44,
              child: Image.asset(
                'images/app_logo.png',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset('images/FleaMarket.png'),
            const SizedBox(height: 10),
            Image.asset('images/A Campus Marketplace.png'),
            const SizedBox(
              height: 40,
            )
          ]),
        ),
      ),
    );
  }
}
