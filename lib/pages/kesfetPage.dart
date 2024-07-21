import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/functions/ad_helper.dart';
import 'package:heybaby/pages/subpages/kesfetMakale.dart';
import 'package:heybaby/pages/subpages/kesfetMakaleHaftalik.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KesfetPage extends StatefulWidget {
  final List stories;
  final List storiesWeekly;
  final String language;
  Map<String, dynamic>? userData;
  final bool referansAktif;
  final List referansList;
  KesfetPage(
      {required this.stories,
      required this.storiesWeekly,
      required this.userData,
      required this.language,
      required this.referansAktif,
      required this.referansList});
  @override
  _KesfetPageState createState() => _KesfetPageState();
}

class _KesfetPageState extends State<KesfetPage> {
  // Sabit resim linkleri
  final List<Map<String, String>> _kartlarBeslenme = [
    {
      'baslik': 'Yiyecek & İçecek',
      'resimUrl': 'assets/yiyecek_icicek.jpg',
      'baslik2': 'Yiyecek & İçecek',
    },
    {
      'baslik': 'Temel Gıdalar',
      'baslik2': 'Temel Gıdalar',
      'resimUrl': 'assets/temel_gidalar.jpg',
    },
    {
      'baslik': 'Vitamin Mineraller',
      'baslik2': 'Vitamin Mineraller',
      'resimUrl': 'assets/vitamin_mineraller.jpg',
    },
    {
      'baslik': 'Yapılacak & Yapılmayacak',
      'baslik2': 'Yapılacak & Yapılmayacak',
      'resimUrl': 'assets/yapilacak_yapilmayacak.jpg',
    },
  ];

  final List<Map<String, String>> _kartlarAnneBebek = [
    {
      'baslik': 'Kilo Alımı',
      'baslik2': 'Kilo Alımı',
      'resimUrl': 'assets/kiloAlimi.jpg',
    },
    {
      'baslik': 'Beden Değişimleri',
      'baslik2': 'Beden Değişimleri',
      'resimUrl': 'assets/bedenDegisimi.jpg',
    },
    {
      'baslik': 'Bebek Gelişimi',
      'baslik2': 'Bebek Gelişimi',
      'resimUrl': 'assets/bebekGelisim.jpg',
    },
    {
      'baslik': 'Bebek Güvenliği',
      'baslik2': 'Bebek Güvenliği',
      'resimUrl': 'assets/bebekGuvenligi.jpg',
    },
  ];

  final List<Map<String, String>> _kartlarIyiHissedin = [
    {
      'baslik': 'Huzur ve Mutluluk',
      'baslik2': 'Huzur ve Mutluluk',
      'resimUrl': 'assets/huzurMutluluk.jpg',
    },
    {
      'baslik': 'Uyku',
      'baslik2': 'Uyku',
      'resimUrl': 'assets/uyku.jpg',
    },
    {
      'baslik': 'Fiziksel Sağlık',
      'baslik2': 'Fiziksel Sağlık',
      'resimUrl': 'assets/fizikselSaglik.jpg',
    },
    {
      'baslik': 'Hamilelik Ağrısı',
      'baslik2': 'Hamilelik Ağrısı',
      'resimUrl': 'assets/hamilelikAgrisi.jpg',
    },
  ];

  final List<Map<String, String>> _kartlarHaftalik = [
    {
      'baslik': 'Haftalik Öneriler',
      'baslik2': 'Haftalik Öneriler',
      'resimUrl': 'assets/kesfet/sizdenGelenler.png',
    },
  ];

/////////////////
  ///
  ///
  final List<Map<String, String>> _kartlarBeslenme_en = [
    {
      'baslik': 'Food & Drink',
      'baslik2': 'Yiyecek & İçecek',
      'resimUrl': 'assets/yiyecek_icicek.jpg',
    },
    {
      'baslik': 'Basic Foods',
      'baslik2': 'Temel Gıdalar',
      'resimUrl': 'assets/temel_gidalar.jpg',
    },
    {
      'baslik': 'Vitamin Minerals',
      'baslik2': 'Vitamin Mineraller',
      'resimUrl': 'assets/vitamin_mineraller.jpg',
    },
    {
      'baslik': 'To be done & Not to be done',
      'baslik2': 'Yapılacak & Yapılmayacak',
      'resimUrl': 'assets/yapilacak_yapilmayacak.jpg',
    },
  ];

  final List<Map<String, String>> _kartlarAnneBebek_en = [
    {
      'baslik': 'Weight Gain',
      'baslik2': 'Kilo Alımı',
      'resimUrl': 'assets/kiloAlimi.jpg',
    },
    {
      'baslik': 'Body Change',
      'baslik2': 'Beden Değişimleri',
      'resimUrl': 'assets/bedenDegisimi.jpg',
    },
    {
      'baslik': 'Baby Development',
      'baslik2': 'Bebek Gelişimi',
      'resimUrl': 'assets/bebekGelisim.jpg',
    },
    {
      'baslik': 'Baby Safety',
      'baslik2': 'Bebek Güvenliği',
      'resimUrl': 'assets/bebekGuvenligi.jpg',
    },
  ];

  final List<Map<String, String>> _kartlarIyiHissedin_en = [
    {
      'baslik': 'Peace and Happiness',
      'baslik2': 'Huzur ve Mutluluk',
      'resimUrl': 'assets/huzurMutluluk.jpg',
    },
    {
      'baslik': 'Sleep',
      'baslik2': 'Uyku',
      'resimUrl': 'assets/uyku.jpg',
    },
    {
      'baslik': 'Pysical Health',
      'baslik2': 'Fiziksel Sağlık',
      'resimUrl': 'assets/fizikselSaglik.jpg',
    },
    {
      'baslik': 'Pregnancy Pain',
      'baslik2': 'Hamilelik Ağrısı',
      'resimUrl': 'assets/hamilelikAgrisi.jpg',
    },
  ];

  final List<Map<String, String>> _kartlarHaftalik_en = [
    {
      'baslik': 'Weekly Tips',
      'baslik2': 'Haftalik Öneriler',
      'resimUrl': 'assets/kesfet/sizdenGelenler.png',
    },
  ];

  ///
  ///
////////////////

  void baslikDegistir() async {
    if (AppLocalizations.of(context)!.language == "English") {
      setState(() {
        _kartlarBeslenme[0]['baslik'] = 'Food & Drink';
        _kartlarBeslenme[1]['baslik'] = 'Basic Foods';
        _kartlarBeslenme[2]['baslik'] = 'Vitamin Minerals';
        _kartlarBeslenme[3]['baslik'] = 'To be done & Not to be done';
        _kartlarAnneBebek[0]['baslik'] = 'Weight Gain';
        _kartlarAnneBebek[1]['baslik'] = 'Body Change';
        _kartlarAnneBebek[2]['baslik'] = 'Baby Development';
        _kartlarAnneBebek[3]['baslik'] = 'Baby Safety';
        _kartlarIyiHissedin[0]['baslik'] = 'Peace and Happiness';
        _kartlarIyiHissedin[1]['baslik'] = 'Sleep';
        _kartlarIyiHissedin[2]['baslik'] = 'Pysical Health';
        _kartlarIyiHissedin[3]['baslik'] = 'Pregnancy Pain';
        _kartlarHaftalik[0]['baslik'] = 'Weekly Tips';

        // final List<Map<String, String>> _kartlarBeslenme = [
        //   {
        //     'baslik': 'Food & Drink',
        //     'resimUrl': 'assets/yiyecek_icicek.jpg',
        //   },
        //   {
        //     'baslik': 'Basic Foods',
        //     'resimUrl': 'assets/temel_gidalar.jpg',
        //   },
        //   {
        //     'baslik': 'Vitamin Minerals',
        //     'resimUrl': 'assets/vitamin_mineraller.jpg',
        //   },
        //   {
        //     'baslik': 'To be done & Not to be done',
        //     'resimUrl': 'assets/yapilacak_yapilmayacak.jpg',
        //   },
        // ];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(milliseconds: 100), () {
    //   baslikDegistir();
    // });

    if (widget.userData!['userSubscription'] == 'Free') {
      _loadInterstitialAd();
    } else {
      print("Free user değil reklam yüklemeye gerek yok");
    }
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

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${err.message}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 26, 2, 61),
                    ),
                  ),
                  backgroundColor: Color.fromARGB(
                      255, 224, 210, 246), // Snackbar arka plan rengi
                  duration: Duration(seconds: 3), // Snackbar gösterim süresi
                  behavior: SnackBarBehavior.floating, // Snackbar davranışı
                  shape: RoundedRectangleBorder(
                    // Snackbar şekli
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4, // Snackbar yükseltilmesi
                  margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                ),
              );

              print('Failed to show the ad: ${err.message}');
            },
          );
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${err.message}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 26, 2, 61),
                ),
              ),
              backgroundColor: Color.fromARGB(
                  255, 224, 210, 246), // Snackbar arka plan rengi
              duration: Duration(seconds: 3), // Snackbar gösterim süresi
              behavior: SnackBarBehavior.floating, // Snackbar davranışı
              shape: RoundedRectangleBorder(
                // Snackbar şekli
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4, // Snackbar yükseltilmesi
              margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
            ),
          );

          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void
      storiesAyristirma() //cloud da bulunan storyleri ayrıştırarak kendi alanlarına ekleriz
  {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Keşfet'),
      // ),
      body: SingleChildScrollView(
        child: widget.language == "Türkçe"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildKartListesi("Beslenme", _kartlarBeslenme),
                  _buildKartListesi("Anne & Bebek", _kartlarAnneBebek),
                  _buildKartListesi("İyi Hissedin", _kartlarIyiHissedin),
                  _buildKartListesi(
                      "Hayatı Kolaylaştıran İpuçları", _kartlarHaftalik),
                  // Buraya ek alt başlıklar ve kartlar eklenebilir.
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildKartListesi("Nutrition", _kartlarBeslenme_en),
                  _buildKartListesi("Mother & Baby", _kartlarAnneBebek_en),
                  _buildKartListesi("Feel Good", _kartlarIyiHissedin_en),
                  _buildKartListesi(
                      "Tips to Make Life Easier", _kartlarHaftalik_en),
                  // Buraya ek alt başlıklar ve kartlar eklenebilir.
                ],
              ),
      ),
    );
  }

  Widget _buildAltBaslik(String baslik) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        baslik,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildKartListesi(String _baslik, List _kartlar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _baslik,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _kartlar.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // print(_kartlar[index]['resimUrl']!);
                  if (_kartlar[index]['resimUrl'] !=
                      'assets/kesfet/sizdenGelenler.png') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KesfetMakaleWidget(
                            baslik: _kartlar[index]['baslik2']!,
                            resimUrl: _kartlar[index]['resimUrl']!,
                            stories: widget.stories,
                            language: AppLocalizations.of(context)!.language,
                            referansAktif: widget.referansAktif,
                            referansList: widget.referansList,
                            userData: widget.userData),
                      ),
                    );
                  } else {
                    // print(widget.storiesWeekly);

                    if (widget.userData!['userSubscription'] == 'Free') {
                      if (_interstitialAd != null) {
                        _interstitialAd!.show();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KesfetMakaleHaftalikWidget(
                              stories: widget.storiesWeekly,
                              userData: widget.userData,
                            ),
                          ),
                        );
                      } else {
                        print('Reklam yüklenmedi veya gösterilemedi.');
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       'İçeriklerinizi hazırlıyoruz, Lütfen bir kaç saniye bekleyip tekrar deneyin. 😇',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 16,
                        //         color: Color.fromARGB(255, 26, 2, 61),
                        //       ),
                        //     ),
                        //     backgroundColor: Color.fromARGB(
                        //         255, 224, 210, 246), // Snackbar arka plan rengi
                        //     duration: Duration(
                        //         seconds: 3), // Snackbar gösterim süresi
                        //     behavior:
                        //         SnackBarBehavior.floating, // Snackbar davranışı
                        //     shape: RoundedRectangleBorder(
                        //       // Snackbar şekli
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     elevation: 4, // Snackbar yükseltilmesi
                        //     margin:
                        //         EdgeInsets.all(10), // Snackbar kenar boşlukları
                        //   ),
                        // );

                        _loadInterstitialAd();
                      }
                    } else {
                      print("Free user değil reklam yüklemeye gerek yok");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KesfetMakaleHaftalikWidget(
                            stories: widget.storiesWeekly,
                            userData: widget.userData,
                          ),
                        ),
                      );
                    }
                  }

                  // Kartlara tıklanınca yapılacak işlemler buraya yazılabilir.
                },
                child: _buildKart(
                    _kartlar[index]['baslik']!, _kartlar[index]['resimUrl']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKart(String baslik, String resimUrl) {
    return Container(
      width: 160.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              resimUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              baslik,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
