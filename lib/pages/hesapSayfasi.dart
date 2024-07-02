import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/functions/ad_helper.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/boxes.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/functions/person.dart';
import 'package:heybaby/pages/adminPages/storyPaylas.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:heybaby/pages/loginPage.dart';
import 'package:heybaby/pages/subpages/ayarlar.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HesapSayfasi extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback? onSignOutPressed;
  final VoidCallback? onSRegisterPressed;

  HesapSayfasi(
      {Key? key, this.userData, this.onSignOutPressed, this.onSRegisterPressed})
      : super(key: key);

  @override
  _HesapSayfasiState createState() => _HesapSayfasiState();
}

class _HesapSayfasiState extends State<HesapSayfasi> {
  AuthService _authService = AuthService();
  int _selectedStarIndex = -1;
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String lastPeriodDate = "";
  String dogumOnceSonra = "";
  String _version = 'Unknown';

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version}+${info.buildNumber}';
    });
  }

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Yeni reklam yükleme
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              print('Failed to show the ad: ${err.message}');
            },
          );
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    lastPeriodDate = widget.userData?['sonAdetTarihi'];
    dogumOnceSonra = widget.userData?['dogumOnceSonra'];
    _initPackageInfo();
    _loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: Text('Hesap Sayfası'),
      //     ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.userData?['photoURL'] ??
                    'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () async {
                  await AwesomeNotifications().cancelAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bütün bildirimler temizlendi !!!')),
                  );
                },
                child: Text(
                  widget.userData?['userName'] ?? 'Guest',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                widget.userData?['email'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.userData?['id'].substring(0, 3) +
                    '....' +
                    widget.userData?['id']
                        .substring(widget.userData?['id'].length - 3),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'App Version: $_version',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index <= _selectedStarIndex
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedStarIndex = index;
                      });
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 2,
              controller: noteController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Geri bildirim ve önerilerinizi bize yazın 😊',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Geri Bildirim Gönder'),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (noteController.text != "") {
                  var sonuc = await FirestoreFunctions.sendFeedBack(
                      widget.userData?['userName'] ?? 'Guest',
                      _selectedStarIndex + 1,
                      noteController.text,
                      DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now())
                          .toString());
                  print(sonuc);

                  if (sonuc['status']) {
                    noteController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Geri bildirim başarılı olarak iletildi.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color.fromARGB(
                            255, 126, 52, 253), // Snackbar arka plan rengi
                        duration:
                            Duration(seconds: 3), // Snackbar gösterim süresi
                        behavior:
                            SnackBarBehavior.floating, // Snackbar davranışı
                        shape: RoundedRectangleBorder(
                          // Snackbar şekli
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4, // Snackbar yükseltilmesi
                        margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          sonuc['value'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color.fromARGB(
                            255, 126, 52, 253), // Snackbar arka plan rengi
                        duration:
                            Duration(seconds: 3), // Snackbar gösterim süresi
                        behavior:
                            SnackBarBehavior.floating, // Snackbar davranışı
                        shape: RoundedRectangleBorder(
                          // Snackbar şekli
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4, // Snackbar yükseltilmesi
                        margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Lütfen geri bildirim göndermek için bir kaç kelime yazın.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Color.fromARGB(
                          255, 126, 52, 253), // Snackbar arka plan rengi
                      duration:
                          Duration(seconds: 3), // Snackbar gösterim süresi
                      behavior: SnackBarBehavior.floating, // Snackbar davranışı
                      shape: RoundedRectangleBorder(
                        // Snackbar şekli
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4, // Snackbar yükseltilmesi
                      margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 66),
            if (widget.userData!['userSubscription'] == "Admin") ...[
              ElevatedButton(
                child: Text('Admin Features'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: Text("Admin Features")),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return StoryPaylasPage();
                                }));
                              },
                              child: Text("Story Paylaş"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // if (_interstitialAd != null) {
                                //   _interstitialAd!.show();
                                // } else {
                                //   print(
                                //       'Reklam yüklenmedi veya gösterilemedi.');
                                //   _loadInterstitialAd();
                                // }
                                boxPersons.put('currentToken',
                                    Person(token: 40, subnName: 'myToken'));
                              },
                              child: Text("Test Button"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 14),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SettingsPage(userData: widget.userData);
                }));
              },
              child: Text("Ayarlar"),
            ),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: () async {
                bool? confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          Text('Bu işlemi yapmak istediğinize emin misiniz?'),
                      content: Text(
                          'İşleme devam ederseniz bütün verileriniz silinecek.'),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Text('Hayır'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            SizedBox(
                                width:
                                    16), // Butonlar arasında biraz boşluk bırakmak için
                            TextButton(
                              child: Text('Evet'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  var sonuc = await FirestoreFunctions.verileriTemizleveCik();
                  if (sonuc.containsKey('status') && sonuc['status']) {
                    _authService.signOut();
                    await Future.delayed(Duration(milliseconds: 450));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CheckAuth()),
                    );
                  }
                }
              },
              child: Text("Verileri temizle ve uygulamadan çık."),
            ),
            SizedBox(height: 14),
            widget.userData?['userName'] != "Guest"
                ? ElevatedButton(
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Çıkış yapmak istediğinize emin misiniz?',
                              textAlign: TextAlign.center,
                            ),
                            // content: Text(
                            //     'Bu işlemi yapmak istediğinize emin misiniz?'),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                    child: Text('Hayır'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  SizedBox(
                                      width:
                                          16), // Butonlar arasında biraz boşluk bırakmak için
                                  TextButton(
                                    child: Text('Evet'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        widget.onSignOutPressed!();
                      }
                    },
                    child: Text("Çıkış Yap"),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                                  userData: widget.userData,
                                  lastPeriodDate: lastPeriodDate,
                                  dogumOnceSonra: dogumOnceSonra,
                                )),
                      );
                    },
                    child: Text("Hesap Oluştur"),
                  ),
          ],
        ),
      ),
    );
  }
}
