import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/chatgptService.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/functions/heybabyai.dart';
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
  FocusNode _focusNode = FocusNode();
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    // FocusNode'a bir listener ekleyin
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          modalHeight = 0.85;
        });
        print("Klavye açıldı ve TextFormField'a odaklanıldı. $modalHeight");
      } else {
        setState(() {
          modalHeight = 0.85;
        });
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Kaynakları serbest bırakın
    _focusNode.dispose();
    super.dispose();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService _authService = AuthService();
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;
  bool _shouldFetchUserData = true;
  bool _isActivitiesExpanded = true;
  bool _AIStatus = false;
  late int selectedWeek = -1;
  late int _myToken;
  String _response = "";
  String dropdownValue = "One";
  List<String> drawerItems = [
    'Bildirim 1',
    'Bildirim 2',
    'Bildirim 3',
    'Bildirim 4',
    // İhtiyacınıza göre diğer öğeleri ekleyin
  ];
  List<String> chatHistory = [
    // 'Siz: hamilelik kaç hafta sürer?',
    // 'HeyBaby AI: Hamilelik ortalama 40 hafta sürer, ancak 38 ile 42 hafta arasında doğan bebekler de sağlıklı kabul edilir.'
  ];
  List _aiChatHistory = [];

  List storyImages = [];

  List storyImages2 = []; //ilgili haftanın story makaleleri
  List storyImages3 = []; //tüm haftaların story makaleleri

  Offset _floatingActionButtonOffset =
      Offset(320.0, 600.0); // Default sağ alt köşe, 100 px yukarıda

  String _apiKey = "";
  String _model = "";

  String _systemInstruction = "";
  double modalHeight = 0.85;
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
                              fit: BoxFit.fitHeight),
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
                          final double fabWidth = 70.0;
                          final double fabHeight = 70.0;

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
                      child: Container(
                        width: 70,
                        height: 70,
                        child: FloatingActionButton(
                          onPressed: () {
                            // _aiQuestion("Hava nasıl?");
                            _showChatModalBottomSheet(context);
                          },
                          child: Container(
                            width: 70.0, // Genişlik ayarı
                            height: 70.0, // Yükseklik ayarı
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Lottie.asset(
                                // "https://assets5.lottiefiles.com/private_files/lf30_ijwulw45.json"
                                "assets/lottie/robotWelcome.json",
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GNav(
        // rippleColor: Colors.grey[300]!,
        // hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: Color.fromARGB(255, 93, 46, 141),
        iconSize: 24,
        padding: EdgeInsets.fromLTRB(15, 20, 15, 30),
        duration: Duration(milliseconds: 400),
        // tabBackgroundColor: Colors.grey[100]!,
        color: const Color.fromARGB(255, 64, 64, 64),
        tabs: [
          GButton(
            icon: (Icons.home),
            text: 'Ana Sayfa',
          ),
          GButton(
            icon: Icons.calendar_today,
            text: 'Aktiviteler',
          ),
          GButton(
            icon: Icons.explore,
            text: 'Keşfet',
          ),
          GButton(
            icon: Icons.note,
            text: 'Günlük',
          ),
          GButton(
            icon: Icons.account_circle,
            text: 'Hesap',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );

    // BottomNavigationBar(
    //   backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    //   selectedItemColor: Colors.deepPurple,
    //   unselectedItemColor: Colors.grey,
    //   currentIndex: _selectedIndex,
    //   onTap: _onItemTapped,
    //   items: [
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: 'Ana Sayfa',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.calendar_today),
    //       label: 'Aktiviteler',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.explore),
    //       label: 'Keşfet',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.note),
    //       label: 'Günlük',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.account_circle),
    //       label: 'Hesap',
    //     ),
    //   ],
    // ));
  }

  void _onItemTapped(int index) async {
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
        return selectedWeek == -1
            ? CircularProgressIndicator()
            : AnaSayfa(
                storyImages: storyImages,
                newstoryImages: storyImages2,
                userData: userData);

      case 1:
        return Calendar(userData: userData);

      case 2:
        return KesfetPage(
          stories: storyImages,
          storiesWeekly: storyImages3,
        );

      case 3:
        return NotlarPage(userData: userData);

      case 4:
        return Center(
          child: HesapSayfasi(
            userData: userData,
            onSignOutPressed: () async {
              _authService.signOut();
              await Future.delayed(Duration(milliseconds: 450));
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

        if (userData!.containsKey('aiBotLog')) {
          setState(() {
            chatHistory = [];
            _aiChatHistory = [];
            _aiChatHistory = userData?['aiBotLog'];

            for (var element in _aiChatHistory) {
              chatHistory.add('${element['user']}');
              chatHistory.add('HeyBaby AI: ${element['ai']}');
            }
          });
        }
        if (userData!.containsKey('myToken')) {
          _myToken = userData?['myToken'];
          print("MyToken değeri $_myToken");
        } else {
          print("MyToken değeri db'de yok güncelliyorum");
          _tokenGuncelle(50);
        }
      });
    }
  }

  Future<void> _tokenGuncelle(int myToken) async {
    var _result = await FirestoreFunctions.tokenSayiGuncelle(myToken);
  }

  Future<void> _systemData() async {
    await Future.delayed(Duration(milliseconds: 450));
    Map<String, dynamic>? data = await FirestoreFunctions.getSystemData();
    if (data != null) {
      // print(data);
      setState(() {
        storyImages = [];
        storyImages2 = [];
        storyImages3 = [];
        _AIStatus = data['AIBot']['Enable'];
        storyImages = data['Stories'];
        storyImages.shuffle(Random());

        var _tempStoryImages = data['weeklyStories'];
        print("selectedWeek değeri şuanda $selectedWeek");
        for (var _tempStoryImage in _tempStoryImages) {
          // print("hafta değeri şuanda ${_tempStoryImage['hafta']}");
          if (selectedWeek > 40) {
            if (_tempStoryImage['hafta'] == 40) {
              storyImages2.add(_tempStoryImage);
            }
          } else if (selectedWeek < 4) {
            if (_tempStoryImage['hafta'] == 4) {
              storyImages2.add(_tempStoryImage);
            }
          } else {
            if (_tempStoryImage['hafta'] == selectedWeek) {
              storyImages2.add(_tempStoryImage);
            }
          }

          storyImages3.add(_tempStoryImage);
        }
        // print("storyImages2 değeri $storyImages2");

        // storyImages = data['weeklyStories'];
        // storyImages.sort((a, b) => b['id'].compareTo(a['id']));

        _apiKey = data['AIBot']['apiKey'];
        _model = data['AIBot']['model'];

        _systemInstruction = data['AIBot']['systemInstruction'];
        // print(storyImages);
      });
    }
  }

  ScrollController _scrollController = ScrollController();

  void _showChatModalBottomSheet(BuildContext context) {
    TextEditingController _chatController = TextEditingController();

    bool isHeyBabyTyping = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Modalın klavye ile birlikte hareket etmesini sağlar
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
        final bottomInset =
            MediaQuery.of(context).viewInsets.bottom; // Klavyenin boyutunu alır
        return FractionallySizedBox(
          heightFactor: modalHeight, // Ekranın %75'ini kaplar
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom:
                        bottomInset), // Klavye boyutu kadar alttan boşluk bırakır
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Chat with HeyBaby AI',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: 46.0, // Genişlik ayarı
                                      height: 46.0, // Yükseklik ayarı
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Lottie.asset(
                                          // "https://assets5.lottiefiles.com/private_files/lf30_ijwulw45.json"
                                          "assets/lottie/robotWelcome.json",
                                          fit: BoxFit.fitWidth),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                icon: const Icon(Icons.more_vert),
                                style: const TextStyle(color: Colors.black),
                                onChanged: (value) => setState(() {
                                  dropdownValue = value!;
                                  print(dropdownValue);
                                  if (dropdownValue == "gecmisiSil") {
                                    setState(() {
                                      chatHistory = [];
                                      _aiChatHistory = [];
                                    });
                                    FirestoreFunctions.aiBotContentClear();
                                  }
                                  // Navigator.pop(context);
                                }),
                                items: const [
                                  DropdownMenuItem(
                                      value: "gecmisiSil",
                                      child: Text("Geçmişi Sil"),
                                      alignment: AlignmentDirectional.center),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: chatHistory.length,
                                itemBuilder: (context, index) {
                                  bool isHeyBabyAI = chatHistory[index]
                                      .startsWith('HeyBaby AI:');
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 6.0),
                                    child: Align(
                                      alignment: isHeyBabyAI
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isHeyBabyAI
                                              ? Color.fromARGB(255, 52, 49, 55)
                                              : Color.fromARGB(
                                                  255, 170, 72, 231),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        padding: const EdgeInsets.all(12.0),
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75),
                                        child: isHeyBabyAI
                                            ? Text(
                                                chatHistory[index]
                                                    .substring(12),
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                chatHistory[index],
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (isHeyBabyTyping)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 77, 77, 77),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.75),
                                    child: Text(
                                      "HeyBaby AI...",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Premium üyelik ile sınırsız Token hakkı için ",
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              print("premium login");
                            },
                            child: Text(
                              "TIKLAYIN.",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _chatController,
                              focusNode: _focusNode,
                              autofocus: true,
                              maxLines: null,
                              textInputAction: TextInputAction
                                  .done, // Klavyede 'Done' (Tamam) butonunu ayarlar
                              onFieldSubmitted: (value) {
                                // 'Done' butonuna basıldığında burası çalışır
                                print("Klavye kapatıldı ve form gönderildi.");
                                FocusScope.of(context)
                                    .unfocus(); // Klavyeyi kapat
                              },
                              decoration: InputDecoration(
                                hintText: 'Soru sor...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 60,
                            width: 60,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_chatController.text != "") {
                                    String userQuestion = _chatController.text;
                                    setState(() {
                                      chatHistory.add('$userQuestion');
                                      isHeyBabyTyping = true;
                                      _scrollToBottom();
                                    });

                                    _chatController.clear();
                                    // ChatGPTService'i kullanarak soruyu gönderip cevabı al
                                    String? _response = await heyBabyAI()
                                        .istekYap(userQuestion, _apiKey, _model,
                                            _systemInstruction, _aiChatHistory);

                                    setState(() {
                                      isHeyBabyTyping = false;
                                      chatHistory.add(
                                          'HeyBaby AI: ${_response.toString()}');
                                      _scrollToBottom();
                                    });

                                    var _aiLogInsert =
                                        await FirestoreFunctions.aiBotContent(
                                            userQuestion, _response!);

                                    Map _tempMap = {};
                                    _tempMap['user'] = userQuestion;
                                    _tempMap['ai'] = _response;
                                    _aiChatHistory.add(_tempMap);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Yuvarlak köşeler için büyük bir değer
                                  ),
                                ),
                                child: Icon(Icons.send, size: 30)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }
}
