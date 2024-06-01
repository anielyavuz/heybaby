import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/anasayfa.dart';
import 'package:heybaby/pages/authentication.dart';

class SpinningWheel extends StatelessWidget {
  final Map<String, dynamic>? userData;
  String pageType;
  Map<String, String> pageItems;
  String selectedItem;
  String selectedValue;

  SpinningWheel({
    required this.userData,
    required this.pageType,
    required this.pageItems,
    required this.selectedItem,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(),
        body: Center(
          child: RotatingHalfWheel(
            userData: userData,
            pageType: pageType,
            pageItems: pageItems,
            selectedItem: selectedItem,
            selectedValue: selectedValue,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RotatingHalfWheel extends StatefulWidget {
  Map<String, dynamic>? userData;
  String pageType;
  Map<String, String> pageItems;
  String selectedItem;
  String selectedValue;
  RotatingHalfWheel({
    required this.userData,
    required this.pageType,
    required this.pageItems,
    required this.selectedItem,
    required this.selectedValue,
  });

  @override
  _RotatingHalfWheelState createState() => _RotatingHalfWheelState();
}

class _RotatingHalfWheelState extends State<RotatingHalfWheel> {
  // final Map<String, String> _items = {
  //   'Bardak': "200",
  //   'Buyuk_Bardak': "300",
  //   'Matara': "500",
  //   'Sise': "750",
  //   'Surahi': "1000",
  // };

  // String _selectedItem = 'Bardak';
  // String _selectedValue = "200";
  List<Map> _history = [];
  int _historyValue = 0;
  int _targetValue = 2000;
  int _count = 1;
  late List pastItems;

//bildirim ve günlük su hedefi ekranı ayarları
  List notificationTimes = [
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
  ];
  int waterIntake = 2500;
  bool waterReminder = true;
  bool waterSummary = true;
//bildirim ve günlük su hedefi ekranı ayarları

/////
  ///
  Future<void> _showIlkSUNotificationTimesModal() async {
    await Future.delayed(Duration(milliseconds: 550));
    print('_showIlkSUNotificationTimesModal değeri kontrol ediliyor.');
    List<TimeOfDay> notificationTimes = [
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 13, minute: 0),
      TimeOfDay(hour: 18, minute: 0),
    ];

    int waterIntake = 2500;
    bool waterReminder = true;
    bool waterSummary = true;
    final result = await showModalBottomSheet<List<TimeOfDay>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void _addNotificationTime() async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                setModalState(() {
                  notificationTimes.add(pickedTime);
                });
              }
            }

            void _editNotificationTime(int index) async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: notificationTimes[index],
              );

              if (pickedTime != null) {
                setModalState(() {
                  notificationTimes[index] = pickedTime;
                });
              }
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Su Takip Ayarlarınız',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Günlük Su Hedefi'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setModalState(() {
                                if (waterIntake > 100) waterIntake -= 100;
                              });
                            },
                          ),
                          Text('$waterIntake ml'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setModalState(() {
                                waterIntake += 100;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Günlük Özet Bildirimi'),
                      Checkbox(
                        value: waterSummary,
                        onChanged: (bool? value) {
                          setModalState(() {
                            waterSummary = value ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gün İçi Hatırlatıcıları'),
                      Checkbox(
                        value: waterReminder,
                        onChanged: (bool? value) {
                          setModalState(() {
                            waterReminder = value ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                  waterReminder
                      ? Container(
                          decoration: BoxDecoration(
                            // color: Colors.blue, // Arka plan rengi
                            borderRadius:
                                BorderRadius.circular(10), // Kenar yuvarlatma
                            border: Border.all(
                                color: Colors.black), // Kenar çizgisi
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text('Saat'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {},
                                    ),
                                    Row(
                                      children: notificationTimes
                                          .map(
                                            (time) => Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255,
                                                        153,
                                                        51,
                                                        255), // Çerçeve rengi
                                                    width:
                                                        1.0, // Çerçeve kalınlığı
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Opsiyonel: Köşelerin yuvarlaklığı
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: GestureDetector(
                                                        child: Text(
                                                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        onTap: () {
                                                          print(
                                                              notificationTimes);
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime: time,
                                                          ).then((pickedTime) {
                                                            if (pickedTime !=
                                                                null) {
                                                              setModalState(() {
                                                                notificationTimes
                                                                    .remove(
                                                                        time);
                                                                notificationTimes
                                                                    .add(
                                                                        pickedTime);
                                                                notificationTimes
                                                                    .sort((a, b) => a
                                                                        .hour
                                                                        .compareTo(
                                                                            b.hour));
                                                              });

                                                              print(
                                                                  notificationTimes);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 38,
                                                      width: 40,
                                                      child: IconButton(
                                                        iconSize: 20,
                                                        icon: Icon(
                                                          Icons.remove_circle,
                                                          // size: 20,
                                                        ),
                                                        onPressed: () {
                                                          setModalState(() {
                                                            notificationTimes
                                                                .remove(time);
                                                          });
                                                          notificationTimes
                                                              .sort((a, b) => a
                                                                  .hour
                                                                  .compareTo(
                                                                      b.hour));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )

                      // ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: notificationTimes.length,
                      //     itemBuilder: (context, index) {
                      //       return ListTile(
                      //         title: Text(
                      //             notificationTimes[index].format(context)),
                      //         trailing: IconButton(
                      //           icon: Icon(Icons.edit),
                      //           onPressed: () {
                      //             _editNotificationTime(index);
                      //           },
                      //         ),
                      //       );
                      //     },
                      //   )

                      : SizedBox(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!waterReminder) {
                          setModalState(() {
                            notificationTimes = [];
                          });
                        } else {
                          Navigator.pop(context);
                          var _bildirimler = await AwesomeNotifications()
                              .listScheduledNotifications();
                          List _bildirimIdleri = [];
                          // print("AAAAAAAA");
                          for (var _bildirim in _bildirimler) {
                            // print(_bildirim.content!.id);
                          }
                          print(notificationTimes);

                          for (var i = 0; i < notificationTimes.length; i++) {
                            var time = notificationTimes[i];
                            var simdi = DateTime.now();
                            var hours = time.hour.toString().padLeft(2, '0');
                            var minutes =
                                time.minute.toString().padLeft(2, '0');
                            var formattedTimeString = "100${hours}${minutes}";
                            var formattedTime = int.parse(formattedTimeString);
                            print(formattedTime);
                            print(time);
                            print(simdi);
                            BildirimTakip.gunIciSuHatirlatici(
                                formattedTime,
                                time.hour,
                                time.minute,
                                simdi.day,
                                simdi.month,
                                simdi.year);
                            await Future.delayed(Duration(milliseconds: 350));
                          }

                          var _bildirimler2 = await AwesomeNotifications()
                              .listScheduledNotifications();

                          // print("AAAAAAAA");
                          for (var _bildirim in _bildirimler2) {
                            // print(_bildirim.content!.id);
                          }
                          print(notificationTimes);
                        }
                        if (waterSummary) {
                          var now = DateTime.now();
                          DateTime firstNotificationDate =
                              DateTime(now.year, now.month, now.day, 19, 30, 0);

                          BildirimTakip.gunlukSuIcYeni(
                              firstNotificationDate.hour,
                              firstNotificationDate.minute,
                              firstNotificationDate.day,
                              firstNotificationDate.month,
                              firstNotificationDate.year);
                        } else {}
                        var _result = await FirestoreFunctions
                            .suBildirimTakipSistemiOlustur(waterIntake,
                                waterSummary, waterReminder, notificationTimes);
                      },
                      child: Text('Kaydet'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        notificationTimes = result;
      });
      print(notificationTimes.map((time) => time.format(context)).toList());
    }
  }

  ///
  ///

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

          await BildirimTakip.gunlukSuIc(
              _id, 19, 00, date.day, date.month, date.year);
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

  @override
  void initState() {
    super.initState();

    if (widget.userData != null &&
        widget.userData!.containsKey('dataRecord') &&
        widget.userData!['dataRecord'] != null &&
        widget.userData!['dataRecord'].containsKey(widget.pageType)) {
      if (widget.userData!.containsKey('suBildirimTakipSistemi')) {
        setState(() {
          waterIntake = widget.userData!['suBildirimTakipSistemi']['suHedefi'];
          List stringTimes =
              widget.userData!['suBildirimTakipSistemi']['waterReminderTimes'];

          notificationTimes = stringTimes.map((time) {
            final parts = time.split(':'); // String'i ':' karakterinden böler
            final hour =
                int.parse(parts[0]); // Saat kısmını alır ve integer'a çevirir
            final minute =
                int.parse(parts[1]); // Dakika kısmını alır ve integer'a çevirir
            return TimeOfDay(hour: hour, minute: minute);
          }).toList();

          waterReminder =
              widget.userData!['suBildirimTakipSistemi']['waterReminder'];
          waterSummary =
              widget.userData!['suBildirimTakipSistemi']['waterSummary'];
          _targetValue = waterIntake;
        });
      } else {
        _showIlkSUNotificationTimesModal();
      }

      var historyData = widget.userData!['dataRecord'][widget.pageType];

      if (historyData is List) {
        // Bugünün tarihini al
        var now = DateTime.now();
        var today = DateTime(now.year, now.month, now.day);

        // Bugünün tarihine sahip olan öğeleri filtrele
        var todayItems = historyData.where((item) {
          var itemDate =
              item['date'].toDate(); // Timestamp'ı DateTime'a dönüştür
          var itemDateOnly =
              DateTime(itemDate.year, itemDate.month, itemDate.day);
          return itemDateOnly.isAtSameMomentAs(today);
        }).toList();

        pastItems = historyData.where((item) {
          var itemDate =
              item['date'].toDate(); // Timestamp'ı DateTime'a dönüştür
          var itemDateOnly =
              DateTime(itemDate.year, itemDate.month, itemDate.day);
          return itemDateOnly.isBefore(today);
        }).toList();

        _history = List<Map<dynamic, dynamic>>.from(todayItems);

        _history.forEach((item) {
          print(_historyValue +
              ((item['count']).toInt() * (item['amount']).toInt()));

          if (_historyValue +
                  ((item['count']).toInt() * (item['amount']).toInt()) <=
              _targetValue) {
            var _tempValue = _historyValue +
                ((item['count']).toInt() * (item['amount']).toInt());
            _historyValue = _tempValue.toInt();
          } else {
            _historyValue = _targetValue;
          }
        });
      }
    }
  }

  _bildirimiIptalEt(_id) async {
    var _bildirimler = await AwesomeNotifications()
        .cancel(_id)
        .whenComplete(() => print("$_id bildirimi iptal edildi"));
  }

  Future<void> _refresh() async {
    setState(() {
      print("refresh");
    });
  }

  Future<void> _showNotificationTimesModal() async {
    final result = await showModalBottomSheet<List<TimeOfDay>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void _addNotificationTime() async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                setModalState(() {
                  notificationTimes.add(pickedTime);
                });
              }
            }

            void _editNotificationTime(int index) async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: notificationTimes[index],
              );

              if (pickedTime != null) {
                setModalState(() {
                  notificationTimes[index] = pickedTime;
                });
              }
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Su Takip Ayarlarınız',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Günlük Su Hedefi'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setModalState(() {
                                if (waterIntake > 100) waterIntake -= 100;
                              });
                            },
                          ),
                          Text('$waterIntake ml'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setModalState(() {
                                waterIntake += 100;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Günlük Özet Bildirimi'),
                      Checkbox(
                        value: waterSummary,
                        onChanged: (bool? value) {
                          setModalState(() {
                            waterSummary = value ?? true;
                          });

                          setState(() {
                            waterSummary = value ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gün İçi Hatırlatıcıları'),
                      Checkbox(
                        value: waterReminder,
                        onChanged: (bool? value) {
                          setModalState(() {
                            waterReminder = value ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                  waterReminder
                      ? Container(
                          decoration: BoxDecoration(
                            // color: Colors.blue, // Arka plan rengi
                            borderRadius:
                                BorderRadius.circular(10), // Kenar yuvarlatma
                            border: Border.all(
                                color: Colors.black), // Kenar çizgisi
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text('Saat'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((pickedTime) {
                                          if (pickedTime != null) {
                                            setModalState(() {
                                              notificationTimes.add(pickedTime);
                                              notificationTimes.sort((a, b) =>
                                                  a.hour.compareTo(b.hour));
                                            });
                                            // setState(() {
                                            //   notificationTimes.add(pickedTime);
                                            // });
                                            print(notificationTimes);
                                          }
                                        });
                                      },
                                    ),
                                    Row(
                                      children: notificationTimes
                                          .map(
                                            (time) => Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255,
                                                        153,
                                                        51,
                                                        255), // Çerçeve rengi
                                                    width:
                                                        1.0, // Çerçeve kalınlığı
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Opsiyonel: Köşelerin yuvarlaklığı
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: GestureDetector(
                                                        child: Text(
                                                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        onTap: () {
                                                          print(
                                                              notificationTimes);
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime: time,
                                                          ).then((pickedTime) {
                                                            if (pickedTime !=
                                                                null) {
                                                              setModalState(() {
                                                                notificationTimes
                                                                    .remove(
                                                                        time);
                                                                notificationTimes
                                                                    .add(
                                                                        pickedTime);
                                                                notificationTimes
                                                                    .sort((a, b) => a
                                                                        .hour
                                                                        .compareTo(
                                                                            b.hour));
                                                              });

                                                              print(
                                                                  notificationTimes);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 38,
                                                      width: 40,
                                                      child: IconButton(
                                                        iconSize: 20,
                                                        icon: Icon(
                                                          Icons.remove_circle,
                                                          // size: 20,
                                                        ),
                                                        onPressed: () {
                                                          setModalState(() {
                                                            notificationTimes
                                                                .remove(time);
                                                          });
                                                          notificationTimes
                                                              .sort((a, b) => a
                                                                  .hour
                                                                  .compareTo(
                                                                      b.hour));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )

                      // ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: notificationTimes.length,
                      //     itemBuilder: (context, index) {
                      //       return ListTile(
                      //         title: Text(
                      //             notificationTimes[index].format(context)),
                      //         trailing: IconButton(
                      //           icon: Icon(Icons.edit),
                      //           onPressed: () {
                      //             _editNotificationTime(index);
                      //           },
                      //         ),
                      //       );
                      //     },
                      //   )

                      : SizedBox(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        //var olan saatlik bildirimleri önce temizle
                        var _bildirimler = await AwesomeNotifications()
                            .listScheduledNotifications();
                        List _bildirimIdleri = [];
                        // print("AAAAAAAA");
                        for (var _bildirim in _bildirimler) {
                          if (_bildirim.content!.id! > 1000000 &&
                              _bildirim.content!.id! < 1002400) {
                            _bildirimIdleri.add(_bildirim.content!.id);
                          }
                        }
                        for (var _bildirimId in _bildirimIdleri) {
                          var _iptal =
                              await AwesomeNotifications().cancel(_bildirimId);
                          await Future.delayed(Duration(milliseconds: 350));
                          print("$_bildirimId ID'li günlük su temizlendi.");
                        }

                        //var olan saatlik bildirimleri önce temizle

                        if (!waterReminder) {
                          setModalState(() {
                            notificationTimes = [];
                          });
                        } else {
                          var _bildirimler = await AwesomeNotifications()
                              .listScheduledNotifications();
                          List _bildirimIdleri = [];
                          // print("AAAAAAAA");
                          for (var _bildirim in _bildirimler) {
                            // print(_bildirim.content!.id);
                          }
                          print(notificationTimes);

                          for (var i = 0; i < notificationTimes.length; i++) {
                            var time = notificationTimes[i];
                            var simdi = DateTime.now();
                            var hours = time.hour.toString().padLeft(2, '0');
                            var minutes =
                                time.minute.toString().padLeft(2, '0');
                            var formattedTimeString = "100${hours}${minutes}";
                            var formattedTime = int.parse(formattedTimeString);
                            print(formattedTime);
                            print(time);
                            print(simdi);
                            BildirimTakip.gunIciSuHatirlatici(
                                formattedTime,
                                time.hour,
                                time.minute,
                                simdi.day,
                                simdi.month,
                                simdi.year);

                            await Future.delayed(Duration(milliseconds: 350));
                          }
                        }
                        if (waterSummary) {
                          var now = DateTime.now();
                          DateTime firstNotificationDate =
                              DateTime(now.year, now.month, now.day, 19, 30, 0);

                          BildirimTakip.gunlukSuIcYeni(
                              firstNotificationDate.hour,
                              firstNotificationDate.minute,
                              firstNotificationDate.day,
                              firstNotificationDate.month,
                              firstNotificationDate.year);

                          // suBildiriminiOlustur();
                        } else {
                          _bildirimiIptalEt(3);

                          // suBildirimleriniSil();
                        }
                        var _result = await FirestoreFunctions
                            .suBildirimTakipSistemiOlustur(waterIntake,
                                waterSummary, waterReminder, notificationTimes);

                        setState(() {
                          _targetValue = waterIntake;
                        });
                        // if (_result['status']) {
                        //   print(
                        //       'Su bildirim ayarlarınız başarılı olarak kaydedildi.');

                        //   // ScaffoldMessenger.of(context).showSnackBar(
                        //   //   SnackBar(
                        //   //     content: Text(
                        //   //       'Su bildirim ayarlarınız başarılı olarak kaydedildi.',
                        //   //       style: TextStyle(
                        //   //         fontWeight: FontWeight.normal,
                        //   //         fontSize: 16,
                        //   //         color: Colors.black,
                        //   //       ),
                        //   //     ),
                        //   //     // action: SnackBarAction(
                        //   //     //   label: 'Aktiviteler',
                        //   //     //   onPressed: () {
                        //   //     //     print('');
                        //   //     //   },
                        //   //     // ),
                        //   //     backgroundColor: Color.fromARGB(255, 215, 193,
                        //   //         228), // Snackbar arka plan rengi
                        //   //     duration: Duration(
                        //   //         milliseconds:
                        //   //             1500), // Snackbar gösterim süresi
                        //   //     behavior: SnackBarBehavior
                        //   //         .floating, // Snackbar davranışı
                        //   //     shape: RoundedRectangleBorder(
                        //   //       // Snackbar şekli
                        //   //       borderRadius: BorderRadius.circular(10),
                        //   //     ),
                        //   //     elevation: 4, // Snackbar yükseltilmesi
                        //   //     margin: EdgeInsets.all(
                        //   //         10), // Snackbar kenar boşlukları
                        //   //   ),
                        //   // );
                        // } else {
                        //   print(
                        //     'Ayarlarınız kaydedilirken bir sorun oluştu. ${_result['value']}',
                        //   );

                        //   // ScaffoldMessenger.of(context).showSnackBar(
                        //   //   SnackBar(
                        //   //     content: Text(
                        //   //       'Ayarlarınız kaydedilirken bir sorun oluştu. ${_result['value']}',
                        //   //       style: TextStyle(
                        //   //         fontWeight: FontWeight.normal,
                        //   //         fontSize: 16,
                        //   //         color: Colors.black,
                        //   //       ),
                        //   //     ),
                        //   //     // action: SnackBarAction(
                        //   //     //   label: 'Aktiviteler',
                        //   //     //   onPressed: () {
                        //   //     //     print('');
                        //   //     //   },
                        //   //     // ),
                        //   //     backgroundColor: Color.fromARGB(255, 215, 193,
                        //   //         228), // Snackbar arka plan rengi
                        //   //     duration: Duration(
                        //   //         milliseconds:
                        //   //             1500), // Snackbar gösterim süresi
                        //   //     behavior: SnackBarBehavior
                        //   //         .floating, // Snackbar davranışı
                        //   //     shape: RoundedRectangleBorder(
                        //   //       // Snackbar şekli
                        //   //       borderRadius: BorderRadius.circular(10),
                        //   //     ),
                        //   //     elevation: 4, // Snackbar yükseltilmesi
                        //   //     margin: EdgeInsets.all(
                        //   //         10), // Snackbar kenar boşlukları
                        //   //   ),
                        //   // );
                        // }
                      },
                      child: Text('Kaydet'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        notificationTimes = result;
      });
      print(notificationTimes.map((time) => time.format(context)).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 70,
                      height: 60,
                      child: SizedBox(),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 10,
                      child: Center(
                        child: Text(
                            "Su Hedefi " +
                                _historyValue.toString() +
                                "/" +
                                _targetValue.toString(),
                            style:
                                TextStyle(fontSize: 22, color: Colors.black)),
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 60,
                      child: IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: _showNotificationTimesModal,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 10 * 4,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: MediaQuery.of(context).size.width - 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 30,
                            value: _historyValue / _targetValue,
                            backgroundColor: Color.fromARGB(255, 76, 0, 255)
                                .withOpacity(0.2),
                            color: Color.fromARGB(255, 111, 0, 255),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 250,
                          height: 250,
                          child: ListWheelScrollView(
                            itemExtent: 100,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                widget.selectedItem =
                                    widget.pageItems.keys.elementAt(index);
                                widget.selectedValue = widget.pageItems[
                                    widget.pageItems.keys.elementAt(index)]!;
                              });
                            },
                            children: widget.pageItems.keys
                                .map(
                                  (e) => Container(
                                    decoration: BoxDecoration(
                                        color: e == widget.selectedItem
                                            ? Color.fromARGB(255, 111, 0, 255)
                                            : Color.fromARGB(255, 76, 0, 255)
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    width: e == widget.selectedItem ? 100 : 60,
                                    height: e == widget.selectedItem ? 100 : 60,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/$e.png', // Örneğin, bardak.png, şişe.png gibi
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _count > 1
                              ? Text(
                                  _count.toString() + "x ",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                )
                              : SizedBox(),
                          Text(
                            widget.selectedItem +
                                " (" +
                                widget.selectedValue +
                                "ml)",
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (_count > 1) {
                                  setState(() {
                                    _count -= 1;
                                  });
                                }
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var newData = {
                                "type": widget.selectedItem,
                                "unit": "ml",
                                "amount": int.parse(widget.selectedValue),
                                "count": _count,
                                "date": DateTime.now()
                              };
                              setState(() {
                                _history.insert(0, newData);
                                print("AAAA");
                                print(_historyValue +
                                    int.parse(widget.selectedValue) * _count);
                                print(_targetValue);
                                if (_historyValue +
                                        int.parse(widget.selectedValue) *
                                            _count <
                                    _targetValue) {
                                  _historyValue +=
                                      int.parse(widget.selectedValue) * _count;
                                } else {
                                  _historyValue = _targetValue;
                                  _bildirimiIptalEt(3);
                                  var now = DateTime.now();
                                  DateTime firstNotificationDate = DateTime(
                                      now.year,
                                      now.month,
                                      now.day + 1,
                                      19,
                                      30,
                                      0);

                                  BildirimTakip.gunlukSuIcYeni(
                                      firstNotificationDate.hour,
                                      firstNotificationDate.minute,
                                      firstNotificationDate.day,
                                      firstNotificationDate.month,
                                      firstNotificationDate.year);

                                  // DateTime date = DateTime.now();

                                  // String _ay = "";
                                  // String _gun = "";
                                  // if (date.month < 10) {
                                  //   _ay = "0${date.month}";
                                  // } else {
                                  //   _ay = "${date.month}";
                                  // }
                                  // if (date.day < 10) {
                                  //   _gun = "0${date.day}";
                                  // } else {
                                  //   _gun = "${date.day}";
                                  // }
                                  // int _id =
                                  //     int.parse("${date.year}${_ay}${_gun}");
                                  // _bildirimiIptalEt(_id);
                                }
                              });

                              var _result =
                                  await FirestoreFunctions.updateDataRecord(
                                      newData, widget.pageType);
                            },
                            child: Text('Kaydet',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 46, 2, 100))),
                          ),
                          GestureDetector(
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                setState(() {
                                  _count += 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Bugünün Listesi",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      _history.length > 0
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: _history
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                        255, 76, 0, 255)
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: ListTile(
                                              title: item['count'] > 1
                                                  ? Container(
                                                      child: Text(item['count']
                                                              .toString() +
                                                          "x " +
                                                          item['type'] +
                                                          " - " +
                                                          item['amount']
                                                              .toString() +
                                                          item['unit']),
                                                    )
                                                  : Container(
                                                      child: Text("1 " +
                                                          item['type'] +
                                                          " - " +
                                                          item['amount']
                                                              .toString() +
                                                          item['unit']),
                                                    ),
                                              // subtitle: Text(
                                              //   "${item['date'].hour.toString()} : ${item['date'].minute.toString()} - ${item['date'].day.toString()}.${item['date'].month.toString()}.${item['date'].year.toString()}",
                                              //   style: TextStyle(
                                              //       fontSize: 11,
                                              //       color: Colors.black),
                                              // ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Bugün için hiç su girişiniz yok. Lütfen su iç.  🐳",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ),
                            )),
                      ElevatedButton(
                          onPressed: () {
                            // print(pastItems);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return WaterTrackingHistory(
                                pastItems: pastItems,
                                dailyPurpose: _targetValue,
                              );
                            }));
                          },
                          child: Icon(
                            Icons.history,
                            size: 25,
                            color: Color.fromARGB(255, 46, 2, 100),
                          ))
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              left: 5,
              top: 10,
              child: Container(
                height: 40,
                child: IconButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return CheckAuth();
                      }));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 35,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WaterTrackingHistory extends StatefulWidget {
  List pastItems;
  int dailyPurpose;

  WaterTrackingHistory({required this.pastItems, required this.dailyPurpose});

  @override
  _WaterTrackingHistoryState createState() => _WaterTrackingHistoryState();
}

class _WaterTrackingHistoryState extends State<WaterTrackingHistory> {
  // Liste elemanları ve hedef sayıları burada tanımlanacak
  List<String> entries = ['Su İçme', 'Egzersiz', 'Yeşil Çay', 'Meyve Suyu'];
  List<int> goals = [8, 5, 3, 2]; // Her bir aktivite için günlük hedefler
  late Map _gunlukListe = {};
  late Map _gunlukListeFinal = {};
  DateTime _dun = DateTime.now().add(Duration(days: -1));
  @override
  void initState() {
    super.initState();
    // print(widget.pastItems);
    for (var element in widget.pastItems) {
      // print(element['date'].toDate());
      var _tempTarih =
          "${element['date'].toDate().day}.${element['date'].toDate().month}.${element['date'].toDate().year}";
      if (_gunlukListe.containsKey(_tempTarih)) {
        _gunlukListe[_tempTarih] += element['amount'] * element['count'];
      } else {
        _gunlukListe[_tempTarih] = element['amount'] * element['count'];
      }
    }

    for (var i = 1; i < 30; i++) //30 gün geriye doğru yazıcaz
    {
      DateTime _dun = DateTime.now().add(Duration(days: -i));
      var _tempData = "${_dun.day}.${_dun.month}.${_dun.year}";
      if (_gunlukListe.containsKey(_tempData)) {
        _gunlukListeFinal[_tempData] =
            _gunlukListe[_tempData] / widget.dailyPurpose;
      } else {
        _gunlukListeFinal[_tempData] = 0.00;
      }
    }
    print(_gunlukListeFinal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Su Geçmişi'),
      ),
      body: ListView.builder(
        itemCount: _gunlukListeFinal.length,
        itemBuilder: (BuildContext context, int index) {
          String date = _gunlukListeFinal.keys.toList()[index];
          double value = _gunlukListeFinal.values.toList()[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date),
                  Text(
                    _gunlukListe[date] != null
                        ? _gunlukListe[date].toString() +
                            "/" +
                            widget.dailyPurpose.toString() +
                            " ml"
                        : "0" + "/" + widget.dailyPurpose.toString() + " ml",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  )
                ],
              ),
              subtitle: LinearProgressIndicator(
                value: value,
              ),
            ),
          );
        },
      ),
    );
  }
}
