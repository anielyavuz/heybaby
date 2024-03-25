import 'package:flutter/material.dart';
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

    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    _subEventController.dispose();
    super.dispose();
  }

  void addEvent(a, b, c, d) {
    print(b);
    print(b.substring(b.length - 1));
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
        selectedEvents[selectedDay]!.add(
          Event(
              title: a,
              category: b,
              note: c,
              icon: _tempIcon // Not alanı buraya eklenebilir
              ),
        );
      });
    } else {
      setState(() {
        selectedEvents[selectedDay] = [
          Event(title: a, category: b, note: c, icon: _tempIcon)
        ];
      });
    }
    print(selectedEvents[selectedDay]);
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
            (Event event) => ListTile(
              title: Text(
                event.title,
              ),
              leading: Text(
                // event.icon.toString()
                event.icon,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(event.note),
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
                                  if (selectedEvents[selectedDay] != null) {
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
