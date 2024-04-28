import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/functions.dart';
import 'package:heybaby/pages/storyImages.dart';
import 'package:heybaby/pages/subpages/anaSayfaFoto.dart';
import 'package:heybaby/pages/subpages/haftalikGuncelleme.dart';
import 'package:heybaby/pages/subpages/ilacTakip.dart';
import 'package:heybaby/pages/subpages/kiloTakip.dart';
import 'package:heybaby/pages/subpages/radialMenu.dart';
import 'package:heybaby/pages/subpages/suTakip.dart';
import 'package:heybaby/pages/subpages/yapilacaklarPage.dart';
import 'package:intl/intl.dart';

class AnaSayfa extends StatefulWidget {
  final List storyImages;
  Map<String, dynamic>? userData;

  AnaSayfa({Key? key, this.userData, required this.storyImages})
      : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  var calendarListEvents;
  Map calendarListEventsSoon = {};
  int calendarListEventsSoonDay = 15;
  List _storyImagesLink = [];
  List _storyIDlist = [];
  DateTime bugun = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  Map<String, String> activities = {};
  int selectedWeek = 4;

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
              _element['time'].toString();
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

  Future<void> _fetchUserData() async {
    Map<String, dynamic>? data = await FirestoreFunctions.getUserData();
    if (data != null) {
      setState(() {
        widget.userData = data;
        selectedWeek =
            (((DateTime.now().difference(DateTime.parse(data['sonAdetTarihi'])))
                    .inDays) ~/
                7);
      });
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

  @override
  void initState() {
    setState(() {
      for (var storyElement in widget.storyImages) {
        _storyImagesLink.add(storyElement['imageLink']);
        _storyIDlist.add(storyElement['id']);
      }
    });

    super.initState();

    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Story Circles
        Column(
          children: [
            Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.storyImages.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryScreen(
                              storyImages: _storyImagesLink,
                              startingPage: index,
                              storyIDlist: _storyIDlist),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                NetworkImage(_storyImagesLink[index]),
                          ),
                          Text(
                            widget.storyImages[index]['header'].toString(),
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // Resim
            TrimesterProgressWidget(
              userData: widget.userData,
            ),
            SizedBox(height: 10),
            FunctionsWidget(
              onFunction1Pressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
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
                  );
                }));

                print("Test1");
              },
              onFunction2Pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KiloTakipPage(
                            userData: widget.userData,
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
              function1Description: 'Su',
              function2Description: 'Kilo Takibi',
              function3Description: 'İlaç/Vitamin',
              function4Description: 'Yapılacaklar',
            ),
            SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HaftalikGuncellemeWidget(userData: widget.userData),
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
                          '$selectedWeek. Hafta için\nSize Özel Bilgilere Bakın😇',
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
            )
          ],
        ),

        // SizedBox(height: 10),
        Positioned(
          bottom: 10,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 214, 172, 238),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExpansionTile(
                  title: Text(
                    'Yaklaşan Aktiviteler' +
                        (activities.keys.toList().length != 0
                            ? " (${activities.keys.toList().length.toString()})"
                            : ""),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  children: activities.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.value.split('%%%')[1]),
                      subtitle: Text(formatDate(
                          entry.value.split('%%%')[0].split(' ')[0])),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnaSayfa(
      storyImages: [
        // Story Images'larınızı ekleyin
      ],
    ),
  ));
}
