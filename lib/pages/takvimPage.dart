import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final Map<String, dynamic>? userData;

  const Calendar({Key? key, this.userData}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  late Map<DateTime, List> calendarListEvents;
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
    selectedWeek = (((DateTime.now()
                .difference(DateTime.parse(widget.userData?['sonAdetTarihi'])))
            .inDays) ~/
        7);

    calendarListEvents = {};
    super.initState();
  }

  List _getEventsfromDay(DateTime date) {
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
    print(d);

    var _tempIcon = "";
    if (b == 'Doktor Randevusu 👩‍⚕️') {
      _tempIcon = "\uD83D\uDC69\u200D\u2695\uFE0F";
    } else if (b == "Sosyal ☕️") {
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
        calendarListEvents[selectedDay]!.add(_tempList);
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
        calendarListEvents[selectedDay]!.add(_tempList);
      });
    }
    print(calendarListEvents[selectedDay]);
  }

  silActivity(editId) {
    // Seçili günün etkinliklerini kontrol et
    if (calendarListEvents[selectedDay] != null) {
      // Seçili günün etkinliklerini al

      // Etkinlikleri döngüye al ve id'ye göre ara
      for (var i = 0; i < calendarListEvents[selectedDay]!.length; i++) {
        if (calendarListEvents[selectedDay]![i][0]['id'] == editId) {
          // print(calendarListEvents[selectedDay]![i][0]['id']);
          // print(editTitle);
          // print(editNote);
          // print(selectedCategory);
          print("AAA");
          print(calendarListEvents[selectedDay]!);
          setState(() {
            calendarListEvents[selectedDay]!
                .removeWhere((item) => item[0]['id'] == editId);
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
        if (calendarListEvents[selectedDay]![i][0]['id'] == editId) {
          // print(calendarListEvents[selectedDay]![i][0]['id']);
          // print(editTitle);
          // print(editNote);
          // print(selectedCategory);
          var _tempIcon = "";
          if (selectedCategory == 'Doktor Randevusu 👩‍⚕️') {
            _tempIcon = "\uD83D\uDC69\u200D\u2695\uFE0F";
          } else if (selectedCategory == "Sosyal ☕️") {
            _tempIcon = "\u2615";
          } else {
            _tempIcon = "\u{1F483}";
          }

          print("AAA");
          print(calendarListEvents[selectedDay]!);
          setState(() {
            calendarListEvents[selectedDay]![i][0]['title'] = editTitle;
            calendarListEvents[selectedDay]![i][0]['note'] = editNote;
            calendarListEvents[selectedDay]![i][0]['icon'] = _tempIcon;
            calendarListEvents[selectedDay]![i][0]['time'] = _time;
            calendarListEvents[selectedDay]![i][0]['alarm'] = _alarm;
            // calendarListEvents[selectedDay]!
            //     .removeWhere((item) => item[0]['id'] == editId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aktiviteler"),
        centerTitle: true,
      ),
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
                focusedDay = focusDay;

                selectedWeek = (((selectDay.difference(
                            DateTime.parse(widget.userData?['sonAdetTarihi'])))
                        .inDays) ~/
                    7);
              });
              print(focusedDay);
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
          Row(
            children: [
              Text(
                  selectedWeek < 44
                      ? "Hamileliğin $selectedWeek. haftası.🤰"
                      : "Doğum tahmini olarak gerçekleşmiş olacak.👩‍🍼",
                  style: TextStyle(fontSize: 20)),
            ],
          ),
          ..._getEventsfromDay(selectedDay).map(
            (item) => Dismissible(
              key: Key(item[0]['title']),
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
                silActivity(item[0]['id']);
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    print(item[0]['icon']);
                    _eventController.text = item[0]['title'];
                    _subEventController.text = item[0]['note'];
                    if (item[0]['icon'] == "👩‍⚕️") {
                      selectedCategory = 'Doktor Randevusu 👩‍⚕️';
                    } else if (item[0]['icon'] == "☕") {
                      selectedCategory = 'Sosyal ☕️';
                    } else {
                      selectedCategory = 'Kişisel Zaman 💃';
                    }
                  });
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Aktivite Düzenle",
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
                                    'Doktor Randevusu 👩‍⚕️',
                                    'Sosyal ☕️',
                                    'Kişisel Zaman 💃'
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
                                    labelText: "Aktivite",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: _subEventController,
                                  decoration: InputDecoration(
                                    hintText: "Not",
                                    labelText: "Not (isteğe bağlı)",
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
                                        Text('Zaman'),
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
                                    GestureDetector(
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
                                      child: Text(_secilenZaman.toString()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                isSwitchedTime
                                    ? Row(
                                        children: [
                                          Text('Alarm'),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: Text("İptal"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    SizedBox(width: 10.0),
                                    ElevatedButton(
                                      child: Text("Düzenle"),
                                      onPressed: () {
                                        duzenleActivity(
                                            item[0]['id'],
                                            _eventController.text,
                                            _subEventController.text,
                                            selectedCategory,
                                            isSwitchedTime
                                                ? '${_secilenZaman.hour.toString().padLeft(2, '0')}:${_secilenZaman.minute.toString().padLeft(2, '0')}'
                                                : '',
                                            isSwitchedAlarm);
                                        Navigator.pop(context);
                                        _eventController.clear();
                                        _subEventController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.blue, // Arka plan rengi
                    borderRadius: BorderRadius.circular(10), // Kenar yuvarlatma
                    border: Border.all(
                        color:
                            Color.fromARGB(255, 150, 69, 212)), // Kenar çizgisi
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item[0]['title'].toString(),
                        ),
                        Row(
                          children: [
                            Text(
                              item[0]['time'].toString(),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            item[0]['alarm']
                                ? Icon(Icons.alarm_on)
                                : Icon(Icons.alarm_off),
                          ],
                        ),
                      ],
                    ),
                    leading: Text(
                      // event.icon.toString()
                      item[0]['icon'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      item[0]['note'].toString(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // FAB'ı sola konumlandırır

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aktivite Ekle",
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
                            'Doktor Randevusu 👩‍⚕️',
                            'Sosyal ☕️',
                            'Kişisel Zaman 💃'
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
                            labelText: "Aktivite",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _subEventController,
                          decoration: InputDecoration(
                            hintText: "Not",
                            labelText: "Not (isteğe bağlı)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Zaman'),
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
                            GestureDetector(
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
                              child: Text(_secilenZaman.toString()),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0),
                        isSwitchedTime
                            ? Row(
                                children: [
                                  Text('Alarm'),
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text("İptal"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 10.0),
                            ElevatedButton(
                              child: Text("Ekle"),
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
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        label: Text("Aktivite Ekle"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
