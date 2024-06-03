import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';

class KesfetMakaleHaftalikWidget extends StatefulWidget {
  final List stories;

  KesfetMakaleHaftalikWidget({
    required this.stories,
  });

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
      if (!grouped.containsKey(week)) {
        grouped[week] = [];
      }
      grouped[week]!.add(story);
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
                                        icerik: story['icerik'],
                                        resimURL: story['imageLink'],
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

class MakaleDetay extends StatelessWidget {
  final String baslik;
  final String icerik;
  final String resimURL; // Burada parametrenin adı düzeltildi

  MakaleDetay({
    required this.baslik,
    required this.icerik,
    required this.resimURL,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              resimURL.startsWith("https")
                  ? Container(
                      height: 250,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.center,
                        image: new NetworkImage(resimURL),
                      )),
                    )
                  : Image.asset(
                      resimURL, // Burada widget.resimUrl yerine parametre olan resimURL kullanılıyor
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              Text(
                baslik,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                icerik,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 25.0),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Bu makaleyi beğendiniz mi?",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () async {
                            var _sonuc =
                                await FirestoreFunctions.makaleGeriBildirim(
                                    "Guest",
                                    "Beğendi",
                                    DateFormat('hh:mm - dd-MM-yyyy')
                                        .format(DateTime.now()));
                            print("Beğendi");
                          },
                        ),
                        SizedBox(width: 20.0),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () async {
                            var _sonuc =
                                await FirestoreFunctions.makaleGeriBildirim(
                                    "Guest",
                                    "Beğenmedi",
                                    DateFormat('hh:mm - dd-MM-yyyy')
                                        .format(DateTime.now()));

                            print("Beğenmedi");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sorumluluk reddi",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "HeyBaby uygulaması, burada sunulan bilgiler ile eğitimli bir tıp doktorunun sağlayacağı tavsiyelerin yerini almayı hedeflemez. Bu bilgiler yalnızca genel bir temele dayanarak sunulmuştur. HeyBaby uygulaması ve sahibi olan Turn Eight bu uygulamadaki bilgilere dayanarak verdiğiniz kararlar için sorumluluk üstlenmez. Ayrıca, bu bilgiler kişiselleştirilmiş bir tıbbi tavsiyenin yerini tutmaz. Lütfen en doğru bilgiler için doktorunuza danışınız.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
