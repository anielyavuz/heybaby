import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/jsonFiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrimesterProgressWidget extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const TrimesterProgressWidget({Key? key, this.userData}) : super(key: key);

  @override
  State<TrimesterProgressWidget> createState() =>
      _TrimesterProgressWidgetState();
}

class _TrimesterProgressWidgetState extends State<TrimesterProgressWidget> {
  late Map jsonList = {}; // Global değişken tanımı
  late Map jsonList0 = {};
  late int _kacinciHafta = 5;
  late DateTime _currentDay = DateTime.now();
  imageandInfoJsonFileLoad() async {
    jsonList0 =
        await JsonReader.readJson(AppLocalizations.of(context)!.language);
    setState(() {
      jsonList = jsonList0;
    });
    // print(jsonList);
  }

  suBildirimleriniSil() async {
    var _bildirimler =
        await AwesomeNotifications().listScheduledNotifications();
    List _bildirimIdleri = [];
    for (var _bildirim in _bildirimler) {
      _bildirimIdleri.add(_bildirim.content!.id);
    }
    int _kacGunlukSuBildirimi =
        20; //kac gunluk su bildiriminin kurulacağı ile ilgili konu. Bu değerin yarısından küçük değerde uygulamaya girildiğinde bildirimler yenilenir.

    DateTime _simdi = DateTime.now();
    DateTime _endDate = _simdi.add(Duration(days: _kacGunlukSuBildirimi));

    String _ay = "";
    String _gun = "";
    if (_simdi.month < 10) {
      _ay = "0${_simdi.month}";
    } else {
      _ay = "${_simdi.month}";
    }
    if (_simdi.day < 10) {
      _gun = "0${_simdi.day}";
    } else {
      _gun = "${_simdi.day}";
    }
    int _startDate = int.parse("${_simdi.year}${_ay}${_gun}");

    String _ay2 = "";
    String _gun2 = "";
    if (_endDate.month < 10) {
      _ay2 = "0${_endDate.month}";
    } else {
      _ay2 = "${_endDate.month}";
    }
    if (_endDate.day < 10) {
      _gun2 = "0${_endDate.day}";
    } else {
      _gun2 = "${_endDate.day}";
    }
    int _finishDate = int.parse("${_endDate.year}${_ay2}${_gun2}");

    List _SuBildirimIDLeri = [];
    for (var _bildirimId in _bildirimIdleri) {
      if (_startDate <= _bildirimId && _bildirimId < _finishDate) {
        _SuBildirimIDLeri.add(_bildirimId);
        // print("$_startDate,$_finishDate,$_bildirimId");
      } else {}
    }
    for (var _SuBildirimID in _SuBildirimIDLeri) {
      var _iptal = await AwesomeNotifications().cancel(_SuBildirimID);
    }
    print("Günlük su özet bildirimleri temizlendi...");
  }

  suBildiriminiOlustur() async {
    bool _gunlukOzetBildirimAcikKapali = true;
    if (widget.userData!.containsKey('suBildirimTakipSistemi')) {
      setState(() {
        _gunlukOzetBildirimAcikKapali =
            widget.userData!['suBildirimTakipSistemi']['waterSummary'];
      });
    }
    if (_gunlukOzetBildirimAcikKapali) {
      var _bildirimler =
          await AwesomeNotifications().listScheduledNotifications();
      List _bildirimIdleri = [];
      for (var _bildirim in _bildirimler) {
        _bildirimIdleri.add(_bildirim.content!.id);
      }
      int _kacGunlukSuBildirimi =
          20; //kac gunluk su bildiriminin kurulacağı ile ilgili konu. Bu değerin yarısından küçük değerde uygulamaya girildiğinde bildirimler yenilenir.
      bool _kontrol = true;
      DateTime _simdi = DateTime.now();
      DateTime _endDate = _simdi.add(Duration(days: _kacGunlukSuBildirimi));

      String _ay = "";
      String _gun = "";
      if (_simdi.month < 10) {
        _ay = "0${_simdi.month}";
      } else {
        _ay = "${_simdi.month}";
      }
      if (_simdi.day < 10) {
        _gun = "0${_simdi.day}";
      } else {
        _gun = "${_simdi.day}";
      }
      int _startDate = int.parse("${_simdi.year}${_ay}${_gun}");

      String _ay2 = "";
      String _gun2 = "";
      if (_endDate.month < 10) {
        _ay2 = "0${_endDate.month}";
      } else {
        _ay2 = "${_endDate.month}";
      }
      if (_endDate.day < 10) {
        _gun2 = "0${_endDate.day}";
      } else {
        _gun2 = "${_endDate.day}";
      }
      int _finishDate = int.parse("${_endDate.year}${_ay2}${_gun2}");
      int _totalSuBildirimSayisi = 0;
      List _SuBildirimIDLeri = [];
      for (var _bildirimId in _bildirimIdleri) {
        if (_startDate <= _bildirimId && _bildirimId < _finishDate) {
          _kontrol = false;
          _totalSuBildirimSayisi += 1;
          _SuBildirimIDLeri.add(_bildirimId);
          // print("$_startDate,$_finishDate,$_bildirimId");
        } else {}
      }
      // print(
      //     "${_SuBildirimIDLeri.length} - ${_kacGunlukSuBildirimi / 2}  -Toplam su bildirimi sayisi ${_SuBildirimIDLeri.length < _kacGunlukSuBildirimi / 2}");

      if (_SuBildirimIDLeri.length < _kacGunlukSuBildirimi / 2) {
        for (var _SuBildirimID in _SuBildirimIDLeri) {
          var _iptal = await AwesomeNotifications().cancel(_SuBildirimID);
        }
        DateTime now = DateTime.now();
        DateTime endDate = now.add(Duration(
            days:
                _kacGunlukSuBildirimi)); // Mevcut tarihten itibaren 1 yıl ekleyin
        for (DateTime date = now;
            date.isBefore(endDate);
            date = date.add(Duration(days: 1))) {
          String _ay = "";
          String _gun = "";
          if (date.month < 10) {
            _ay = "0${date.month}";
          } else {
            _ay = "${date.month}";
          }
          if (date.day < 10) {
            _gun = "0${date.day}";
          } else {
            _gun = "${date.day}";
          }
          int _id = int.parse("${date.year}${_ay}${_gun}");
          // print('${date.year}${date.month}${date.day}');

          await BildirimTakip.gunlukSuIc(_id, 19, 00, date.day, date.month,
              date.year, AppLocalizations.of(context)!.language);
          await Future.delayed(Duration(milliseconds: 350));
        }
      } else {
        print("Günlük su içme bildirimleri kurulu ve yeterli sayıdadır");
      }
    } else {
      print("Bildirim ayarları kapalı silinecek..");
      suBildirimleriniSil();
    }
  }

  haftalikBoyutBildirimOlustur() async {
    var _bildirimler =
        await AwesomeNotifications().listScheduledNotifications();
    List _bildirimIdleri = [];
    for (var _bildirim in _bildirimler) {
      _bildirimIdleri.add(_bildirim.content!.id);
    }
    bool _kontrol = true;
    for (var _bildirimId in _bildirimIdleri) {
      if (_bildirimId < 1050) {
        _kontrol = false;
      } else {}
    }
    if (_kontrol) {
      int sayac = 0;
      for (var i = _kacinciHafta + 1; i < 41; i++) {
        String _testImageLink = "";
        String _testBenzerlik = "";

        if (i < 41) {
          if (i >= 4) {
            _testImageLink = jsonList[i - 4]['foto_link'];
            _testBenzerlik = jsonList[i - 4]['benzerlik'];
          } else {
            _testImageLink = jsonList[0]['foto_link'];
            _testBenzerlik = jsonList[0]['benzerlik'];
          }
        } else {
          _testImageLink = jsonList[36]['foto_link'];
          _testBenzerlik = jsonList[36]['benzerlik'];
        }
        // print("_testBenzerlik Test $_testBenzerlik");

        Future.delayed(const Duration(milliseconds: 50), () {
          imageandInfoJsonFileLoad();
        });

        await BildirimTakip.haftalikBoyutBilgisi(
            (i + 1000),
            _testBenzerlik,
            _testImageLink,
            10,
            00,
            _currentDay
                .add(Duration(days: (8 - _currentDay.weekday) + sayac))
                .day,
            _currentDay
                .add(Duration(days: (8 - _currentDay.weekday) + sayac))
                .month,
            _currentDay
                .add(Duration(days: (8 - _currentDay.weekday) + sayac))
                .year,
            AppLocalizations.of(context)!.language);

        // print("Ana sayfa boyut bildirimleri yok, yazılıyor. -- " +
        //     (i + 1000).toString());
        sayac = sayac + 7;
      }
    } else {
      print("haftalık bildirimler kurulu durumda.");
      // print(_bildirimIdleri);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 50), () {
      imageandInfoJsonFileLoad();
    });
    // Future.delayed(const Duration(milliseconds: 3000), () {
    //   haftalikBoyutBildirimOlustur();
    // });

    // Future.delayed(const Duration(milliseconds: 14000), () {
    //   suBildiriminiOlustur();
    // });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    DateTime startDate =
        widget.userData == null || widget.userData!['sonAdetTarihi'] == null
            ? DateTime.now().add(Duration(days: -1))
            : DateTime.parse(widget.userData!['sonAdetTarihi']);

    DateTime endDate =
        widget.userData == null || widget.userData!['sonAdetTarihi'] == null
            ? DateTime.now().add(Duration(days: 279))
            : DateTime.parse(widget.userData!['sonAdetTarihi'])
                .add(Duration(days: 280));
    double totalDays = endDate.difference(startDate).inDays.toDouble();
    double passedDays = currentDate.difference(startDate).inDays.toDouble();
////
    int differenceInDays = endDate.difference(currentDate).inDays;
    int _dogumaKalanHafta = differenceInDays ~/ 7;
////
    ///
    ///
    ///
    ///
    Duration difference = currentDate.difference(startDate);

    int differenceDays = difference.inDays;
    int weeks = differenceDays ~/ 7;
    int remainingDays = differenceDays % 7;
    String _tahminiKilo = "";
    String _tahminiBoy = "";
    String _imageLink = "";
    String _gifLink = "";
    String _benzerlik = "";

    _kacinciHafta = weeks;
    if (jsonList.isNotEmpty) {
      if (weeks < 41) {
        if (weeks >= 4) {
          _tahminiKilo = jsonList['$weeks']['kilo'];
          _tahminiBoy = jsonList['$weeks']['boy'];
          _imageLink = jsonList['$weeks']['foto_link'];
          _benzerlik = jsonList['$weeks']['benzerlik'];
          _gifLink = jsonList['$weeks']['gif_link'];
        } else {
          _tahminiKilo = jsonList['4']['kilo'];
          _tahminiBoy = jsonList['4']['boy'];
          _imageLink = jsonList['4']['foto_link'];
          _benzerlik = jsonList['4']['benzerlik'];
          _gifLink = jsonList['4']['gif_link'];
        }
      } else {
        _tahminiKilo = jsonList['40']['kilo'];
        _tahminiBoy = jsonList['40']['boy'];
        _imageLink = jsonList['40']['foto_link'];
        _benzerlik = jsonList['40']['benzerlik'];
        _gifLink = jsonList['40']['gif_link'];
      }
    }

    String _mevcutTarih;
    if (weeks > 0) {
      _mevcutTarih = '$weeks. ${AppLocalizations.of(context)!.hafta}';
      if (remainingDays > 0) {
        _mevcutTarih += ' $remainingDays. ${AppLocalizations.of(context)!.gun}';
      }
    } else {
      _mevcutTarih = '$remainingDays. ${AppLocalizations.of(context)!.gun}';
    }

    ///
    ///

    double progress = passedDays / totalDays;
    // print("progress " + progress.toString());
    double firstTrimesterProgress = progress.clamp(0.0, 0.333);
    // print("progress1 " + firstTrimesterProgress.toString());
    double secondTrimesterProgress = (progress.clamp(0.333, 0.666)) - 0.333;
    // print("progress2 " + secondTrimesterProgress.toString());
    double thirdTrimesterProgress = (progress.clamp(0.666, 1.0) - 0.666);
    // print("progress3 " + thirdTrimesterProgress.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              // 1. Trimester
              Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: firstTrimesterProgress * 300,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffcdb4db),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: (0.05) *
                            300), // Soldan 16 birimlik bir padding ekler
                    child: Text(
                      "1.${AppLocalizations.of(context)!.trimester}",
                      style: TextStyle(
                          fontSize:
                              14.0), // Opsiyonel olarak stil ekleyebilirsiniz
                    ),
                  )
                ],
              ),
              // 2. Trimester
              Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: secondTrimesterProgress * 300,
                    height: 30,
                    margin: EdgeInsets.only(left: firstTrimesterProgress * 300),
                    decoration: BoxDecoration(
                      color: Color(0xff80ed99),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: (0.373) *
                            300), // Soldan 16 birimlik bir padding ekler
                    child: Text(
                      "2.${AppLocalizations.of(context)!.trimester}",
                      style: TextStyle(
                          fontSize:
                              14.0), // Opsiyonel olarak stil ekleyebilirsiniz
                    ),
                  )
                ],
              ),
              // 3. Trimester
              Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: thirdTrimesterProgress * 300,
                    height: 30,
                    margin: EdgeInsets.only(
                        left:
                            (firstTrimesterProgress + secondTrimesterProgress) *
                                300),
                    decoration: BoxDecoration(
                      color: Color(0xffff4d6d),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: (0.696) *
                            300), // Soldan 16 birimlik bir padding ekler
                    child: Text(
                      "3.${AppLocalizations.of(context)!.trimester}",
                      style: TextStyle(
                          fontSize:
                              14.0), // Opsiyonel olarak stil ekleyebilirsiniz
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        _dogumaKalanHafta > 0
            ? Text(
                '${AppLocalizations.of(context)!.anasayfaFotoDogumaYaklasik1}$_dogumaKalanHafta${AppLocalizations.of(context)!.anasayfaFotoDogumaYaklasik2}',
                style: TextStyle(fontSize: 15),
              )
            : Text(
                AppLocalizations.of(context)!.anasayfaFotoDogumaYaklasik3,
                // 'Doğum çok yakında 😇',
                style: TextStyle(fontSize: 15),
              ),
        SizedBox(height: 5),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: _imageLink != ""
              ? Image.network(
                  _gifLink,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Yükleme tamamlandıysa görüntüyü göster
                    } else {
                      return Image.network(
                        _imageLink, // Yükleme sürecinde gösterilecek ikinci bir GIF
                        fit: BoxFit.cover,
                      );
                    }
                  },
                )
              : CircularProgressIndicator(),
        ),
        Text(
            "${AppLocalizations.of(context)!.anasayfaFotoBebeginizBoyu1} $_benzerlik ${AppLocalizations.of(context)!.anasayfaFotoBebeginizBoyu2}",
            // "Bebeğiniz şuan bir $_benzerlik boyutunda",
            style: TextStyle(fontSize: 14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${AppLocalizations.of(context)!.boyu}: $_tahminiBoy',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '$_mevcutTarih',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '${AppLocalizations.of(context)!.kilosu}: $_tahminiKilo',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
