import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

  AnaSayfa(
      {Key? key,
      this.userData,
      required this.newstoryImages,
      required this.storyImages})
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
            sonrakiTarih.year);

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
                                                boxPersons.put(
                                                    'currentToken',
                                                    Person(
                                                        token: 50,
                                                        subnName: 'myToken'));
                                              },
                                              child: Icon(
                                                Icons.diamond,
                                                size: 24.0,
                                                color: Color.fromARGB(
                                                    255, 119, 46, 141),
                                              ),
                                            ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => YapilacaklarPage(
                                  userData: widget.userData,
                                )),
                      ).then((value) {
                        _fetchUserData();
                      });

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
                              userData: widget.userData),
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
                                  "${widget.storyImages[reverseIndex]['icerik'].substring(0, 30)} ... ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MakaleDetay(
                                              baslik: widget
                                                      .storyImages[reverseIndex]
                                                  ['baslik'],
                                              icerik: widget
                                                  .storyImages[reverseIndex]
                                                      ['icerik']
                                                  .toString()
                                                  .replaceAll('%', '\n'),
                                              resimURL: widget
                                                      .storyImages[reverseIndex]
                                                  ['imageLink'])),
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

        AnimatedOpacity(
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
                                        entry.value.split('%%%')[4] == true
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
        ),
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
      ),
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
