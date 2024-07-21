import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/functions/ad_helper.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/boxes.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/functions/jsonFiles.dart';
import 'package:heybaby/functions/person.dart';
import 'package:heybaby/pages/functions.dart';
import 'package:heybaby/pages/storyImages.dart';
import 'package:heybaby/pages/subpages/anaSayfaFoto.dart';
import 'package:heybaby/pages/subpages/haftalikGuncelleme.dart';
import 'package:heybaby/pages/subpages/ilacTakip.dart';
import 'package:heybaby/pages/subpages/kesfetMakale.dart';
import 'package:heybaby/pages/subpages/kiloTakip.dart';
import 'package:heybaby/pages/subpages/radialMenu.dart';
import 'package:heybaby/pages/subpages/suTakip.dart';
import 'package:heybaby/pages/subpages/yapilacaklarPage.dart';
import 'package:heybaby/pages/takvimPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnaSayfa extends StatefulWidget {
  final List storyImages;
  final List newstoryImages;
  Map<String, dynamic>? userData;
  final bool referansAktif;
  final bool yaklasanAktiviteHome;
  final List referansList;

  AnaSayfa(
      {Key? key,
      this.userData,
      required this.newstoryImages,
      required this.storyImages,
      required this.referansAktif,
      required this.yaklasanAktiviteHome,
      required this.referansList})
      : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  late Person _token;
  var calendarListEvents;
  Map calendarListEventsSoon = {};
  int calendarListEventsSoonDay = 15;
  // List _storyImagesLink = [];

  DateTime bugun = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  Map<String, String> activities = {};
  int selectedWeek = 4;
  int yeniHafte = 5;
  int kacGunSonraYeniHafta = 0;
  bool _aktivitelerAcik = false;
  final GlobalKey expansionTileKey = GlobalKey();
  bool _isVisibleYaklasanAktiviteler = true;
  Map<int, List<String>> hamilelikYapilacaklar = {
    1: [
      "Doktor randevusuna git ve ultrason yaptır",
      "Hamilelik günlüğüne başla ve duygularını kaydet",
      "Yeni anne hakkında bloglar ve makaleler oku"
          "Sağlıklı atıştırmalıklar hazırla",
      "Meditasyon yaparak rahatla",
      "Hamilelik resimleri çek ve hatıra oluştur"
    ],
    2: [
      "Doktor randevusuna git ve ultrason yaptır",
      "Hamilelik günlüğüne başla ve duygularını kaydet",
      "Yeni anne hakkında bloglar ve makaleler oku"
          "Sağlıklı atıştırmalıklar hazırla",
      "Meditasyon yaparak rahatla",
      "Hamilelik resimleri çek ve hatıra oluştur"
    ],
    3: [
      "Doktor randevusuna git ve ultrason yaptır",
      "Hamilelik günlüğüne başla ve duygularını kaydet",
      "Yeni anne hakkında bloglar ve makaleler oku"
          "Sağlıklı atıştırmalıklar hazırla",
      "Meditasyon yaparak rahatla",
      "Hamilelik resimleri çek ve hatıra oluştur"
    ],
    4: [
      "Doktor randevusuna git ve ultrason yaptır",
      "Hamilelik günlüğüne başla ve duygularını kaydet",
      "Yeni anne hakkında bloglar ve makaleler oku"
          "Sağlıklı atıştırmalıklar hazırla",
      "Meditasyon yaparak rahatla",
      "Hamilelik resimleri çek ve hatıra oluştur"
    ],
    5: [
      "Günlük yürüyüşler yaparak aktif kal",
      "Hamilelikle ilgili kitaplar oku ve bilgi edin",
      "Eşinle birlikte romantik bir kaçamak yap",
      "Sağlıklı smoothie tarifleri dene",
      "Kalsiyum ve demir açısından zengin besinler tüket",
    ],
    6: [
      "Dengeli beslenmeye özen göster",
      "Bebek odasını için plan yapmaya başla",
      "Hamilelik fotoğraf albümü oluştur",
      "Hafif yoga ve nefes egzersizleri yap",
      "Yeni annelerle tanışmak için gruplara katıl"
    ],
    7: [
      "Hamilelik cilt bakım ürünleri al",
      "Anne-bebek yoga dersine katıl"
          "Yüzme havuzunda gevşeme seansı al"
          "Yüksek protein içeren diyeti benimse",
      "Yüzme veya su aerobiği yaparak rahatla",
      "Anne olmanın getirdiği değişiklikleri kabul etmeye hazırlan"
    ],
    8: [
      "Doktor randevusuna git ve doğum planını tartış",
      "Evinde bebek odası için plan yap",
      "Pilates veya doğum topu egzersizleri yap",
      "Gebelikte cilt bakım rutini oluştur",
      "Hamilelik günce yazarak duygularını ifade et",
      "Ebeveynlikle ilgili kitaplar oku ve bilgi edin"
    ],
    9: [
      "Bebeğin ilk giysileri için alışveriş yap",
      "Masaj yaptırarak rahatla",
      "Rahat uyumanı sağlayacak pozisyonları dene",
      "Hamilelik yoga dersine katıl",
      "Bebeğin ilk aşıları hakkında bilgi edin"
    ],
    10: [
      "Hamilelik egzersiz programını sürdür",
      "Gebelik modasına uygun kıyafetler al",
      "Doğum için hazırlık kursuna katıl",
      "Hamilelikte doğal doğum yöntemlerini araştır",
      "Bebekle iletişim kurmayı öğren"
    ],
    11: [
      "Bebeğin ilk hediyelerini satın al",
      "Hamilelik masajı yaptır",
      "Hafif egzersizlerle aktiviteyi sürdür",
      "Doğum ekipmanlarını düzenle",
      "Bebeğin odasını hazırla",
    ],
    12: [
      "Bebek bakım kursuna katıl",
      "Rahat giysiler al",
      "Masaj yaptırarak rahatla",
      "Bebeğin adını araştırmaya başla",
      "Hamileliğin hakkında bebeğine mektup yaz"
    ],
    13: [
      "Bebeğin bakımı için alışveriş yap",
      "Doğum öncesi kursları araştır",
      "Sağlıklı beslenmeye devam et",
      "Yumuşak ve destekleyici yatak al",
    ],
    14: [
      "Bebeğin aşı takvimini oluştur",
      "Rahatlatıcı banyo yap",
      "Hamilelikte giymek için rahat ve emzirme dostu kıyafetler al"
          "Hamilelik egzersiz videoları izle"
    ],
    15: [
      "Doğum için meditasyon uygula",
      "Doğum hikayesi yaz",
      "Bebeğin güvenliği için evi düzenle",
      "Dinlenmek için rahat bir köşe oluştur"
    ],
    16: [
      "Bebeğin uyku düzenini oluştur",
      "Bebek bakımı kurslarına katıl",
      "Doğum sonrası yoga dersine katıl",
      "Doğum öncesi fotoğraf çekimi ayarla"
    ],
    17: [
      "Doğum öncesi arkadaşlarla buluş",
      "Hamilelikte doğal doğum yöntemlerini öğren",
      "Bebeğinizi emzirmeye hazırlık yapın"
          "Bebeğin uyku düzenini oluştur",
    ],
    18: [
      "Doğum sonrası yardım için destek sistemini oluştur",
      "Emzirme desteği al",
      "Doğum öncesi masajı yaptır"
          "Bebeğin ilerideki eğitim planını düşün",
    ],
    19: [
      "Bebeğin ilk günlük alışkanlıklarını öğren",
      "Anne sütü arttırmak için diyeti düzenle",
      "Doğum sonrası yoga derslerine katıl",
      "Yumuşak müzikler dinleyerek rahatla",
    ],
    20: [
      "Bebeğin sağlık sigortası için araştırma yap",
      "Düzenli olarak pelvik taban egzersizleri yap",
    ],
    21: [
      "Bebeğin gelişimini takip et",
      "Anne sütünü artırmak için beslenme planını düzenle",
      "Anne sütü sağma yöntemlerini öğren",
    ],
    22: [
      "Yeterli kalsiyum ve demir aldığından emin ol",
      "Pelvik taban egzersizlerine başla",
      "Uyku pozisyonuna dikkat et, sol yanına yatmaya çalış"
    ],
    23: [
      "Doğum öncesi eğitim sınıflarını araştır",
      "Daha rahat ayakkabılar giymeye başla",
      "Cilt değişikliklerine karşı nemlendirici kullan"
    ],
    24: [
      "Düzenli olarak kilo kontrolü yap",
      "Bol sıvı tüketimine dikkat et",
      "Sağlıklı atıştırmalıklar hazırla"
    ],
    25: [
      "Yorgunlukla başa çıkmak için dinlenme molaları ver",
      "Doğum planını gözden geçir",
      "Duruşunu düzeltmek için esneme hareketleri yap"
    ],
    26: [
      "Gestasyonel diyabet testi için doktorunla görüş",
      "Yoga veya prenatal egzersiz sınıflarına katıl",
      "Doğum sonrası bakım planını düşün"
    ],
    27: [
      "Bebeğin hareketlerini takip et",
      "Rahat kıyafetler giymeye özen göster",
      "Eşinle birlikte doğum sonrası görev paylaşımını planla"
    ],
    28: [
      "Düzenli doktor kontrollerini aksatma",
      "Bebek odasını hazırlamaya başla",
      "Doğum çantanı hazırlamayı düşün"
    ],
    29: [
      "Hafif yürüyüşler yaparak aktif kal",
      "Dinlenirken bacaklarını yukarı kaldır",
      "Sağlıklı ve dengeli beslenmeye devam et"
    ],
    30: [
      "Yenidoğan bakımı hakkında bilgi edin",
      "Uyku düzenine dikkat et",
      "Yorgun hissettiğinde yardım iste"
    ],
    31: [
      "Bebek alışverişini tamamla",
      "Doğum süreci hakkında daha fazla bilgi edin",
      "Eşinle birlikte doğum ve sonrası için plan yap"
    ],
    32: [
      "Daha sık dinlenme molaları ver",
      "Rahat uyku pozisyonları bul",
      "Ciltteki kaşıntılar için doktoruna danış"
    ],
    33: [
      "Sıvı tüketimini artır",
      "Eğilme ve kaldırma hareketlerinde dikkatli ol",
      "Rahatlatıcı aktiviteler yap"
    ],
    34: [
      "Bebek hareketlerini düzenli olarak kontrol et",
      "Doğum belirtilerini öğren",
      "Eşinle doğum planını tekrar gözden geçir"
    ],
    35: [
      "Hafif egzersizlere devam et",
      "Yeterli dinlenme yap",
      "Doktor kontrollerini aksatma"
    ],
    36: [
      "Doğum çantanı hazırla",
      "Rahat nefes alma teknikleri öğren",
      "Doğum sonrası bakım planını gözden geçir"
    ],
    37: [
      "Bebek için ihtiyaç listesi oluştur",
      "Yorgun hissettiğinde dinlen",
      "Sık idrara çıkma durumuna hazırlıklı ol"
    ],
    38: [
      "Doğum belirtilerini tekrar gözden geçir",
      "Eşinle doğuma hazırlık yap",
      "Sağlıklı beslenmeye devam et"
    ],
    39: [
      "Doğum çantanı kontrol et",
      "Rahatlamaya çalış ve stres yapma",
      "Doğum sonrası için yardım planları yap"
    ],
    40: [
      "Doktor kontrollerine düzenli git",
      "Doğum belirtilerini takip et",
      "Bol bol dinlen"
    ]
  };

  Map<int, List<String>> hamilelikYapilacaklar_en = {
    1: [
      "Go to the doctor appointment and get an ultrasound",
      "Start a pregnancy journal and record your feelings",
      "Read blogs and articles about new moms",
      "Prepare healthy snacks",
      "Relax with meditation",
      "Take pregnancy photos and create memories"
    ],
    2: [
      "Go to the doctor appointment and get an ultrasound",
      "Start a pregnancy journal and record your feelings",
      "Read blogs and articles about new moms",
      "Prepare healthy snacks",
      "Relax with meditation",
      "Take pregnancy photos and create memories"
    ],
    3: [
      "Go to the doctor appointment and get an ultrasound",
      "Start a pregnancy journal and record your feelings",
      "Read blogs and articles about new moms",
      "Prepare healthy snacks",
      "Relax with meditation",
      "Take pregnancy photos and create memories"
    ],
    4: [
      "Go to the doctor appointment and get an ultrasound",
      "Start a pregnancy journal and record your feelings",
      "Read blogs and articles about new moms",
      "Prepare healthy snacks",
      "Relax with meditation",
      "Take pregnancy photos and create memories"
    ],
    5: [
      "Stay active with daily walks",
      "Read books about pregnancy and gain knowledge",
      "Plan a romantic getaway with your partner",
      "Try healthy smoothie recipes",
      "Consume foods rich in calcium and iron"
    ],
    6: [
      "Pay attention to a balanced diet",
      "Start planning for the baby’s room",
      "Create a pregnancy photo album",
      "Do light yoga and breathing exercises",
      "Join groups to meet new moms"
    ],
    7: [
      "Get pregnancy skincare products",
      "Join a mom-baby yoga class",
      "Relax with a swimming session",
      "Adopt a high-protein diet",
      "Relax with swimming or water aerobics",
      "Prepare to embrace the changes of motherhood"
    ],
    8: [
      "Go to the doctor appointment and discuss the birth plan",
      "Plan for the baby’s room at home",
      "Do pilates or birthing ball exercises",
      "Create a pregnancy skincare routine",
      "Express your feelings by writing a pregnancy journal",
      "Read books and gain knowledge about parenting"
    ],
    9: [
      "Shop for baby’s first clothes",
      "Relax with a massage",
      "Try sleeping positions that help you sleep comfortably",
      "Join a pregnancy yoga class",
      "Learn about the baby’s first vaccinations"
    ],
    10: [
      "Continue the pregnancy exercise program",
      "Buy clothes suitable for pregnancy fashion",
      "Attend a preparation course for birth",
      "Research natural birth methods during pregnancy",
      "Learn how to communicate with the baby"
    ],
    11: [
      "Buy the baby’s first gifts",
      "Get a pregnancy massage",
      "Maintain activity with light exercises",
      "Organize birth equipment",
      "Prepare the baby’s room"
    ],
    12: [
      "Attend a baby care course",
      "Buy comfortable clothes",
      "Relax with a massage",
      "Start researching baby names",
      "Write a letter to your baby about your pregnancy"
    ],
    13: [
      "Shop for baby care",
      "Research prenatal classes",
      "Continue healthy eating",
      "Buy a soft and supportive mattress"
    ],
    14: [
      "Create a baby vaccination schedule",
      "Take a relaxing bath",
      "Buy comfortable and nursing-friendly clothes for pregnancy",
      "Watch pregnancy exercise videos"
    ],
    15: [
      "Practice meditation for birth",
      "Write a birth story",
      "Organize the house for the baby’s safety",
      "Create a comfortable corner to rest"
    ],
    16: [
      "Establish a sleep routine for the baby",
      "Attend baby care courses",
      "Join a postpartum yoga class",
      "Schedule a prenatal photoshoot"
    ],
    17: [
      "Meet friends before birth",
      "Learn natural birth methods during pregnancy",
      "Prepare for breastfeeding your baby",
      "Establish a sleep routine for the baby"
    ],
    18: [
      "Create a support system for postpartum help",
      "Get breastfeeding support",
      "Get a prenatal massage",
      "Think about the baby’s future education plan"
    ],
    19: [
      "Learn the baby’s first daily habits",
      "Adjust the diet to increase breast milk",
      "Join postpartum yoga classes",
      "Relax by listening to soft music"
    ],
    20: [
      "Research health insurance for the baby",
      "Regularly perform pelvic floor exercises"
    ],
    21: [
      "Track the baby’s development",
      "Adjust your diet to increase breast milk",
      "Learn methods for expressing breast milk"
    ],
    22: [
      "Ensure you get enough calcium and iron",
      "Start pelvic floor exercises",
      "Pay attention to sleep position, try to sleep on your left side"
    ],
    23: [
      "Research prenatal classes",
      "Start wearing more comfortable shoes",
      "Use moisturizer for skin changes"
    ],
    24: [
      "Regularly monitor weight",
      "Pay attention to consuming plenty of fluids",
      "Prepare healthy snacks"
    ],
    25: [
      "Take breaks to cope with fatigue",
      "Review your birth plan",
      "Do stretching exercises to correct posture"
    ],
    26: [
      "Consult your doctor for a gestational diabetes test",
      "Join yoga or prenatal exercise classes",
      "Think about your postpartum care plan"
    ],
    27: [
      "Track the baby’s movements",
      "Pay attention to wearing comfortable clothes",
      "Plan post-birth task sharing with your partner"
    ],
    28: [
      "Don’t miss regular doctor check-ups",
      "Start preparing the baby’s room",
      "Consider preparing your birth bag"
    ],
    29: [
      "Stay active with light walks",
      "Lift your legs up while resting",
      "Continue to eat healthily and balanced"
    ],
    30: [
      "Learn about newborn care",
      "Pay attention to the sleep schedule",
      "Ask for help when you feel tired"
    ],
    31: [
      "Complete baby shopping",
      "Learn more about the birth process",
      "Plan for birth and afterwards with your partner"
    ],
    32: [
      "Take more frequent rest breaks",
      "Find comfortable sleeping positions",
      "Consult your doctor for itchy skin"
    ],
    33: [
      "Increase fluid intake",
      "Be careful with bending and lifting movements",
      "Do relaxing activities"
    ],
    34: [
      "Regularly check baby movements",
      "Learn the signs of labor",
      "Review the birth plan with your partner"
    ],
    35: [
      "Continue with light exercises",
      "Get enough rest",
      "Don’t miss doctor check-ups"
    ],
    36: [
      "Prepare your birth bag",
      "Learn comfortable breathing techniques",
      "Review your postpartum care plan"
    ],
    37: [
      "Create a needs list for the baby",
      "Rest when you feel tired",
      "Be prepared for frequent urination"
    ],
    38: [
      "Review the signs of labor",
      "Prepare for birth with your partner",
      "Continue to eat healthily"
    ],
    39: [
      "Check your birth bag",
      "Try to relax and not stress",
      "Make plans for postpartum help"
    ],
    40: [
      "Regularly go to doctor check-ups",
      "Track the signs of labor",
      "Rest a lot"
    ]
  };

  orderSoonEvents(calendarListEventsSoon) {
    String _tempKey = "";
    String _tempValue = "";
    calendarListEventsSoon.forEach((key, value) {
      for (var _element in value.toList()) {
        setState(() {
          _tempKey = _element['id'].toString();
          _tempValue = key.toString() +
              "%%%" +
              _element['title'].toString() +
              "%%%" +
              _element['time'].toString() +
              "%%%" +
              _element['icon'].toString() +
              "%%%" +
              _element['alarm'].toString();
          activities[_tempKey] = _tempValue;
        });
      }
    });
  }

  String formatDate(String dateString) //yıl-ay-gün formatı gün-ay-yıl a çevirir
  {
    // İlk olarak, verilen stringi DateTime nesnesine dönüştürüyoruz
    DateTime dateTime = DateTime.parse(dateString);

    // Ardından, istediğimiz tarih formatını belirleyip uyguluyoruz
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    // Son olarak, yeni formatlanmış tarih string'ini döndürüyoruz
    return formattedDate;
  }

  late Map jsonList = {}; // Global değişken tanımı
  late Map jsonList0 = {};

  imageandInfoJsonFileLoad() async {
    jsonList0 =
        await JsonReader.readJson(AppLocalizations.of(context)!.language);
    setState(() {
      jsonList = jsonList0;
    });

    if (_interstitialAd == null) {
      print(
          "Home page: Reklam değeri null, yeni reklam oluşabilir. yetkilerine bakılacak");

      if (widget.userData!['userSubscription'] == 'Free') {
        {
          print("free user reklam oluşuruluyor");
          _loadInterstitialAd();
        }
      }
    }

    // print(jsonList);
  }

  haftalikBoyutBildirimOlustur(int yeniHafta, int kacGunSonraYeniHafta) async {
    if (widget.userData!['bildirimler']['boyut'] != null &&
        widget.userData!['bildirimler']['boyut'].isNotEmpty) {
      // Map boş değilse yapılacak işlemler
      print("Map boş değil");
    } else {
      var _mevcutBildirimler =
          await AwesomeNotifications().listScheduledNotifications();
      List _bildirimIdleri = [];
      for (var _bildirim in _mevcutBildirimler) {
        if (_bildirim.content!.id! < 1099) {
          var _iptal =
              await AwesomeNotifications().cancel(_bildirim.content!.id!);
        }
      }
      List _tempList = [];
      int haftalikSayac = 0;

      for (var i = yeniHafte; i < 41; i++) {
        if (i < 4) {
          i = 4;
        }
        Map _tempMap = {};
        var sonrakiTarih = DateTime.now()
            .add(Duration(days: kacGunSonraYeniHafta + (7 * haftalikSayac)));
        print(i);
        _tempMap['tarih'] = DateTime(
            sonrakiTarih.year,
            sonrakiTarih.month,
            sonrakiTarih.day,
            10, // saat
            0 // dakika
            );
        _tempMap['foto_link'] = jsonList['$i']['foto_link'];
        _tempMap['benzerlik'] = jsonList['$i']['benzerlik'];

        _tempMap['id'] = 1000 + i;

        await BildirimTakip.haftalikBoyutBilgisi(
            _tempMap['id'],
            _tempMap['benzerlik'],
            _tempMap['foto_link'],
            10,
            00,
            sonrakiTarih.day,
            sonrakiTarih.month,
            sonrakiTarih.year,
            AppLocalizations.of(context)!.language);

        await Future.delayed(Duration(milliseconds: 200));

        _tempList.add(_tempMap);
        haftalikSayac = haftalikSayac + 1;
      }
      print("Map boş");

      FirestoreFunctions.haftalikBildirimleriEkle(_tempList);

      // Map boşsa yapılacak işlemler
    }

    // var _bildirimler =
    //     await AwesomeNotifications().listScheduledNotifications();
    // List _bildirimIdleri = [];
    // for (var _bildirim in _bildirimler) {
    //   _bildirimIdleri.add(_bildirim.content!.id);
    // }
    // bool _kontrol = true;
    // for (var _bildirimId in _bildirimIdleri) {
    //   if (_bildirimId < 1050) {
    //     _kontrol = false;
    //   } else {}
    // }
    // if (_kontrol) {
    //   int sayac = 0;
    //   for (var i = _kacinciHafta + 1; i < 41; i++) {
    //     String _testImageLink = "";
    //     String _testBenzerlik = "";

    //     if (i < 41) {
    //       if (i >= 4) {
    //         _testImageLink = jsonList[i - 4]['foto_link'];
    //         _testBenzerlik = jsonList[i - 4]['benzerlik'];
    //       } else {
    //         _testImageLink = jsonList[0]['foto_link'];
    //         _testBenzerlik = jsonList[0]['benzerlik'];
    //       }
    //     } else {
    //       _testImageLink = jsonList[36]['foto_link'];
    //       _testBenzerlik = jsonList[36]['benzerlik'];
    //     }
    //     // print("_testBenzerlik Test $_testBenzerlik");

    //     Future.delayed(const Duration(milliseconds: 50), () {
    //       imageandInfoJsonFileLoad();
    //     });

    //     await BildirimTakip.haftalikBoyutBilgisi(
    //         (i + 1000),
    //         _testBenzerlik,
    //         _testImageLink,
    //         10,
    //         00,
    //         _currentDay
    //             .add(Duration(days: (8 - _currentDay.weekday) + sayac))
    //             .day,
    //         _currentDay
    //             .add(Duration(days: (8 - _currentDay.weekday) + sayac))
    //             .month,
    //         _currentDay
    //             .add(Duration(days: (8 - _currentDay.weekday) + sayac))
    //             .year);

    //     // print("Ana sayfa boyut bildirimleri yok, yazılıyor. -- " +
    //     //     (i + 1000).toString());
    //     sayac = sayac + 7;
    //   }
    // } else {
    //   print("haftalık bildirimler kurulu durumda.");
    //   // print(_bildirimIdleri);
    // }
  }

  Future<void> _fetchUserData() async {
    Map<String, dynamic>? data = await FirestoreFunctions.getUserData();
    if (data != null) {
      setState(() {
        widget.userData = data;
        selectedWeek =
            (((DateTime.now().difference(DateTime.parse(data['sonAdetTarihi'])))
                    .inDays) ~/
                7);
        yeniHafte = selectedWeek + 1;
        kacGunSonraYeniHafta = 7 -
            (((DateTime.now().difference(DateTime.parse(data['sonAdetTarihi'])))
                    .inDays) %
                7);
        print("kacGunSonraYeniHafta $kacGunSonraYeniHafta");
        haftalikBoyutBildirimOlustur(yeniHafte, kacGunSonraYeniHafta);
      });

      // if (!data.containsKey('suBildirimTakipSistemi')) {
      //   _showNotificationTimesModal();
      // }
    }
    soonActivitiesCheck();
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

  reklamGoster() async {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print('Reklam yüklenmedi veya gösterilemedi.');
      _loadInterstitialAd();
    }
  }

  soonActivitiesCheck() {
    if (widget.userData != null) {
      if (widget.userData != null &&
          widget.userData!.containsKey('calendarListEvents')) {
        widget.userData!['calendarListEvents'].forEach((key, value) {
          // Bugün ve sonraki tarihler için etkinlikleri kontrol et
          if (DateTime.parse(key).isAtSameMomentAs(bugun) ||
              DateTime.parse(key).isAfter(bugun)) {
            calendarListEventsSoon[DateTime.parse(key)] = [];

            // Zamanı dolu olanları ayır ve sırala
            List<Map<String, dynamic>> filledTimes = [];
            List<Map<String, dynamic>> emptyTimes = [];

            for (var appointment in value) {
              if (appointment['time'].isNotEmpty) {
                filledTimes.add(appointment);
              } else {
                emptyTimes.add(appointment);
              }
            }

            filledTimes.sort((a, b) => a['time'].compareTo(b['time']));

            // Sıralanmış randevuları yazdır
            List<Map<String, dynamic>> sortedAppointments = [];
            sortedAppointments.addAll(filledTimes);
            sortedAppointments.addAll(emptyTimes);

            calendarListEventsSoon[DateTime.parse(key)] = sortedAppointments;
          }
        });
      } else {
        print('calendarListEvents parametresi bulunamadı veya null.');
      }
      // Bugün ve sonraki tarihler içeren etkinlikleri düzenle
      orderSoonEvents(calendarListEventsSoon);
    } else {
      print("Data yok");
    }
  }

  // Future<void> _showNotificationTimesModal() async {
  //   List<TimeOfDay> notificationTimes = [
  //     TimeOfDay(hour: 10, minute: 0),
  //     TimeOfDay(hour: 13, minute: 0),
  //     TimeOfDay(hour: 18, minute: 0),
  //   ];

  //   int waterIntake = 2500;
  //   bool waterReminder = true;
  //   bool waterSummary = true;
  //   final result = await showModalBottomSheet<List<TimeOfDay>>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setModalState) {
  //           void _addNotificationTime() async {
  //             final TimeOfDay? pickedTime = await showTimePicker(
  //               context: context,
  //               initialTime: TimeOfDay.now(),
  //             );

  //             if (pickedTime != null) {
  //               setModalState(() {
  //                 notificationTimes.add(pickedTime);
  //               });
  //             }
  //           }

  //           void _editNotificationTime(int index) async {
  //             final TimeOfDay? pickedTime = await showTimePicker(
  //               context: context,
  //               initialTime: notificationTimes[index],
  //             );

  //             if (pickedTime != null) {
  //               setModalState(() {
  //                 notificationTimes[index] = pickedTime;
  //               });
  //             }
  //           }

  //           return Padding(
  //             padding: EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   'Su Takip Ayarlarınız',
  //                   style: TextStyle(
  //                     fontSize: 17.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Divider(),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text('Günlük Su Hedefi'),
  //                     Row(
  //                       children: [
  //                         IconButton(
  //                           icon: Icon(Icons.remove),
  //                           onPressed: () {
  //                             setModalState(() {
  //                               if (waterIntake > 100) waterIntake -= 100;
  //                             });
  //                           },
  //                         ),
  //                         Text('$waterIntake ml'),
  //                         IconButton(
  //                           icon: Icon(Icons.add),
  //                           onPressed: () {
  //                             setModalState(() {
  //                               waterIntake += 100;
  //                             });
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text('Günlük Özet Bildirimi'),
  //                     Checkbox(
  //                       value: waterSummary,
  //                       onChanged: (bool? value) {
  //                         setModalState(() {
  //                           waterSummary = value ?? true;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text('Gün İçi Hatırlatıcıları'),
  //                     Checkbox(
  //                       value: waterReminder,
  //                       onChanged: (bool? value) {
  //                         setModalState(() {
  //                           waterReminder = value ?? true;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 waterReminder
  //                     ? Container(
  //                         decoration: BoxDecoration(
  //                           // color: Colors.blue, // Arka plan rengi
  //                           borderRadius:
  //                               BorderRadius.circular(10), // Kenar yuvarlatma
  //                           border: Border.all(
  //                               color: Colors.black), // Kenar çizgisi
  //                         ),
  //                         child: SingleChildScrollView(
  //                           scrollDirection: Axis.horizontal,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               const Padding(
  //                                 padding: EdgeInsets.only(left: 8),
  //                                 child: Text('Saat'),
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   IconButton(
  //                                     icon: Icon(Icons.add),
  //                                     onPressed: () {},
  //                                   ),
  //                                   Row(
  //                                     children: notificationTimes
  //                                         .map(
  //                                           (time) => Padding(
  //                                             padding: const EdgeInsets.all(5),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                 border: Border.all(
  //                                                   color: Color.fromARGB(
  //                                                       255,
  //                                                       153,
  //                                                       51,
  //                                                       255), // Çerçeve rengi
  //                                                   width:
  //                                                       1.0, // Çerçeve kalınlığı
  //                                                 ),
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         8.0), // Opsiyonel: Köşelerin yuvarlaklığı
  //                                               ),
  //                                               child: Row(
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment.center,
  //                                                 children: [
  //                                                   Padding(
  //                                                     padding:
  //                                                         const EdgeInsets.only(
  //                                                             left: 8),
  //                                                     child: GestureDetector(
  //                                                       child: Text(
  //                                                         '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
  //                                                         style: TextStyle(
  //                                                             fontSize: 16),
  //                                                       ),
  //                                                       onTap: () {
  //                                                         print(
  //                                                             notificationTimes);
  //                                                         showTimePicker(
  //                                                           context: context,
  //                                                           initialTime: time,
  //                                                         ).then((pickedTime) {
  //                                                           if (pickedTime !=
  //                                                               null) {
  //                                                             setModalState(() {
  //                                                               notificationTimes
  //                                                                   .remove(
  //                                                                       time);
  //                                                               notificationTimes
  //                                                                   .add(
  //                                                                       pickedTime);
  //                                                               notificationTimes
  //                                                                   .sort((a, b) => a
  //                                                                       .hour
  //                                                                       .compareTo(
  //                                                                           b.hour));
  //                                                             });

  //                                                             print(
  //                                                                 notificationTimes);
  //                                                           }
  //                                                         });
  //                                                       },
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     height: 38,
  //                                                     width: 40,
  //                                                     child: IconButton(
  //                                                       iconSize: 20,
  //                                                       icon: Icon(
  //                                                         Icons.remove_circle,
  //                                                         // size: 20,
  //                                                       ),
  //                                                       onPressed: () {
  //                                                         setModalState(() {
  //                                                           notificationTimes
  //                                                               .remove(time);
  //                                                         });
  //                                                         notificationTimes
  //                                                             .sort((a, b) => a
  //                                                                 .hour
  //                                                                 .compareTo(
  //                                                                     b.hour));
  //                                                       },
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         )
  //                                         .toList(),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       )

  //                     // ListView.builder(
  //                     //     shrinkWrap: true,
  //                     //     itemCount: notificationTimes.length,
  //                     //     itemBuilder: (context, index) {
  //                     //       return ListTile(
  //                     //         title: Text(
  //                     //             notificationTimes[index].format(context)),
  //                     //         trailing: IconButton(
  //                     //           icon: Icon(Icons.edit),
  //                     //           onPressed: () {
  //                     //             _editNotificationTime(index);
  //                     //           },
  //                     //         ),
  //                     //       );
  //                     //     },
  //                     //   )

  //                     : SizedBox(),
  //                 Center(
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       if (!waterReminder) {
  //                         setModalState(() {
  //                           notificationTimes = [];
  //                         });
  //                       } else {
  //                         Navigator.pop(context);
  //                         var _bildirimler = await AwesomeNotifications()
  //                             .listScheduledNotifications();
  //                         List _bildirimIdleri = [];
  //                         // print("AAAAAAAA");
  //                         for (var _bildirim in _bildirimler) {
  //                           // print(_bildirim.content!.id);
  //                         }
  //                         print(notificationTimes);

  //                         for (var i = 0; i < notificationTimes.length; i++) {
  //                           var time = notificationTimes[i];
  //                           var simdi = DateTime.now();
  //                           var hours = time.hour.toString().padLeft(2, '0');
  //                           var minutes =
  //                               time.minute.toString().padLeft(2, '0');
  //                           var formattedTimeString = "100${hours}${minutes}";
  //                           var formattedTime = int.parse(formattedTimeString);
  //                           print(formattedTime);
  //                           print(time);
  //                           print(simdi);
  //                           BildirimTakip.gunIciSuHatirlatici(
  //                               formattedTime,
  //                               time.hour,
  //                               time.minute,
  //                               simdi.day,
  //                               simdi.month,
  //                               simdi.year);
  //                           await Future.delayed(Duration(milliseconds: 350));
  //                         }

  //                         var _bildirimler2 = await AwesomeNotifications()
  //                             .listScheduledNotifications();

  //                         // print("AAAAAAAA");
  //                         for (var _bildirim in _bildirimler2) {
  //                           // print(_bildirim.content!.id);
  //                         }
  //                         print(notificationTimes);
  //                       }
  //                       // if (waterSummary) {
  //                       //   suBildiriminiOlustur();
  //                       // } else {
  //                       //   suBildirimleriniSil();
  //                       // }
  //                       var _result = await FirestoreFunctions
  //                           .suBildirimTakipSistemiOlustur(waterIntake,
  //                               waterSummary, waterReminder, notificationTimes);
  //                     },
  //                     child: Text('Kaydet'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );

  //   if (result != null) {
  //     setState(() {
  //       notificationTimes = result;
  //     });
  //     print(notificationTimes.map((time) => time.format(context)).toList());
  //   }
  // }

  void _sortStoryImagesByDate() {
    setState(() {
      widget.storyImages.sort((a, b) {
        int idA = a['id'];
        int idB = b['id'];
        return idB.compareTo(
            idA); // Büyükten küçüğe doğru sıralama// Yakından uzağa doğru sıralama
      });
    });
    print("Ana ekran İçerikler tarihe göre sıralandı ${widget.storyImages}  ");
  }

  @override
  void initState() {
    print("newstoryImages değeri ${widget.newstoryImages.length}");
    Future.delayed(const Duration(milliseconds: 50), () {
      imageandInfoJsonFileLoad();
    });

    // setState(() {
    //   // print("widget.newstoryImage  ");
    //   // print(widget.newstoryImages);
    //   for (var storyElement in widget.newstoryImages) {
    //     _storyImagesLink.add(storyElement['imageLink']);
    //   }
    //   print("ZZZZZZZZZZ ${widget.newstoryImages.length}");
    // });

    // haftalikBoyutBildirimOlustur();
    _token = boxPersons.get('currentToken',
        defaultValue: Person(token: 50, subnName: 'myToken'));
    print("Evet ${_token.subnName} token değeri ${_token.token}");
    super.initState();

    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _sortStoryImagesByDate();
    // });

    _fetchUserData();
  }

  bool _visibleControlTemp = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Story Circles
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification) {
                // Scroll aşağıya mı gidiyor kontrol et
                if (scrollNotification.metrics.pixels >
                    scrollNotification.metrics.minScrollExtent) {
                  if (_visibleControlTemp) {
                    setState(() {
                      _isVisibleYaklasanAktiviteler = false;
                      _visibleControlTemp = false;
                    });
                  }
                }
                // Scroll en üste mi geri geldi kontrol et
                if (scrollNotification.metrics.pixels <=
                    scrollNotification.metrics.minScrollExtent) {
                  setState(() {
                    _isVisibleYaklasanAktiviteler = true;
                    _visibleControlTemp = true;
                  });
                }
              }

              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.newstoryImages.length != 0
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 0, 5),
                                  child: Text(
                                    "$selectedWeek. " +
                                        AppLocalizations.of(context)!
                                            .anasayfaIpucu,
                                    // "$selectedWeek. Haftanıza Özel İpuçlarınız",
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                widget.userData!['userSubscription'] == 'Free'
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 18, 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              _token.token.toString(),
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    4), // Icon ile token sayısı arasında boşluk

                                            InkWell(
                                              onTap: () {
                                                final RenderBox button =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                final RenderBox overlay =
                                                    Overlay.of(context)
                                                            .context
                                                            .findRenderObject()
                                                        as RenderBox;
                                                final RelativeRect position =
                                                    RelativeRect.fromRect(
                                                  Rect.fromPoints(
                                                    button.localToGlobal(
                                                        Offset.zero,
                                                        ancestor: overlay),
                                                    button.localToGlobal(
                                                        button.size.bottomRight(
                                                            Offset.zero),
                                                        ancestor: overlay),
                                                  ),
                                                  Offset.zero & overlay.size,
                                                );

                                                showMenu(
                                                  context: context,
                                                  position: position.shift(Offset(
                                                      button.size.width,
                                                      0)), // Sağ üst köşeye pozisyonu ayarla
                                                  items: [
                                                    PopupMenuItem<String>(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .anasayfaToken),
                                                    ),
                                                  ],
                                                );
                                              },
                                              child: Icon(
                                                Icons.diamond,
                                                size: 24.0,
                                                color: Color.fromARGB(
                                                    255, 119, 46, 141),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Container(
                                height: widget.newstoryImages.length > 0
                                    ? 105.0
                                    : 0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.newstoryImages.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StoryScreen(
                                              storyies: widget.newstoryImages,
                                              // storyImages: _storyImagesLink,
                                              startingPage: index,
                                              referansAktif:
                                                  widget.referansAktif,
                                              referansList: widget.referansList,
                                              userData: widget.userData,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 65.0,
                                              height: 65.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 55, 105, 245),
                                                    // Color.fromARGB(255, 50, 200, 255),
                                                    Color.fromARGB(
                                                        255, 168, 60, 187),
                                                  ],
                                                ),
                                                border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 3.0,
                                                ), // Halkanın rengi ve genişliği
                                              ),
                                              child: CircleAvatar(
                                                radius: 30.0,
                                                backgroundImage: NetworkImage(
                                                    widget.newstoryImages[index]
                                                        ['imageLink']),
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  75, // Genişliği 40 piksel ile sınırla
                                              child: Text(
                                                widget.newstoryImages[index]
                                                        ['header']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                ),
                                                softWrap:
                                                    true, // Metni yumuşak bir şekilde sar
                                                overflow: TextOverflow
                                                    .visible, // Taşan metni görünür yap
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  // SizedBox(height: 10),

                  Divider(
                    height: 6,
                  ),
                  SizedBox(height: 10),
                  // Resim
                  TrimesterProgressWidget(
                    userData: widget.userData,
                  ),
                  SizedBox(height: 10),
                  FunctionsWidget(
                    onFunction1Pressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return SpinningWheel(
                          userData: widget.userData,
                          pageType: 'waterDrinkData',
                          pageItems: {
                            'Bardak': "200",
                            'Buyuk Bardak': "300",
                            'Matara': "500",
                            'Sise': "750",
                            'Surahi': "1000",
                          },
                          selectedItem: 'Bardak',
                          selectedValue: '200',
                          suTakipBugunListesi:
                              AppLocalizations.of(context)!.suTakipBugunListesi,
                          suTakipGunIciHatirlatici:
                              AppLocalizations.of(context)!
                                  .suTakipGunIciHatirlatici,
                          suTakipGunlukOzet:
                              AppLocalizations.of(context)!.suTakipGunlukOzet,
                          suTakipHicSuIcmedin:
                              AppLocalizations.of(context)!.suTakipHicSuIcmedin,
                          suTakipSuGecmisi:
                              AppLocalizations.of(context)!.suTakipSuGecmisi,
                          suTakipSuTakipAyarlariniz:
                              AppLocalizations.of(context)!
                                  .suTakipSuTakipAyarlariniz,
                          suTakipSuhedefi:
                              AppLocalizations.of(context)!.suTakipSuhedefi,
                          suTakipgunlukSuHedefi: AppLocalizations.of(context)!
                              .suTakipgunlukSuHedefi,
                          kaydet: AppLocalizations.of(context)!.gunlukKaydet,
                          saat: AppLocalizations.of(context)!.takvimSaat,
                          language: AppLocalizations.of(context)!.language,
                        );
                      })).then((value) {
                        _fetchUserData();
                      });
                      ;

                      print("Test1");
                    },
                    onFunction2Pressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KiloTakipPage(
                                  userData: widget.userData,
                                  language:
                                      AppLocalizations.of(context)!.language,
                                )),
                      ).then((value) {
                        _fetchUserData();
                      });
                      print("Test1");
                    },
                    onFunction3Pressed: () {
                      print("Test1");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IlacTakip(
                                  userData: widget.userData,
                                  language:
                                      AppLocalizations.of(context)!.language,
                                )),
                      ).then((value) {
                        _fetchUserData();
                      });
                    },
                    onFunction4Pressed: () {
                      if (AppLocalizations.of(context)!.language == "Türkçe") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => YapilacaklarPage(
                                    userData: widget.userData,
                                    hamilelikYapilacaklar:
                                        hamilelikYapilacaklar,
                                  )),
                        ).then((value) {
                          _fetchUserData();
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => YapilacaklarPage(
                                    userData: widget.userData,
                                    hamilelikYapilacaklar:
                                        hamilelikYapilacaklar_en,
                                  )),
                        ).then((value) {
                          _fetchUserData();
                        });
                      }

                      print("Test1");
                    },
                    function1Description:
                        AppLocalizations.of(context)!.anasayfaSuTakibi,
                    function2Description:
                        AppLocalizations.of(context)!.anasayfaKiloTakibi,
                    function3Description:
                        AppLocalizations.of(context)!.anasayfailacVitamin,
                    function4Description:
                        AppLocalizations.of(context)!.anasayfaYapilacaklar,
                  ),
                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HaftalikGuncellemeWidget(
                            userData: widget.userData,
                            language: AppLocalizations.of(context)!.language,
                            referansAktif: widget.referansAktif,
                            referansList: widget.referansList,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.width *
                          0.95 *
                          (90 / MediaQuery.of(context).size.width),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/background.jpeg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 1,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 52, 19, 57).withOpacity(
                                    0.7), // Opaklık değerini ayarlayabilirsiniz

                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                '$selectedWeek. ${AppLocalizations.of(context)!.anasayfaSizeOzel}',
                                // '$selectedWeek. Hafta için\nSize Özel Bilgilere Bakın😇',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // Metin rengini beyaz olarak ayarladık
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Renkli kutular
                  Column(
                    children: List.generate(widget.storyImages.length, (index) {
                      int reverseIndex = widget.storyImages.length - 1 - index;
                      return Column(
                        children: [
                          Divider(),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: widget.storyImages[reverseIndex]
                                        ['imageLink'] !=
                                    ""
                                ? Image.network(
                                    widget.storyImages[reverseIndex]
                                        ['imageLink'],
                                    fit: BoxFit.cover,
                                  )
                                : CircularProgressIndicator(),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 20.0,
                            decoration: BoxDecoration(
                              // color: Colors.primaries[reverseIndex %
                              //     Colors.primaries.length], // Renkli kutular
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              "${widget.storyImages[reverseIndex]['baslik']}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 20.0,
                            decoration: BoxDecoration(
                              // color: Colors.primaries[reverseIndex %
                              //     Colors.primaries.length], // Renkli kutular
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.storyImages[reverseIndex]['icerik'].substring(0, 20)} ... ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                widget.storyImages[reverseIndex]['premium']
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (widget.userData![
                                                  'userSubscription'] !=
                                              "Free") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MakaleDetay(
                                                  baslik: widget.storyImages[
                                                      reverseIndex]['baslik'],
                                                  icerik: widget
                                                      .storyImages[reverseIndex]
                                                          ['icerik']
                                                      .toString()
                                                      .replaceAll('%', '\n'),
                                                  resimURL: widget.storyImages[
                                                          reverseIndex]
                                                      ['imageLink'],
                                                  referansAktif:
                                                      widget.referansAktif,
                                                  referansList:
                                                      widget.referansList,
                                                  userData: widget.userData,
                                                ),
                                              ),
                                            );
                                          } else {
                                            await reklamGoster();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MakaleDetay(
                                                  baslik: widget.storyImages[
                                                      reverseIndex]['baslik'],
                                                  icerik: widget
                                                      .storyImages[reverseIndex]
                                                          ['icerik']
                                                      .toString()
                                                      .replaceAll('%', '\n'),
                                                  resimURL: widget.storyImages[
                                                          reverseIndex]
                                                      ['imageLink'],
                                                  referansAktif:
                                                      widget.referansAktif,
                                                  referansList:
                                                      widget.referansList,
                                                  userData: widget.userData,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                                  .devamEt +
                                              " to Premium Content💎",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.purple,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.bold,
                                            background: Paint()
                                              ..color = Colors.transparent
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 1.5
                                              ..strokeJoin = StrokeJoin.round,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, 0),
                                                blurRadius: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MakaleDetay(
                                                      baslik:
                                                          widget.storyImages[
                                                                  reverseIndex]
                                                              ['baslik'],
                                                      icerik: widget
                                                          .storyImages[
                                                              reverseIndex]
                                                              ['icerik']
                                                          .toString()
                                                          .replaceAll(
                                                              '%', '\n'),
                                                      resimURL:
                                                          widget.storyImages[
                                                                  reverseIndex]
                                                              ['imageLink'],
                                                      referansAktif:
                                                          widget.referansAktif,
                                                      referansList:
                                                          widget.referansList,
                                                      userData: widget.userData,
                                                    )),
                                          );
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.devamEt,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.bold,
                                            background: Paint()
                                              ..color = Colors.transparent
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 1.5
                                              ..strokeJoin = StrokeJoin.round,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, 0),
                                                blurRadius: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          index < widget.storyImages.length - 1
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox()
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        _aktivitelerAcik
            ? GestureDetector(
                onTap: () {},
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              )
            : SizedBox(),
        // SizedBox(height: 10),
        widget.yaklasanAktiviteHome
            ? AnimatedOpacity(
                opacity: _isVisibleYaklasanAktiviteler ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _isVisibleYaklasanAktiviteler
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ExpansionTile(
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    _aktivitelerAcik = expanded;
                                  });
                                },
                                title: Row(
                                  children: [
                                    Icon(Icons.info_rounded),
                                    Text(
                                      AppLocalizations.of(context)!
                                              .anasayfaAktiviteler +
                                          // 'Yaklaşan Aktiviteler' +
                                          (activities.keys.toList().length != 0
                                              ? " (${activities.keys.toList().length.toString()})"
                                              : ""),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SizedBox()),
                                  ...activities.entries.map((entry) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                              entry.value.split('%%%')[3] +
                                                  " " +
                                                  entry.value.split('%%%')[1],
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                entry.value.split('%%%')[2] +
                                                    "   " +
                                                    formatDate(entry.value
                                                        .split('%%%')[0]
                                                        .split(' ')[0]),
                                              ),
                                              entry.value.split('%%%')[4] ==
                                                      true
                                                  ? Icon(Icons.alarm_on)
                                                  : Icon(Icons.alarm_off)
                                            ],
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    );
                                  }).toList(),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Calendar(
                                              userData: widget.userData,
                                              ekranYukseklikKontrol: 1,
                                            ),
                                          ),
                                        ).then((_) {
                                          // Navigator.pop ile geri dönüldüğünde burası çalışacak
                                          _fetchUserData(); // Çağırmak istediğiniz fonksiyon
                                        });
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .anasayfaAktiviteEkle,
                                        // "Aktivite Ekle",

                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.bold,
                                          background: Paint()
                                            ..color = Colors.transparent
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1.5
                                            ..strokeJoin = StrokeJoin.round,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              offset: Offset(0, 0),
                                              blurRadius: 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}

void main() {
  // Flutter framework içinde oluşan hataları yakala
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Hata mesajını göster
    _showError(details.exceptionAsString());
  };

  // Dart Zone içinde oluşan hataları yakala
  runZonedGuarded(() {
    runApp(MaterialApp(
      home: AnaSayfa(
          storyImages: [
            // Story Images'larınızı ekleyin
          ],
          newstoryImages: [],
          referansAktif: true,
          referansList: [],
          yaklasanAktiviteHome: true),
    ));
  }, (error, stackTrace) {
    // Hata mesajını göster
    _showError(error.toString());
  });
}

void _showError(String error) {
  // Global key aracılığıyla ScaffoldMessenger'a erişim
  final globalKey = GlobalKey<ScaffoldMessengerState>();
  globalKey.currentState?.showSnackBar(
    SnackBar(
      content: Text('Error: $error'),
    ),
  );
}
