import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Event {
  final String title;
  final String category;
  final String note;
  final String icon;
  final bool alarm;
  final String time;

  Event({
    required this.title,
    required this.category,
    required this.note,
    required this.icon,
    required this.alarm,
    required this.time,
  });

  @override
  String toString() =>
      'Event: { title: $title, category: $category, note: $note, icon: $icon, alarm: $alarm, time: $time }';
}

class Calendar extends StatefulWidget {
  final int? ekranYukseklikKontrol;
  final Map<String, dynamic>? userData;

  const Calendar({Key? key, this.userData, this.ekranYukseklikKontrol})
      : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var calendarListEvents;
  CalendarFormat format = CalendarFormat.week;
  DateTime selectedDay = DateTime.now();

  DateTime focusedDay = DateTime.now();

  int selectedWeek = 1;
  String selectedCategory = 'Doktor Randevusu 👩‍⚕️'; // Varsayılan kategori
  TextEditingController _eventController = TextEditingController();
  TextEditingController _subEventController = TextEditingController();
  bool isSwitchedTime = false;
  bool isSwitchedAlarm = false;
  TimeOfDay _secilenZaman = TimeOfDay.now();

  @override
  void initState() {
    setState(() {
      calendarListEvents = {};
      selectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0);

      // print(DateTime.parse(
      // widget.userData?['calendarListEvents'].keys.toList()[0]));
      // calendarListEvents[DateTime.parse(
      // widget.userData?['calendarListEvents'].keys.toList()[0])]= widget.userData?['calendarListEvents']
      int count = 0;
      if (widget.userData != null &&
          widget.userData!.containsKey('calendarListEvents')) {
        widget.userData!['calendarListEvents'].forEach((key, value) {
          print(DateTime.parse(key));

          calendarListEvents[DateTime.parse(key)] = [];
          calendarListEvents[DateTime.parse(key)] = value;
          print("---");
          print(value);
          print(count);
          count++;
        });
      } else {
        print('calendarListEvents parametresi bulunamadı veya null.');
      }
      print(calendarListEvents);
      // calendarListEvents = (widget.userData?['calendarListEvents'] ?? {});

      Future.delayed(const Duration(milliseconds: 500), () {
        selectedCategory = AppLocalizations.of(context)!.takvimDoktorRandevusu;
      });
    });
    selectedWeek = (((DateTime.now()
                .difference(DateTime.parse(widget.userData?['sonAdetTarihi'])))
            .inDays) ~/
        7);

    super.initState();
  }

  List _getEventsfromDay(DateTime date) {
    date = DateTime(date.year, date.month, date.day, 0, 0);
    print(date);
    print(calendarListEvents[date]);
    return calendarListEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    _subEventController.dispose();
    super.dispose();
  }

  void addEvent(
      String a, String b, String c, bool d, String _time, bool _alarm) {
    var _tempMap = {};
    var _tempList = [];

    if (_alarm) {
      int _bildirimsNumarasi = (int.parse(_time.replaceAll(':', '') +
              selectedDay.toString().split(" ")[0].replaceAll("-", ""))) %
          2147483647;
      // print("alarmmmmm  $_bildirimsNumarasi");
      BildirimTakip.aktiviteAlarm(
          _bildirimsNumarasi,
          int.parse(_time.split(':')[0]),
          int.parse(_time.split(':')[1]),
          selectedDay.day,
          selectedDay.month,
          selectedDay.year,
          a,
          AppLocalizations.of(context)!.language);
    }

    var _tempIcon = "";
    if (b == AppLocalizations.of(context)!.takvimDoktorRandevusu) {
      _tempIcon = "\uD83D\uDC69\u200D\u2695\uFE0F";
    } else if (b == AppLocalizations.of(context)!.takvimSostal) {
      _tempIcon = "\u2615";
    } else {
      _tempIcon = "\u{1F483}";
    }
    if (d) {
      setState(() {
        _tempMap['title'] = a;
        _tempMap['category'] = b;
        _tempMap['note'] = c;
        _tempMap['icon'] = _tempIcon;
        _tempMap['time'] = _time;

        // isSwitchedTime
        //     ? '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}'
        //     : '';

        _tempMap['alarm'] = _alarm;
        _tempMap['id'] = DateTime.now().millisecondsSinceEpoch;
        _tempList.add(_tempMap);
        calendarListEvents[selectedDay]!.add(_tempMap);
      });
    } else {
      setState(() {
        _tempMap['title'] = a;
        _tempMap['category'] = b;
        _tempMap['note'] = c;
        _tempMap['icon'] = _tempIcon;
        _tempMap['time'] = _time;

        // isSwitchedTime
        //     ? '${_secilenZaman.hour.toString().padLeft(2, '0')}:${_secilenZaman.minute.toString().padLeft(2, '0')}'
        //     : '';

        _tempMap['alarm'] = _alarm;
        _tempMap['id'] = DateTime.now().millisecondsSinceEpoch;

        _tempList.add(_tempMap);

        calendarListEvents[selectedDay] = [];
        calendarListEvents[selectedDay]!.add(_tempMap);
      });
    }

    FirestoreFunctions.updateCalendarDataRecord(_tempList, selectedDay);

    // print(calendarListEvents);
  }

  silActivity(editId) {
    // Seçili günün etkinliklerini kontrol et
    if (calendarListEvents[selectedDay] != null) {
      // Seçili günün etkinliklerini al

      // Etkinlikleri döngüye al ve id'ye göre ara
      for (var i = 0; i < calendarListEvents[selectedDay]!.length; i++) {
        if (calendarListEvents[selectedDay]![i]['id'] == editId) {
          // print(calendarListEvents[selectedDay]![i][0]['id']);
          // print(editTitle);
          // print(editNote);
          // print(selectedCategory);
          print("AAA");
          print(calendarListEvents[selectedDay]![i]);
          setState(() {
            FirestoreFunctions.deleteCalendarDataRecord(
                selectedDay, calendarListEvents[selectedDay]![i]);
            calendarListEvents[selectedDay]!
                .removeWhere((item) => item['id'] == editId);
          });
          print("BBB");
          print(calendarListEvents[selectedDay]!);
          // Etkinliği düzenle (Örneğin, zamanı değiştir)

          // İşlem tamamlandı, döngüyü sonlandır
          break;
        }
      }
    }
  }

  duzenleActivity(
      editId, editTitle, editNote, selectedCategory, _time, _alarm) {
    // Seçili günün etkinliklerini kontrol et
    if (calendarListEvents[selectedDay] != null) {
      // Seçili günün etkinliklerini al

      // Etkinlikleri döngüye al ve id'ye göre ara
      for (var i = 0; i < calendarListEvents[selectedDay]!.length; i++) {
        if (calendarListEvents[selectedDay]![i]['id'] == editId) {
          // print(calendarListEvents[selectedDay]![i][0]['id']);
          // print(editTitle);
          // print(editNote);
          // print(selectedCategory);
          var _tempIcon = "";
          if (selectedCategory ==
              AppLocalizations.of(context)!.takvimDoktorRandevusu) {
            _tempIcon = "\uD83D\uDC69\u200D\u2695\uFE0F";
          } else if (selectedCategory ==
              AppLocalizations.of(context)!.takvimSostal) {
            _tempIcon = "\u2615";
          } else {
            _tempIcon = "\u{1F483}";
          }

          print("AAA");
          print(calendarListEvents[selectedDay]!);
          int _bildirimsNumarasi = (int.parse(_time.replaceAll(':', '') +
                  selectedDay.toString().split(" ")[0].replaceAll("-", ""))) %
              2147483647;
          if (_alarm) {
            // print("alarmmmmm  $_bildirimsNumarasi");
            BildirimTakip.aktiviteAlarm(
                _bildirimsNumarasi,
                int.parse(_time.split(':')[0]),
                int.parse(_time.split(':')[1]),
                selectedDay.day,
                selectedDay.month,
                selectedDay.year,
                editTitle,
                AppLocalizations.of(context)!.language);
          } else {
            AwesomeNotifications().cancel(_bildirimsNumarasi);
          }
          setState(() {
            calendarListEvents[selectedDay]![i]['title'] = editTitle;
            calendarListEvents[selectedDay]![i]['note'] = editNote;
            calendarListEvents[selectedDay]![i]['icon'] = _tempIcon;
            calendarListEvents[selectedDay]![i]['time'] = _time;
            calendarListEvents[selectedDay]![i]['alarm'] = _alarm;
            // calendarListEvents[selectedDay]!
            //     .removeWhere((item) => item[0]['id'] == editId);
          });

          FirestoreFunctions.duzenleCalendarDataRecord(
              selectedDay, calendarListEvents[selectedDay]);
          // print("BBB");
          // print(calendarListEvents[selectedDay]!);
          // Etkinliği düzenle (Örneğin, zamanı değiştir)

          // İşlem tamamlandı, döngüyü sonlandır
          break;
        }
      }
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.Hm(); // For 12-hour format with AM/PM
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.ekranYukseklikKontrol == 1
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.anasayfaAktiviteler),
              centerTitle: true,
            )
          : null,
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                selectedDay = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day, 0, 0);
                focusedDay = focusDay;

                selectedWeek = (((selectDay.difference(
                            DateTime.parse(widget.userData?['sonAdetTarihi'])))
                        .inDays) ~/
                    7);
              });
              print(calendarListEvents);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 143, 51, 240),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 81, 80, 81),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 204, 241),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Color.fromARGB(255, 205, 131, 247),
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Divider(),
          Text(
              selectedWeek < 44
                  ? " ${AppLocalizations.of(context)!.takvimhafta1}$selectedWeek.${AppLocalizations.of(context)!.takvimhafta2}"
                  : "Doğum tahmini olarak gerçekleşmiş olacak 👩‍🍼",
              style: TextStyle(fontSize: 20)),
          ..._getEventsfromDay(selectedDay).map(
            (item) => Dismissible(
              key: Key(item['id'].toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                ),
              ),
              onDismissed: (direction) {
                silActivity(item['id']);
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    print(item['icon']);
                    _eventController.text = item['title'];
                    _subEventController.text = item['note'];
                    if (item['icon'] == "👩‍⚕️") {
                      selectedCategory =
                          AppLocalizations.of(context)!.takvimDoktorRandevusu;
                    } else if (item['icon'] == "☕") {
                      selectedCategory =
                          AppLocalizations.of(context)!.takvimSostal;
                    } else {
                      selectedCategory =
                          AppLocalizations.of(context)!.takvimKisiselZaman;
                    }
                    if (item['time'] == '') {
                      isSwitchedTime = false;
                    } else {
                      isSwitchedTime = true;
                      if (item['alarm']) {
                        isSwitchedAlarm = true;
                      } else {
                        isSwitchedAlarm = false;
                      }
                    }
                  });
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Wrap(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .takvimAktiviteDuzenle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      DropdownButtonFormField<String>(
                                        value: selectedCategory,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCategory = value!;
                                          });
                                        },
                                        items: [
                                          AppLocalizations.of(context)!
                                              .takvimDoktorRandevusu,
                                          AppLocalizations.of(context)!
                                              .takvimSostal,
                                          AppLocalizations.of(context)!
                                              .takvimKisiselZaman
                                        ].map((category) {
                                          return DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: 20.0),
                                      TextFormField(
                                        controller: _eventController,
                                        decoration: InputDecoration(
                                          hintText: "Aktivite adını girin",
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .takvimAktivite,
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      TextFormField(
                                        controller: _subEventController,
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .takvimNot,
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .takvimNotIstegeBagli,
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(AppLocalizations.of(context)!
                                                  .takvimZaman),
                                              Switch(
                                                value: isSwitchedTime,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isSwitchedTime = value;
                                                    if (!isSwitchedTime) {
                                                      isSwitchedAlarm = false;
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          isSwitchedTime
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    ).then((pickedTime) {
                                                      if (pickedTime != null) {
                                                        setState(() {
                                                          _secilenZaman =
                                                              pickedTime;
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child: Text(formatTimeOfDay(
                                                      _secilenZaman)),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      isSwitchedTime
                                          ? Row(
                                              children: [
                                                Text(AppLocalizations.of(
                                                        context)!
                                                    .takvimAlarm),
                                                Switch(
                                                  value: isSwitchedAlarm,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isSwitchedAlarm = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .takvimIptal),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          SizedBox(width: 10.0),
                                          ElevatedButton(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .takvimDuzenle),
                                            onPressed: () {
                                              duzenleActivity(
                                                item['id'],
                                                _eventController.text,
                                                _subEventController.text,
                                                selectedCategory,
                                                isSwitchedTime
                                                    ? '${_secilenZaman.hour.toString().padLeft(2, '0')}:${_secilenZaman.minute.toString().padLeft(2, '0')}'
                                                    : '',
                                                isSwitchedAlarm,
                                              );
                                              Navigator.pop(context);
                                              _eventController.clear();
                                              _subEventController.clear();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue, // Arka plan rengi
                      borderRadius:
                          BorderRadius.circular(10), // Kenar yuvarlatma
                      border: Border.all(
                          color: Color.fromARGB(
                              255, 150, 69, 212)), // Kenar çizgisi
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['title'].toString(),
                          ),
                          Row(
                            children: [
                              Text(
                                item['time'].toString(),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              item['alarm']
                                  ? Icon(Icons.alarm_on)
                                  : Icon(Icons.alarm_off),
                            ],
                          ),
                        ],
                      ),
                      leading: Text(
                        // event.icon.toString()
                        item['icon'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      subtitle: Text(
                        item['note'].toString(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // Float'ı sola konumlandırır

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.anasayfaAktiviteEkle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                            print(selectedCategory);
                          },
                          items: [
                            AppLocalizations.of(context)!.takvimDoktorRandevusu,
                            AppLocalizations.of(context)!.takvimSostal,
                            AppLocalizations.of(context)!.takvimKisiselZaman
                          ].map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _eventController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .takvimAktiviteAdiniGir,
                            labelText:
                                AppLocalizations.of(context)!.takvimAktivite,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _subEventController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.takvimNot,
                            labelText: AppLocalizations.of(context)!
                                .takvimNotIstegeBagli,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.takvimSaat),
                            Switch(
                              value: isSwitchedTime,
                              onChanged: (value) {
                                setState(() {
                                  isSwitchedTime = value;
                                  if (!isSwitchedTime) {
                                    isSwitchedAlarm = false;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        if (isSwitchedTime)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((pickedTime) {
                                  if (pickedTime != null) {
                                    setState(() {
                                      _secilenZaman = pickedTime;
                                    });
                                  }
                                });
                              },
                              child: Text(formatTimeOfDay(_secilenZaman)),
                            ),
                          ),
                        if (isSwitchedTime) SizedBox(height: 20.0),
                        if (isSwitchedTime)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.takvimAlarm),
                              Switch(
                                value: isSwitchedAlarm,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitchedAlarm = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: Text(
                                  AppLocalizations.of(context)!.takvimIptal),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: Text(
                                  AppLocalizations.of(context)!.takvimEkle),
                              onPressed: () {
                                if (_eventController.text.isNotEmpty) {
                                  if (calendarListEvents[selectedDay] != null) {
                                    print("a");
                                    addEvent(
                                        _eventController.text,
                                        selectedCategory,
                                        _subEventController.text,
                                        true,
                                        isSwitchedTime
                                            ? '${_secilenZaman.hour.toString().padLeft(2, '0')}:${_secilenZaman.minute.toString().padLeft(2, '0')}'
                                            : '',
                                        isSwitchedAlarm);
                                  } else {
                                    print("b");

                                    addEvent(
                                        _eventController.text,
                                        selectedCategory,
                                        _subEventController.text,
                                        false,
                                        isSwitchedTime
                                            ? '${_secilenZaman.hour.toString().padLeft(2, '0')}:${_secilenZaman.minute.toString().padLeft(2, '0')}'
                                            : '',
                                        isSwitchedAlarm);
                                  }
                                  setState(() {});
                                }
                                Navigator.pop(context);
                                _eventController.clear();
                                _subEventController.clear();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        label: Text(AppLocalizations.of(context)!.anasayfaAktiviteEkle),
        icon: Icon(Icons.add),
        heroTag: null,
      ),
    );
  }
}
