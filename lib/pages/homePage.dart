import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/anasayfa.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:heybaby/pages/hesapSayfasi.dart';
import 'package:heybaby/pages/listelerPage.dart';
import 'package:heybaby/pages/loginPage.dart';
import 'package:heybaby/pages/notlarPage.dart';
import 'package:heybaby/pages/takvimPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthService _authService = AuthService(); // AuthService'ı tanımla
  int _selectedIndex = 0;
  Map<String, dynamic>? userData; // Veriyi burada tutuyoruz
  bool _shouldFetchUserData = true;

  List<String> storyImages = [
    'https://placekitten.com/100/100',
    'https://placekitten.com/101/100',
    'https://placekitten.com/102/100',
    'https://placekitten.com/103/100',
    'https://placekitten.com/104/100',
    'https://placekitten.com/105/100',
    'https://placekitten.com/106/100',
    'https://placekitten.com/107/100',
    'https://placekitten.com/108/100',
    'https://placekitten.com/109/100',
    'https://placekitten.com/110/100',
    'https://placekitten.com/111/100',
  ];

  @override
  Widget build(BuildContext context) {
    // Her build anında veriyi çekiyoruz
    // Her build anında veriyi çekiyoruz
    // Sadece userData null ise veya güncelleme gerçekleştiyse çağrı yapılır
    if (userData == null || _shouldFetchUserData) {
      _fetchUserData();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("HeyBaby"),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Takvim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Listeler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Hesap',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return AnaSayfa(storyImages: storyImages, userData: userData);

      case 1:
        return TakvimPage(userData: userData);

      case 2:
        return ListelerPage(userData: userData);

      case 3:
        return NotlarPage(userData: userData);

      case 4:
        return Center(
          child: HesapSayfasi(
            userData: userData,
            onSignOutPressed: () {
              _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CheckAuth()),
              );
            },
          ),
        );

      default:
        return Container();
    }
  }

  Future<void> _fetchUserData() async {
    Map<String, dynamic>? data = await FirestoreFunctions.getUserData();
    if (data != null) {
      setState(() {
        userData = data;
        _shouldFetchUserData = false;
      });
    }
  }

  // Güncelleme yapılması gerekip gerekmediğini kontrol etmek için bir metod
}
