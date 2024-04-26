import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/chatgptService.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/functions/notificationController.dart';
import 'package:heybaby/functions/notificationSender.dart';
import 'package:heybaby/pages/anasayfa.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:heybaby/pages/hesapSayfasi.dart';
import 'package:heybaby/pages/kesfetPage.dart';
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
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    // TODO: implement initState
    super.initState();
  }

  AuthService _authService = AuthService();
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;
  bool _shouldFetchUserData = true;
  bool _isActivitiesExpanded = true;
  bool _AIStatus = false;

  List storyImages = [
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
  ];

  @override
  Widget build(BuildContext context) {
    if (userData == null || _shouldFetchUserData) {
      _fetchUserData();
      _systemData();
    }

    return Scaffold(
        body: SafeArea(child: _buildBody()),
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
              icon: Icon(Icons.explore),
              label: 'Keşfet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: 'Günlük',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Hesap',
            ),
          ],
        ),
        floatingActionButton: _AIStatus
            ? FloatingActionButton(
                onPressed: () async {
                  // BildirimTakip().bildirimKur();
                  // NotificationSetup.scheduleWeeklyNotification(1);
                  // AwesomeNotifications().createNotification(
                  //   content: NotificationContent(
                  //       id: 1,
                  //       channelKey: "basic_channel",
                  //       title: "Title",
                  //       body: "This is a body"),
                  // );
                  _showChatModalBottomSheet(context);
                },
                child: Container(
                  width: 56.0, // Genişlik ayarı
                  height: 56.0, // Yükseklik ayarı
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/aiChatBotIcon2.jpg?alt=media&token=9b56d1e4-bb29-431d-bdc3-d9a4b880562c',
                      ),
                      fit: BoxFit
                          .fill, // Resmi butona tam olarak dolduracak şekilde ayarla
                    ),
                  ),
                ),
              )
            : SizedBox());
  }

  void _onItemTapped(int index) {
    _fetchUserData();
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return storyImages.length == 0
            ? CircularProgressIndicator()
            : AnaSayfa(storyImages: storyImages, userData: userData);

      case 1:
        return Calendar(userData: userData);

      case 2:
        return KesfetPage();

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

  Future<void> _systemData() async {
    Map<String, dynamic>? data = await FirestoreFunctions.getSystemData();
    if (data != null) {
      print(data);
      setState(() {
        _AIStatus = data['AIBot']['Enable'];
        storyImages = data['Stories'];
        print(storyImages);
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
