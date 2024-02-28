import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class IlacTakip extends StatefulWidget {
  @override
  _IlacTakipState createState() => _IlacTakipState();
}

class _IlacTakipState extends State<IlacTakip> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;

  // Sample medication data
  final List<Map<String, dynamic>> ilacListesi = [
    {
      'saatler': ['09:00', '12:00', '18:00'],
      'isim': 'Vitamin D',
      'tok': true,
      'baslangic_tarihi': '2024-02-26',
      'kac_gun_kullanim': '30',
      'gunler': [1, 3, 5], // Pazartesi, Çarşamba, Cuma
    },
    {
      'saatler': ['09:00', '12:00', '18:00'],
      'isim': 'Vitamin E',
      'tok': true,
      'baslangic_tarihi': '2024-02-26',
      'kac_gun_kullanim': '30',
      'gunler': [1, 2, 3, 4, 5], // Pazartesi, Çarşamba, Cuma
    },
    {
      'saatler': ['09:00', '18:00'],
      'isim': 'Vitamin C',
      'tok': true,
      'baslangic_tarihi': '2024-02-26',
      'kac_gun_kullanim': '20',
      'gunler': [2, 4], // Salı, Perşembe
    },
    {
      'saatler': ['09:00', '12:00', '18:00'],
      'isim': 'Omega-3',
      'tok': false,
      'baslangic_tarihi': '2024-02-27',
      'kac_gun_kullanim': '10',
      'gunler': [1, 2, 3, 4, 5], // Pazartesi'den Cuma'ya
    },
  ];

  // Store the selected checkbox values for each medication for each day
  Map<String, Map<DateTime, List<bool>>> ilacCheckboxValues = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // Initialize the checkbox values for each medication for each day
    for (var ilac in ilacListesi) {
      ilacCheckboxValues[ilac['isim']] = {};
      for (var gun in ilac['gunler']) {
        DateTime ilacGunu = _selectedDay
            .subtract(Duration(days: (_selectedDay.weekday - gun) as int));
        ilacCheckboxValues[ilac['isim']]![ilacGunu] =
            List<bool>.filled(ilac['saatler'].length, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlaç Takip'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;

                // Update the checkbox values for each medication for the selected day
                for (var ilac in ilacListesi) {
                  if (!ilacCheckboxValues[ilac['isim']]!
                      .containsKey(_selectedDay)) {
                    ilacCheckboxValues[ilac['isim']]![_selectedDay] =
                        List<bool>.filled(ilac['saatler'].length, false);
                  }
                }

                // Print the checkbox values for each medication for the selected day
                for (var ilac in ilacListesi) {
                  print('Medicine: ${ilac['isim']}');
                  print(
                      'Checkbox values: ${ilacCheckboxValues[ilac['isim']]![_selectedDay]}');
                }
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              canMarkersOverflow: true,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ilacListesi.map((ilac) {
                    DateTime baslangicTarihi =
                        DateTime.parse(ilac['baslangic_tarihi']);
                    DateTime bitisTarihi = baslangicTarihi.add(
                        Duration(days: int.parse(ilac['kac_gun_kullanim'])));

                    if (ilac['gunler'].contains(_selectedDay.weekday) &&
                        _selectedDay.isAfter(baslangicTarihi) &&
                        _selectedDay.isBefore(bitisTarihi)) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ilac['isim'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children:
                                List.generate(ilac['saatler'].length, (index) {
                              String saat = ilac['saatler'][index];
                              return Row(
                                children: [
                                  Text(saat),
                                  Checkbox(
                                    value: ilacCheckboxValues[ilac['isim']]![
                                            _selectedDay]![index] ??
                                        false,
                                    onChanged: (value) {
                                      setState(() {
                                        ilacCheckboxValues[ilac['isim']]![
                                            _selectedDay]![index] = value!;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: IlacTakip(),
  ));
}
