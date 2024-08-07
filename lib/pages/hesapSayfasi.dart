import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/functions/ad_helper.dart';
import 'package:heybaby/functions/authFunctions.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/boxes.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/functions/person.dart';
import 'package:heybaby/pages/adminPages/adminFunctions.dart';
import 'package:heybaby/pages/adminPages/storyPaylas.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:heybaby/pages/loginPage.dart';
import 'package:heybaby/pages/subpages/ayarlar.dart';
import 'package:heybaby/revenuecat/constant.dart';
import 'package:heybaby/revenuecat/paywall.dart';
import 'package:heybaby/revenuecat/purchaseApi.dart';
import 'package:heybaby/revenuecat/utils.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart'; // RevenueCat paketini ekleyin

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
  bool _isLoading = false;
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

  Future<void> _premiumOl() async {
    // await Purchases.setLogLevel(LogLevel.debug);
    // print("Purchases log level set to debug.");

    // PurchasesConfiguration? configuration;

    // if (Platform.isAndroid) {
    //   print("Platform is Android.");
    //   // Android için yapılandırma ekleyin
    // } else if (Platform.isIOS) {
    //   print("Platform is iOS.");
    //   configuration =
    //       PurchasesConfiguration("appl_vFGFjyUkszfdkFPjiszIoVgsvVG");
    //   print("PurchasesConfiguration created for iOS.");
    //   await Purchases.configure(configuration);
    // }

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.activeSubscriptions.isNotEmpty) {
        String activeSubscription = customerInfo.activeSubscriptions.first;
        print("User has an active subscription: $activeSubscription");

        // Abonelik paketinin detaylarını alın
        List<EntitlementInfo> entitlements =
            customerInfo.entitlements.all.values.toList();
        for (EntitlementInfo entitlement in entitlements) {
          print(
              "Entitlement ID: ${entitlement.identifier}, isActive: ${entitlement.isActive}");
        }
      } else {
        print("User does not have an active subscription.");
        await _paymentUI();
      }
    } catch (e) {
      print("Failed to get customer info: $e");
    }

    // if (configuration != null) {
    //   try {
    //     print("Configuring Purchases...");
    //     await Purchases.configure(configuration);
    //     print("Purchases configured successfully.");
    //     await _paymentUI();
    //   } catch (e) {
    //     print("Error during Purchases configuration: $e");
    //   }
    // } else {
    //   print("Ödeme configuration null");
    // }
  }

  Future<void> _paymentUI() async {
    try {
      final paywallResult =
          await RevenueCatUI.presentPaywallIfNeeded("premium");
      print('Paywall result: $paywallResult');
    } catch (e) {
      print("Error during presenting paywall: $e");
    }
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
                    'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/Leonardo_Diffusion_XL_A_baby_cartoon_in_the_womb_make_its_age_2.jpg?alt=media&token=f1a7f0dc-b9b5-46e7-891f-ca4a76c78712'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () async {
                  // await AwesomeNotifications().cancelAll();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Bütün bildirimler temizlendi !!!')),
                  // );
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
                hintText: AppLocalizations.of(context)!.hesapGeriBildirimYaz,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child:
                  Text(AppLocalizations.of(context)!.hesapGeriBildirimGonder),
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
                          AppLocalizations.of(context)!
                              .hesapGeriBildirimBasarili,
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
                        AppLocalizations.of(context)!
                            .hesapGeriBildirimKelimeYaz,
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
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AdminFunctions();
                  }));

                  // _premiumOl();
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
              child: Text(AppLocalizations.of(context)!.hesapAyarlar),
            ),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: () async {
                bool? confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                          AppLocalizations.of(context)!.hesapCikisEminMisin),
                      content:
                          Text(AppLocalizations.of(context)!.hesapDevamEmin),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Text(
                                  AppLocalizations.of(context)!.hesapHayir),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            SizedBox(
                                width:
                                    16), // Butonlar arasında biraz boşluk bırakmak için
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.black),
                                ),
                              ),
                              child:
                                  Text(AppLocalizations.of(context)!.hesapEvet),
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
              child: Text(AppLocalizations.of(context)!
                  .hesapVerileriTemizleVeUygulamadanCik),
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
                              AppLocalizations.of(context)!.hesapCikisEminMisin,
                              textAlign: TextAlign.center,
                            ),
                            // content: Text(
                            //     'Bu işlemi yapmak istediğinize emin misiniz?'),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    child: Text(AppLocalizations.of(context)!
                                        .hesapHayir),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  SizedBox(
                                      width:
                                          16), // Butonlar arasında biraz boşluk bırakmak için
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    child: Text(AppLocalizations.of(context)!
                                        .hesapEvet),
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
                    child: Text(AppLocalizations.of(context)!.hesapCikis),
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
