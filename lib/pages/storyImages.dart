import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/functions/ad_helper.dart';
import 'package:heybaby/pages/subpages/kesfetMakale.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heybaby/pages/subpages/makaleDetay.dart';

class StoryScreen extends StatefulWidget {
  final List storyies;
  // final List storyImages;
  final int startingPage;
  final bool referansAktif;
  final List referansList;
  Map<String, dynamic>? userData;

  StoryScreen(
      {required this.storyies,
      // required this.storyImages,
      required this.startingPage,
      required this.referansAktif,
      required this.referansList,
      required this.userData});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _animationController;
  int _waitingTime =
      5; // Her bir fotoğrafın ekranda kalma süresi saniye cinsinden
  Timer? _timer;
  bool _isTouching = false;
  Map _data = {};
  Future<void> _getData() async {
    // print(widget.storyImages);
    String data = await rootBundle.loadString('assets/kesfetMakale.json');
    Map<String, dynamic> jsonResult = json.decode(data);
    setState(() {
      for (var key in jsonResult['Makaleler'].keys.toList()) {
        // print(key);
        // print(jsonResult['Makaleler'][key]);
        for (var key2 in jsonResult['Makaleler'][key]) {
          // print(key2['id']);
          _data[key2['id']] = {
            'baslik': key2['baslik'],
            'icerik': key2['icerik']
          };
        }
      }
      // print(_data);
      // print(jsonResult['Makaleler'].keys.toList());
    });
  }

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
    _getData();
    // print("Baslangic story no: " + widget.startingPage.toString());
    super.initState();
    _pageController = PageController(initialPage: widget.startingPage);
    setState(() {
      _currentIndex = widget.startingPage;
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _waitingTime),
    );

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isTouching) {
        _nextImage();
        _animationController.reset();
        _animationController.forward();
      }
    });

    _animationController.forward();

    // Timer'ı başlat
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isTouching) {
        // print(_animationController.value);
      }
    });

    if (_interstitialAd == null) {
      print(
          "Storyimage page: Reklam değeri null, yeni reklam oluşabilir. yetkilerine bakılacak");

      if (widget.userData!['userSubscription'] == 'Free') {
        {
          print("free user reklam oluşuruluyor");
          _loadInterstitialAd();
        }
      }
    }
  }

  reklamGoster() async {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print('Reklam yüklenmedi veya gösterilemedi.');
      _loadInterstitialAd();
    }
  }

  void _nextImage() {
    if (_currentIndex < widget.storyies.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Story Images
          GestureDetector(
            onVerticalDragEnd: (details) {
              Navigator.pop(context);
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 0) {
                // Sağa doğru dokunma, önceki resme geç
                _previousImage();
              } else {
                // Sola doğru dokunma, sonraki resme geç
                _nextImage();
              }
            },
            onTapDown: (TapDownDetails details) {
              //ekranın sağına dokununca sonraki resme soluna dokununca önceki resme geçen kod, kapatıldı çünkü uzun basma ile sorun yaşanıyordu
              // double screenWidth = MediaQuery.of(context).size.width;
              // if (details.globalPosition.dx > screenWidth / 2) {
              //   // Sağ tarafa dokunma, sonraki resme geç
              //   _nextImage();
              // } else {
              //   // Sol tarafa dokunma, önceki resme geç
              //   _previousImage();
              // }
              //ekranın sağına dokununca sonraki resme soluna dokununca önceki resme geçen kod, kapatıldı çünkü uzun basma ile sorun yaşanıyordu
              setState(() {
                _isTouching = true;
              });
              _animationController.stop();
            },
            onTapUp: (TapUpDetails details) {
              setState(() {
                _isTouching = false;
              });
              _animationController.forward();
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.storyies.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _animationController.reset();
                _animationController.forward();
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context)
                          .size
                          .width, // Ekran genişliği kadar
                      height: MediaQuery.of(context)
                          .size
                          .height, // Ekran yüksekliği kadar
                      child: Image.network(
                        widget.storyies[index]['imageLink'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom:
                          25, // İstenilen boşluk miktarını ayarlayabilirsiniz
                      child: GestureDetector(
                        onTap: () async {
                          _timer?.cancel();

                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MakaleDetay(
                                      baslik: widget.storyies[index]['baslik'],
                                      icerik: widget.storyies[index]['icerik']
                                          .toString()
                                          .replaceAll('%', '\n'),
                                      resimURL: widget.storyies[index]
                                          ['imageLink'],
                                      referansAktif: widget.referansAktif,
                                      referansList: widget.referansList,
                                      isMakalePremium: widget.storyies[index]
                                          ['premium'],
                                      isUserPremium: widget.userData![
                                                  'userSubscription'] ==
                                              "Free"
                                          ? false
                                          : true,
                                    )),
                          ).then((value) {
                            // Timer'ı iptal et
                          });

                          // if (!widget.storyies[index]['premium']) {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => MakaleDetay(
                          //               baslik: widget.storyies[index]
                          //                   ['baslik'],
                          //               icerik: widget.storyies[index]['icerik']
                          //                   .toString()
                          //                   .replaceAll('%', '\n'),
                          //               resimURL: widget.storyies[index]
                          //                   ['imageLink'],
                          //               referansAktif: widget.referansAktif,
                          //               referansList: widget.referansList,
                          //               userData: widget.userData,
                          //             )),
                          //   ).then((value) {
                          //     // Timer'ı iptal et
                          //   });
                          // } else {
                          //   if (widget.userData!['userSubscription'] !=
                          //       "Free") {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => MakaleDetay(
                          //                 baslik: widget.storyies[index]
                          //                     ['baslik'],
                          //                 icerik: widget.storyies[index]
                          //                         ['icerik']
                          //                     .toString()
                          //                     .replaceAll('%', '\n'),
                          //                 resimURL: widget.storyies[index]
                          //                     ['imageLink'],
                          //                 referansAktif: widget.referansAktif,
                          //                 referansList: widget.referansList,
                          //                 userData: widget.userData,
                          //               )),
                          //     ).then((value) {
                          //       // Timer'ı iptal et
                          //     });
                          //   } else {
                          //     await reklamGoster();

                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => MakaleDetay(
                          //                 baslik: widget.storyies[index]
                          //                     ['baslik'],
                          //                 icerik: widget.storyies[index]
                          //                         ['icerik']
                          //                     .toString()
                          //                     .replaceAll('%', '\n'),
                          //                 resimURL: widget.storyies[index]
                          //                     ['imageLink'],
                          //                 referansAktif: widget.referansAktif,
                          //                 referansList: widget.referansList,
                          //                 userData: widget.userData,
                          //               )),
                          //     ).then((value) {
                          //       // Timer'ı iptal et
                          //     });
                          //   }
                          // }
                        },
                        child: Container(
                          // alignment: Alignment.center,

                          width: MediaQuery.of(context).size.width /
                              3, // Yarısı kadar genişlik
                          height: 60, // Butonun yüksekliği
                          margin: EdgeInsets.symmetric(
                              horizontal: 90), // Butonun kenarlardan boşluğu
                          decoration: BoxDecoration(
                            color: Colors.white, // Butonun arkaplan rengi
                            borderRadius: BorderRadius.circular(
                                80), // Butonun kenar yuvarlaklığı
                          ),
                          child: !widget.storyies[index]['premium']
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      size: 35,
                                      Icons.link,
                                      color: Color.fromARGB(255, 167, 0, 244),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .storyDetayliBilgi,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 54, 9, 75)),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      size: 35,
                                      Icons.link,
                                      color: Color.fromARGB(255, 255, 193,
                                          7), // Daha sıcak sarı tonu
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .storyDetayliBilgi,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 54, 9, 75)),
                                        ),
                                        Text(
                                          "Premium💎",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Color.fromARGB(
                                                  255, 168, 60, 187)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Progress Bar
          Positioned(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            child: LinearProgressIndicator(
              value: _animationController.value,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          // Close Button
          Positioned(
            top: 40.0,
            right: 16.0,
            child: IconButton(
              icon: Icon(Icons.close),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Timer'ı iptal et
    _timer?.cancel();

    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
