import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final String category;
  final String note;
  final String icon;
  Event(
      {required this.title,
      required this.category,
      required this.note,
      required this.icon});

  @override
  String toString() =>
      'Event: { title: $title, category: $category, note: $note, icon: $icon }';
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

  void addEvent(a, b, c, d) {
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
        _tempMap['time'] =
            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
        _tempMap['alarm'] = false;
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
        _tempMap['time'] =
            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
        _tempMap['alarm'] = false;
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

  duzenleActivity(editId, editTitle, editNote, selectedCategory) {
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
                    color: Colors.white,
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
                                            selectedCategory);
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
                            GestureDetector(
                              child: Icon(Icons.alarm_off),
                              onTap: () {},
                            )
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
                                        true);
                                  } else {
                                    print("b");

                                    addEvent(
                                        _eventController.text,
                                        selectedCategory,
                                        _subEventController.text,
                                        false);
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
