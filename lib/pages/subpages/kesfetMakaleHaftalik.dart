import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/subpages/makaleDetay.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KesfetMakaleHaftalikWidget extends StatefulWidget {
  final List stories;
  Map<String, dynamic>? userData;
  KesfetMakaleHaftalikWidget({required this.stories, required this.userData});

  @override
  _KesfetMakaleHaftalikWidgetState createState() =>
      _KesfetMakaleHaftalikWidgetState();
}

class _KesfetMakaleHaftalikWidgetState
    extends State<KesfetMakaleHaftalikWidget> {
  late Map<int, List> groupedStories;

  @override
  void initState() {
    super.initState();
    groupedStories = _groupStoriesByWeek(widget.stories);
  }

  Map<int, List> _groupStoriesByWeek(List stories) {
    Map<int, List> grouped = {};
    for (var story in stories) {
      int week = story['hafta'];
      print(week);
      // if (!story.containsKey('premium')) {
      //   // print((story['premium']));
      //   print((story['hafta']));
      //   print("asdasd");
      // }

      // print(grouped.containsKey(week));
      if (!grouped.containsKey(week)) {
        grouped[week] = [];
      }
      grouped[week]!.add(story);
      // print(grouped[week]);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupedStories.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}. Hafta',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: entry.value.map<Widget>((story) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MakaleDetay(
                                        baslik: story['baslik'],
                                        icerik: story['icerik']
                                            .toString()
                                            .replaceAll('%', '\n'),
                                        resimURL: story['imageLink'],
                                        referansAktif: false,
                                        referansList: [],
                                        isUserPremium: widget.userData![
                                                    'userSubscription'] ==
                                                'Free'
                                            ? false
                                            : true,
                                        isMakalePremium: story['premium'],
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: new DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            alignment: FractionalOffset.center,
                                            image: new NetworkImage(
                                                story['imageLink']),
                                          )),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Text(
                                        story['baslik'],
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6.0),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 15.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: story['premium']
                                            ? const Color.fromARGB(
                                                255, 124, 33, 243)
                                            : Color.fromARGB(
                                                255, 209, 185, 241),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        story['premium'] ? "Premium" : "Free",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MakaleDetay extends StatelessWidget {
//   final String baslik;
//   final String icerik;
//   final String resimURL; // Burada parametrenin adı düzeltildi
//   Map<String, dynamic>? userData;
//   MakaleDetay(
//       {required this.baslik,
//       required this.icerik,
//       required this.resimURL,
//       required this.userData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               resimURL.startsWith("https")
//                   ? Container(
//                       height: 250,
//                       decoration: new BoxDecoration(
//                           image: new DecorationImage(
//                         fit: BoxFit.fitWidth,
//                         alignment: FractionalOffset.center,
//                         image: new NetworkImage(resimURL),
//                       )),
//                     )
//                   : Image.asset(
//                       resimURL, // Burada widget.resimUrl yerine parametre olan resimURL kullanılıyor
//                       width: MediaQuery.of(context).size.width,
//                       height: 200,
//                       fit: BoxFit.cover,
//                     ),
//               Text(
//                 baslik,
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Text(
//                 icerik,
//                 style: TextStyle(fontSize: 18.0),
//               ),
//               SizedBox(height: 25.0),
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.makaleBegendinizmi,
//                       style: TextStyle(
//                           fontSize: 20.0, fontWeight: FontWeight.bold),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.thumb_up),
//                           onPressed: () async {
//                             var _sonuc =
//                                 await FirestoreFunctions.makaleGeriBildirim(
//                                         userData,
//                                         "Beğendi",
//                                         DateFormat('hh:mm - dd-MM-yyyy')
//                                             .format(DateTime.now()),
//                                         baslik)
//                                     .whenComplete(() {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     AppLocalizations.of(context)!
//                                         .hesapGeriBildirimBasarili,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   backgroundColor: Color.fromARGB(255, 126, 52,
//                                       253), // Snackbar arka plan rengi
//                                   duration: Duration(
//                                       seconds: 3), // Snackbar gösterim süresi
//                                   behavior: SnackBarBehavior
//                                       .floating, // Snackbar davranışı
//                                   shape: RoundedRectangleBorder(
//                                     // Snackbar şekli
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   elevation: 4, // Snackbar yükseltilmesi
//                                   margin: EdgeInsets.all(
//                                       10), // Snackbar kenar boşlukları
//                                 ),
//                               );
//                             });
//                             print("Beğendi");
//                           },
//                         ),
//                         SizedBox(width: 20.0),
//                         IconButton(
//                           icon: Icon(Icons.thumb_down),
//                           onPressed: () async {
//                             var _sonuc =
//                                 await FirestoreFunctions.makaleGeriBildirim(
//                                         userData,
//                                         "Beğenmedi",
//                                         DateFormat('hh:mm - dd-MM-yyyy')
//                                             .format(DateTime.now()),
//                                         baslik)
//                                     .whenComplete(() {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     AppLocalizations.of(context)!
//                                         .hesapGeriBildirimBasarili,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   backgroundColor: Color.fromARGB(255, 126, 52,
//                                       253), // Snackbar arka plan rengi
//                                   duration: Duration(
//                                       seconds: 3), // Snackbar gösterim süresi
//                                   behavior: SnackBarBehavior
//                                       .floating, // Snackbar davranışı
//                                   shape: RoundedRectangleBorder(
//                                     // Snackbar şekli
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   elevation: 4, // Snackbar yükseltilmesi
//                                   margin: EdgeInsets.all(
//                                       10), // Snackbar kenar boşlukları
//                                 ),
//                               );
//                             });

//                             print("Beğenmedi");
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 15.0),
//               Container(
//                 color: Colors.grey[200],
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       AppLocalizations.of(context)!.makaleSorumlulukReddi,
//                       style: TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       AppLocalizations.of(context)!.makaleSorumlulukMetin,
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
