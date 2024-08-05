import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/functions/ad_helper.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MakaleDetay extends StatefulWidget {
  final String baslik;
  final String icerik;
  final String resimURL;
  final bool referansAktif;
  final List referansList;
  final bool isUserPremium;
  final bool isMakalePremium;

  MakaleDetay(
      {required this.baslik,
      required this.icerik,
      required this.resimURL,
      required this.referansAktif,
      required this.referansList,
      required this.isUserPremium,
      required this.isMakalePremium});

  @override
  State<MakaleDetay> createState() => _MakaleDetayState();
}

class _MakaleDetayState extends State<MakaleDetay> {
  late bool _reklamOlustur;
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

  reklamLogla() async {
    DateTime now = DateTime.now();

    // Formatters
    DateFormat timeFormatter = DateFormat('HH:mm');
    DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

    // Format the date and time
    String formattedTime = timeFormatter.format(now);
    String formattedDate = dateFormatter.format(now);

    // Combine the formatted date and time
    String formattedDateTime = '$formattedTime - $formattedDate';

    await FirestoreFunctions.reklamLogu("Makale Okundu", formattedDateTime);
  }

  reklamGoster() async {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      _loadInterstitialAd();
    }
  }

  void _reklamFunction() {
    if (_interstitialAd == null) {
      print(
          "KesfetMakale page: Reklam değeri null, yeni reklam oluşabilir. yetkilerine bakılacak");

      if (widget.isMakalePremium) {
        print("makale premium ");
        if (!widget.isUserPremium) {
          print("user free reklam oluşturulyuor.");
          _loadInterstitialAd();

          Future.delayed(const Duration(milliseconds: 5000), () async {
            await reklamGoster();
            reklamLogla();
            setState(() {
              _reklamOlustur = false;
            });
          });
        } else {
          print("user premium reklama gerek yok.");
        }
      } else {
        print("Bu makale premium değil");
      }
    } else {
      print("asdasd");
    }
  }

  @override
  void initState() {
    super.initState();

    print("Kesfetmakale alanı burası");
    _reklamFunction();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> links = [
      'https://www.example.com',
      'https://www.anotherexample.com',
      'https://www.yetanotherexample.com'
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.resimURL.startsWith("https")
                  ? Container(
                      height: 250,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.center,
                        image: new NetworkImage(widget.resimURL),
                      )),
                    )
                  : Image.asset(
                      widget.resimURL,
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              GestureDetector(
                onTap: () {
                  print("asdasd");
                },
                child: Text(
                  widget.baslik,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.icerik.toString(),
                style: TextStyle(fontSize: 18.0),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 25.0),
              Center(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.makaleBegendinizmi,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () async {
                            String userID =
                                FirebaseAuth.instance.currentUser!.uid;

                            var _sonuc =
                                await FirestoreFunctions.makaleGeriBildirim(
                                        userID,
                                        "Beğendi",
                                        DateFormat('hh:mm - dd-MM-yyyy')
                                            .format(DateTime.now()),
                                        widget.baslik)
                                    .whenComplete(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .hesapGeriBildirimBasarili,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 126, 52, 253),
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  margin: EdgeInsets.all(10),
                                ),
                              );
                            });
                            print("Beğendi");
                          },
                        ),
                        SizedBox(width: 20.0),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () async {
                            String userID =
                                FirebaseAuth.instance.currentUser!.uid;

                            var _sonuc =
                                await FirestoreFunctions.makaleGeriBildirim(
                                        userID,
                                        "Beğenmedi",
                                        DateFormat('hh:mm - dd-MM-yyyy')
                                            .format(DateTime.now()),
                                        widget.baslik)
                                    .whenComplete(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .hesapGeriBildirimBasarili,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 126, 52, 253),
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  margin: EdgeInsets.all(10),
                                ),
                              );
                            });

                            print("Beğenmedi");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.makaleSorumlulukReddi,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(158, 158, 158, 1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.makaleSorumlulukMetin,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    widget.referansAktif
                        ? Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.makaleReferans,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: widget.referansList.length * 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          158, 158, 158, 1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListView.builder(
                                  itemCount: widget.referansList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        "* " + widget.referansList[index],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
