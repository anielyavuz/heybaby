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
import 'package:lottie/lottie.dart';

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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService _authService = AuthService();
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;
  bool _shouldFetchUserData = true;
  bool _isActivitiesExpanded = true;
  bool _AIStatus = false;
  int selectedWeek = 4;
  String _response = "";
  List<String> drawerItems = [
    'Bildirim 1',
    'Bildirim 2',
    'Bildirim 3',
    'Bildirim 4',
    // İhtiyacınıza göre diğer öğeleri ekleyin
  ];

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
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
    // 'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f',
  ];

  Offset _floatingActionButtonOffset =
      Offset(320.0, 600.0); // Default sağ alt köşe, 100 px yukarıda

  @override
  Widget build(BuildContext context) {
    if (userData == null || _shouldFetchUserData) {
      _fetchUserData();
      _systemData();
    }

    return Scaffold(
        key: _scaffoldKey, // GlobalKey'i Scaffold'a ekleyin

        // appBar: AppBar(
        //   // title: Text('Uygulama Başlığı'),
        //   actions: [
        //     IconButton(
        //       icon:
        //           Icon(Icons.notifications), // İstediğiniz ikonu buraya ekleyin
        //       onPressed: () {
        //         // EndDrawer'ı açmak için onPressed fonksiyonunu buraya ekleyin
        //         _scaffoldKey.currentState!.openEndDrawer();
        //       },
        //     ),
        //   ],
        // ),
        // endDrawer: Drawer(
        //   // Drawer içeriğini buraya ekleyin
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: [
        //       Container(
        //         height: 150,
        //         child: DrawerHeader(
        //           child: Text('Bildirimler'), // Drawer başlığını buraya ekleyin
        //           decoration: BoxDecoration(
        //             color: Colors.blue,
        //           ),
        //         ),
        //       ),
        //       SingleChildScrollView(
        //         child: Column(
        //           children: drawerItems
        //               .map((item) => ListTile(
        //                     title: Text(item),
        //                     onTap: () {
        //                       // Drawer öğesine tıklandığında yapılacak işlemi buraya ekleyin
        //                     },
        //                   ))
        //               .toList(),
        //         ),
        //       ),
        //       // İhtiyacınıza göre diğer drawer öğelerini buraya ekleyin
        //     ],
        //   ),
        // ),

        body: SafeArea(
          child: Stack(
            children: [
              _buildBody(),
              Positioned(
                left: _floatingActionButtonOffset.dx,
                top: _floatingActionButtonOffset.dy,
                child: _AIStatus
                    ? Draggable(
                        feedback: FloatingActionButton(
                          onPressed: () {},
                          child: Container(
                            width: 66.0, // Genişlik ayarı
                            height: 66.0, // Yükseklik ayarı
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Lottie.asset(
                                // "https://assets5.lottiefiles.com/private_files/lf30_ijwulw45.json"
                                "assets/lottie/robotWelcome.json",
                                fit: BoxFit.fill),
                          ),
                        ),
                        childWhenDragging: Container(),
                        onDragEnd: (details) {
                          setState(() {
                            // Ekran boyutlarını al
                            final RenderBox renderBox =
                                context.findRenderObject() as RenderBox;
                            final Size screenSize = renderBox.size;

                            // FloatingActionButton boyutlarını al
                            final double fabWidth = 56.0;
                            final double fabHeight = 56.0;

                            // Yeni konumun sınırlar içinde kalmasını sağla
                            double newX = details.offset.dx;
                            double newY = details.offset.dy;

                            // Sağ-sol sınırları
                            if (newX < 0) newX = 0;
                            if (newX + fabWidth > screenSize.width)
                              newX = screenSize.width - fabWidth;

                            // Alt-üst sınırları (ekranın 1/4'ünden fazla gitmesin)
                            double minY = screenSize.height * 0.05;
                            double maxY = screenSize.height * 0.75 - fabHeight;
                            if (newY < minY) newY = minY;
                            if (newY > maxY) newY = maxY;

                            _floatingActionButtonOffset = Offset(newX, newY);
                          });
                        },
                        child: FloatingActionButton(
                          onPressed: () {
                            // _aiQuestion("Hava nasıl?");
                            _showChatModalBottomSheet(context);
                          },
                          child: Container(
                            width: 56.0, // Genişlik ayarı
                            height: 56.0, // Yükseklik ayarı
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Lottie.asset(
                                // "https://assets5.lottiefiles.com/private_files/lf30_ijwulw45.json"
                                "assets/lottie/robotWelcome.json",
                                fit: BoxFit.fill),
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
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
              label: 'Aktiviteler',
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
        ));
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _systemData();
    }
    // print(index);
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
        return KesfetPage(stories: storyImages);

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
        selectedWeek = (((DateTime.now()
                    .difference(DateTime.parse(userData?['sonAdetTarihi'])))
                .inDays) ~/
            7);
      });
    }
  }

  Future<void> _systemData() async {
    Map<String, dynamic>? data = await FirestoreFunctions.getSystemData();
    if (data != null) {
      // print(data);
      setState(() {
        _AIStatus = data['AIBot']['Enable'];
        storyImages = data['Stories'];
        storyImages.sort((a, b) => b['id'].compareTo(a['id']));

        // print(storyImages);
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
