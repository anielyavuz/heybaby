import 'package:flutter/material.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/functions.dart';
import 'package:heybaby/pages/storyImages.dart';
import 'package:heybaby/pages/subpages/anaSayfaFoto.dart';
import 'package:heybaby/pages/subpages/ilacTakip.dart';
import 'package:heybaby/pages/subpages/kiloTakip.dart';
import 'package:heybaby/pages/subpages/radialMenu.dart';
import 'package:heybaby/pages/subpages/suTakip.dart';
import 'package:heybaby/pages/subpages/yapilacaklarPage.dart';

class AnaSayfa extends StatefulWidget {
  final List<String> storyImages;
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
  DateTime bugun = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  Map<String, String> activities = {};

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

  Future<void> _fetchUserData() async {
    Map<String, dynamic>? data = await FirestoreFunctions.getUserData();
    if (data != null) {
      setState(() {
        widget.userData = data;
      });
    }
    soonActivitiesCheck();
  }

  soonActivitiesCheck() {
    if (widget.userData != null) {
      if (widget.userData != null &&
          widget.userData!.containsKey('calendarListEvents')) {
        widget.userData!['calendarListEvents'].forEach((key, value) {
          if (bugun.difference(DateTime.parse(key)).inDays <
              calendarListEventsSoonDay) {
            print(DateTime.parse(key));

            print("---");
            print(bugun.difference(DateTime.parse(key)).inDays);

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

            // sortedAppointments.forEach((appointment) {
            //   print(appointment);
            // });
            calendarListEventsSoon[DateTime.parse(key)] = sortedAppointments;
          }

          // calendarListEvents[DateTime.parse(key)] = [];
          // calendarListEvents[DateTime.parse(key)] = value;

          // print(value);
        });
      } else {
        print('calendarListEvents parametresi bulunamadı veya null.');
      }
      print("---");
      print(calendarListEventsSoon);
      print("---Final-----");
      orderSoonEvents(calendarListEventsSoon);
    } else {
      print("Data yok");
    }
  }

  @override
  void initState() {
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
                            storyImages: widget.storyImages,
                            startingPage: index,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage(widget.storyImages[index]),
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
                      subtitle: Text(entry.value.split('%%%')[0].split(' ')[0]),
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
