import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:numberpicker/numberpicker.dart';

class IlacTakip extends StatefulWidget {
  Map<String, dynamic>? userData;

  IlacTakip({Key? key, this.userData}) : super(key: key);
  @override
  _IlacTakipState createState() => _IlacTakipState();
}

class _IlacTakipState extends State<IlacTakip> {
  CalendarFormat format = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;
  TextEditingController _ilacEkleTextFieldController = TextEditingController();
  // Sample medication data
  var ilacListesi = [];
  Map<String, dynamic>? currentUserData;
  bool _shouldFetchUserData = true;

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

  Future<void> _fetchUserData() async {
    Map<String, dynamic>? data = await FirestoreFunctions.getUserData();
    if (data != null) {
      setState(() {
        print("Datayı güncelle");
        // print(widget.userData);
        currentUserData = data;
        _shouldFetchUserData = false;
        widget.userData = currentUserData;
        ilacListesi = (widget.userData?['dataRecord']['ilacListesiData'] ?? [])
            .map((item) => item as Map<String, dynamic>)
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    print("lkfdlkfdk");
    print(ilacListesi);
    setState(() {
      ilacListesi = (widget.userData?['dataRecord']['ilacListesiData'] ?? [])
          .map((item) => item as Map<String, dynamic>)
          .toList();
      print("ASDSDSADSAD");
      print(ilacListesi.toString());
    });

    // Initialize the checkbox values for each medication for each day
    for (var ilac in ilacListesi) {
      // ilacCheckboxValues[ilac['isim']] = {};
      for (var gun in ilac['gunler']) {
        DateTime ilacGunu = _selectedDay
            .subtract(Duration(days: (_selectedDay.weekday - gun) as int));
        // ilacCheckboxValues[ilac['isim']]![ilacGunu] =
        //     List<bool>.filled(ilac['saatler'].length, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('İlaç Takip'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            startingDayOfWeek: StartingDayOfWeek.monday,
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: format,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;

                // Update the checkbox values for each medication for the selected day
                // for (var ilac in ilacListesi) {
                //   if (!ilacCheckboxValues[ilac['isim']]!
                //       .containsKey(_selectedDay)) {
                //     ilacCheckboxValues[ilac['isim']]![_selectedDay] =
                //         List<bool>.filled(ilac['saatler'].length, false);
                //   }
                // }

                // Print the checkbox values for each medication for the selected day
                for (var ilac in ilacListesi) {
                  // print('Medicine: ${ilac['isim']}');
                  // print(
                  //     'Checkbox values: ${ilacCheckboxValues[ilac['isim']]![_selectedDay]}');
                }
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              canMarkersOverflow: true,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Color.fromARGB(255, 160, 131, 247),
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
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

                    if (ilac['gunler'].contains(_selectedDay.weekday - 1) &&
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
                                  // Checkbox(
                                  //   value: ilacCheckboxValues[ilac['isim']]![
                                  //           _selectedDay]![index] ??
                                  //       false,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       ilacCheckboxValues[ilac['isim']]![
                                  //           _selectedDay]![index] = value!;
                                  //     });
                                  //   },
                                  // ),
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
            _fetchUserData();
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
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

    ilacSaatleri = [TimeOfDay(hour: 20, minute: 00)];

    baslangicTarihi = DateTime.now();
    kacGunKullanilacak = 7;
    // Pazartesi, Çarşamba ve Cuma günlerini seçili hale getir
    List<int> selectedIndices = [0, 1, 2, 3, 4, 5, 6];
    for (int index in selectedIndices) {
      selectedDays[index] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlaç Ekle'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      // color: Colors.blue, // Arka plan rengi
                      borderRadius:
                          BorderRadius.circular(10), // Kenar yuvarlatma
                      border: Border.all(color: Colors.black), // Kenar çizgisi
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        controller: _ilacAdiController,
                        inputFormatters: <TextInputFormatter>[
                          UpperCaseTextFormatter()
                        ],
                        decoration: InputDecoration(hintText: 'İlaç Adı'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Divider(),

                  // Günlerin listesi ve check kutuları
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      // color: Colors.blue, // Arka plan rengi
                      borderRadius:
                          BorderRadius.circular(10), // Kenar yuvarlatma
                      border: Border.all(color: Colors.black), // Kenar çizgisi
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        7,
                        (index) => FilterChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          showCheckmark: false,
                          selectedColor: Color.fromARGB(255, 164, 38, 243),
                          disabledColor: Colors.grey,
                          label: Text(_getDayName(index)),
                          selected: selectedDays[index],
                          onSelected: (isSelected) {
                            setState(() {
                              selectedDays[index] = isSelected;
                            });
                            print(selectedDays
                                .asMap()
                                .entries
                                .where((entry) => entry.value)
                                .map((entry) => entry.key)
                                .toList());
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue, // Arka plan rengi
                      borderRadius:
                          BorderRadius.circular(10), // Kenar yuvarlatma
                      border: Border.all(color: Colors.black), // Kenar çizgisi
                    ),
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
                                _ilacSaatiEkle();
                              },
                            ),
                            Row(
                              children: ilacSaatleri
                                  .map(
                                    (time) => Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(255, 153, 51,
                                                255), // Çerçeve rengi
                                            width: 1.0, // Çerçeve kalınlığı
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Opsiyonel: Köşelerin yuvarlaklığı
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              child: IconButton(
                                                iconSize: 20,
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  // size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    ilacSaatleri.remove(time);
                                                  });
                                                  ilacSaatleri.sort((a, b) =>
                                                      a.hour.compareTo(b.hour));
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

                  const SizedBox(height: 10),
                  // Divider(),
                  // SizedBox(height: 2),
                  // TextButton(
                  //   onPressed: _selectDate,
                  //   child: Text(
                  //       'Başlangıç Tarihi: ${baslangicTarihi.toString().split(" ")[0]}'),
                  // )
                  // TextButton(
                  //   onPressed: _selectDate,
                  //   child: Text('Tarihi Seç'),
                  // ),
                  // ,

                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue, // Arka plan rengi
                      borderRadius:
                          BorderRadius.circular(10), // Kenar yuvarlatma
                      border: Border.all(color: Colors.black), // Kenar çizgisi
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text('Tok'),
                        ),
                        Switch(
                          value: tokMu,
                          onChanged: (newValue) {
                            setState(() {
                              tokMu = newValue;
                            });
                          },
                        ),
                        // Text(tokMu ? 'Evet' : 'Hayır'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      // color: Colors.blue, // Arka plan rengi
                      borderRadius:
                          BorderRadius.circular(10), // Kenar yuvarlatma
                      border: Border.all(color: Colors.black), // Kenar çizgisi
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text('Kaç Gün Kullanılacak'),
                        ),
                        NumberPicker(
                          value: kacGunKullanilacak,
                          minValue: 1,
                          maxValue: 30,
                          onChanged: (value) {
                            setState(() {
                              kacGunKullanilacak = value;
                            });
                          },
                          decoration: BoxDecoration(
                            // color: Colors.blue, // Arka plan rengi
                            borderRadius:
                                BorderRadius.circular(10), // Kenar yuvarlatma
                            border: Border.all(
                                color: Colors.black), // Kenar çizgisi
                          ),
                          textStyle: TextStyle(
                            color: Colors.black, // Sayı rengi
                          ),
                          selectedTextStyle: TextStyle(
                            color: Color.fromARGB(
                                255, 101, 44, 243), // Seçili sayı rengi
                            fontWeight: FontWeight.bold,
                          ),
                          itemWidth: 30,
                          itemHeight: 30,
                          zeroPad: false,
                          axis: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
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
                  ),
                ],
              ),
            ),
            // Positioned(
            //   left: 5,
            //   top: 0,
            //   child: Container(
            //     height: 40,
            //     child: IconButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //           // Navigator.pushReplacement(context,
            //           //     MaterialPageRoute(builder: (_) {
            //           //   return CheckAuth();
            //           // }));
            //         },
            //         icon: Icon(
            //           Icons.arrow_back_ios_new_outlined,
            //           size: 35,
            //           color: Color.fromARGB(255, 0, 0, 0),
            //         )),
            //   ),
            // )
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
        ilacSaatleri.sort((a, b) => a.hour.compareTo(b.hour));
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
      'saatler': ilacSaatleri
          .map((time) =>
              "${time.hour}:${time.minute.toString().padLeft(2, '0')}")
          .toList(),
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
    // var _result = await FirestoreFunctions.addIlacDataRecord(newMedication);
    var _result2 = await FirestoreFunctions.updateDataRecord(
        newMedication, "ilacListesiData");
    Navigator.pop(context);
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'P';
      case 1:
        return 'S';
      case 2:
        return 'Ç';
      case 3:
        return 'P';
      case 4:
        return 'C';
      case 5:
        return 'C';
      case 6:
        return 'P';
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
