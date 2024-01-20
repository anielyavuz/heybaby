import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybaby/pages/homePage.dart';
import 'package:heybaby/pages/loginPage.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool _login = false;
  late User _user;
  rootControl() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        // print('User is signed in!');
        if (this.mounted) {
          setState(() {
            _login = true;
          });
        }
      }
      if (user != null) {
        if (this.mounted) {
          setState(() {
            _user = user!;
          });
        }
      }
    });
  }

  @override
  void initState() {
    rootControl();

    //LOGOYU BELLİ SURE GOSTEREN KOD BURASIYDI YORUMA ALINDI
//     Future.delayed(const Duration(milliseconds: 1500), () {
// // Here you can write your code
//     });
    // rootControl();
  }

  @override
  Widget build(BuildContext context) {
    return (_login) ? MyHomePage() : IntroPage();
  }
}
