import 'package:flutter/material.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:numberpicker/numberpicker.dart';

class IlacTakip extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const IlacTakip({Key? key, this.userData}) : super(key: key);
  @override
  _IlacTakipState createState() => _IlacTakipState();
}

class _IlacTakipState extends State<IlacTakip> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;
  TextEditingController _ilacEkleTextFieldController = TextEditingController();
  // Sample medication data
  var ilacListesi = [];

  // [
  //   {
  //     'saatler': ['09:00', '12:00', '18:00'],
  //     'isim': 'Vitamin D',
  //     'tok': true,
  //     'baslangic_tarihi': '2024-02-26',
  //     'kac_gun_kullanim': '30',
  //     'gunler': [1, 3, 5], // Pazartesi, Çarşamba, Cuma
  //   },
  //   {
  //     'saatler': ['09:00', '12:00', '18:00'],
  //     'isim': 'Vitamin E',
  //     'tok': true,
  //     'baslangic_tarihi': '2024-02-26',
  //     'kac_gun_kullanim': '30',
  //     'gunler': [1, 2, 3, 4, 5], // Pazartesi, Çarşamba, Cuma
  //   },
  //   {
  //     'saatler': ['09:00', '18:00'],
  //     'isim': 'Vitamin C',
  //     'tok': true,
  //     'baslangic_tarihi': '2024-02-26',
  //     'kac_gun_kullanim': '20',
  //     'gunler': [2, 4], // Salı, Perşembe
  //   },
  //   {
  //     'saatler': ['09:00', '12:00', '18:00'],
  //     'isim': 'Omega-3',
  //     'tok': false,
  //     'baslangic_tarihi': '2024-02-27',
  //     'kac_gun_kullanim': '10',
  //     'gunler': [1, 2, 3, 4, 5], // Pazartesi'den Cuma'ya
  //   },
  // ];

  // Store the selected checkbox values for each medication for each day
  Map<String, Map<DateTime, List<bool>>> ilacCheckboxValues = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    print("lkfdlkfdk");
    print(ilacListesi);
    setState(() {
      ilacListesi = (widget.userData?['ilacListesi'] ?? [])
          .map((item) => item as Map<String, dynamic>)
          .toList();
      print("ASDSDSADSAD");
      print(ilacListesi.toString());
    });

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
                          SizedBox(height: 2),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IlacEkleScreen(),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        tooltip: 'İlaç Ekle',
        child: Icon(Icons.add),
      ),
    );
  }
}

class IlacEkleScreen extends StatefulWidget {
  @override
  _IlacEkleScreenState createState() => _IlacEkleScreenState();
}

class _IlacEkleScreenState extends State<IlacEkleScreen> {
  late List<TimeOfDay> ilacSaatleri;
  late DateTime baslangicTarihi;
  late int kacGunKullanilacak;
  bool tokMu = false;
  List<bool> selectedDays =
      List.generate(7, (index) => false); // Haftanın günleri için seçim listesi

  final TextEditingController _ilacAdiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ilacSaatleri = [TimeOfDay.now()];

    baslangicTarihi = DateTime.now();
    kacGunKullanilacak = 1;
    // Pazartesi, Çarşamba ve Cuma günlerini seçili hale getir
    List<int> selectedIndices = [0, 1, 2, 3, 4, 5, 6];
    for (int index in selectedIndices) {
      selectedDays[index] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                "İlaç Ekle",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15,5,15,5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _ilacAdiController,
                    decoration: InputDecoration(labelText: 'İlaç Adı'),
                  ),
                  SizedBox(height: 2),
                  Divider(),
                  SizedBox(height: 2),
                  Text('İlaç Saatleri'),
                  Column(
                    children: ilacSaatleri
                        .map((time) => Row(
                              children: [
                                Text(
                                  '${time.hour}:${time.minute}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      ilacSaatleri.remove(time);
                                    });
                                  },
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                  ElevatedButton(
                    onPressed: _ilacSaatiEkle,
                    child: Text('İlaç Saati Ekle'),
                  ),
                  SizedBox(height: 2),
                  Divider(),
                  SizedBox(height: 2),
                  TextButton(
                    onPressed: _selectDate,
                    child: Text(
                        'Başlangıç Tarihi: ${baslangicTarihi.toString().split(" ")[0]}'),
                  )
                  // TextButton(
                  //   onPressed: _selectDate,
                  //   child: Text('Tarihi Seç'),
                  // ),
                  ,
                  SizedBox(height: 2),
                  Divider(),
                  Text('Hangi Günler?'),
                  // Günlerin listesi ve check kutuları
                  Wrap(
                    spacing: 10,
                    children: List.generate(
                      7,
                      (index) => FilterChip(
                        selectedColor: Colors.green,
                        disabledColor: Colors.grey,
                        label: Text(_getDayName(index)),
                        selected: selectedDays[index],
                        onSelected: (isSelected) {
                          setState(() {
                            selectedDays[index] = isSelected;
                          });
                        },
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 2),
                  Text('Kaç Gün Kullanılacak'),
                  NumberPicker(
                    value: kacGunKullanilacak,
                    minValue: 1,
                    maxValue: 30,
                    onChanged: (value) {
                      setState(() {
                        kacGunKullanilacak = value;
                      });
                    },
                  ),
              
                  Divider(),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text('Tok mu?'),
                      Switch(
                        value: tokMu,
                        onChanged: (newValue) {
                          setState(() {
                            tokMu = newValue;
                          });
                        },
                      ),
                      Text(tokMu ? 'Evet' : 'Hayır'),
                    ],
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      if (_ilacAdiController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('İlaç Adı boş olamaz.')),
                        );
                      } else {
                        _ilacEkle();
                      }
                    },
                    child: Text('Ekle'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ilacSaatiEkle() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime != null) {
        setState(() {
          ilacSaatleri.add(pickedTime);
        });
      }
    });
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2301),
    );
    if (picked != null && picked != baslangicTarihi)
      setState(() {
        baslangicTarihi = picked;
      });
  }

  void _ilacEkle() async {
    Map<String, dynamic> newMedication = {
      'isim': _ilacAdiController.text,
      'saatler':
          ilacSaatleri.map((time) => "'${time.hour}:${time.minute}'").toList(),
      'baslangic_tarihi':
          "${baslangicTarihi.year}-${baslangicTarihi.month < 10 ? '0${baslangicTarihi.month}' : baslangicTarihi.month}-${baslangicTarihi.day < 10 ? '0${baslangicTarihi.day}' : baslangicTarihi.day}",
      'kac_gun_kullanim': kacGunKullanilacak.toString(),
      'tok': tokMu,
      'gunler': selectedDays
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
    };
    print(newMedication);
    // widget.ilacListesi.add(newMedication);
    var _result = await FirestoreFunctions.addIlacDataRecord(newMedication);
    Navigator.pop(context);
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'Pzt';
      case 1:
        return 'Sal';
      case 2:
        return 'Çrş';
      case 3:
        return 'Per';
      case 4:
        return 'Cum';
      case 5:
        return 'Cmt';
      case 6:
        return 'Pzr';
      default:
        return '';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: IlacTakip(),
  ));
}
