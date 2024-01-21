import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/chatgptService.dart';
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
  AuthService _authService = AuthService();
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;
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
    if (userData == null || _shouldFetchUserData) {
      _fetchUserData();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 94, 221),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showChatModalBottomSheet(context);
        },
        child: FaIcon(FontAwesomeIcons.question),
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

  void _showChatModalBottomSheet(BuildContext context) {
    TextEditingController _chatController = TextEditingController();
    List<String> chatHistory = [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat with ChatGPT',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatHistory.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(chatHistory[index]),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          decoration: InputDecoration(
                            hintText: 'Soru sor...',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          String userQuestion = _chatController.text;
                          setState(() {
                            chatHistory.add('Siz: $userQuestion');
                          });

                          // ChatGPTService'i kullanarak soruyu gönderip cevabı al
                          String chatGPTResponse =
                              await ChatGPTService.sendQuestion(userQuestion);

                          setState(() {
                            chatHistory.add(chatGPTResponse);
                          });

                          _chatController.clear();
                        },
                        child: Text('Gönder'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
