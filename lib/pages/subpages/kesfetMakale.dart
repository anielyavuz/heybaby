import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/functions/ad_helper.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/subpages/kesfetMakaleHaftalik.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heybaby/pages/subpages/makaleDetay.dart';

class KesfetMakaleWidget extends StatefulWidget {
  final List stories;
  final String baslik;
  final String resimUrl;
  final String language;
  final bool referansAktif;
  final List referansList;
  final String userSubscription;

  KesfetMakaleWidget(
      {required this.stories,
      required this.baslik,
      required this.resimUrl,
      required this.language,
      required this.referansAktif,
      required this.referansList,
      required this.userSubscription});

  @override
  _KesfetMakaleWidgetState createState() => _KesfetMakaleWidgetState();
}

class _KesfetMakaleWidgetState extends State<KesfetMakaleWidget> {
  late Map<String, dynamic> _data = {};
  late List makaleler = [];
  String data = "";

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    if (widget.language == "English") {
      print("Dil ingilizce, ing makaleler çekiyorum.");
      data = await rootBundle.loadString('assets/kesfetMakale_en.json');
    } else {
      print("Dil türkçe, türkçe makaleler çekiyorum.");

      data = await rootBundle.loadString('assets/kesfetMakale.json');
    }
    Map<String, dynamic> jsonResult = json.decode(data);
    setState(() {
      _data = jsonResult;
      print("0000000000  ${widget.stories}");
      print("1111111111  ${widget.baslik}");
      for (var _story in widget.stories) {
        if (_story['kategori'] == widget.baslik) {
          // print(_story);
          _data['Makaleler'][widget.baslik].add(_story);
        }
      }

      makaleler = _data['Makaleler'][widget.baslik];
      makaleler.sort((b, a) => a['id'].compareTo(b['id']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: makaleler
                          .map<Widget>((makale) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MakaleDetay(
                                          baslik: makale['baslik'],
                                          icerik: makale['icerik']
                                              .toString()
                                              .replaceAll('%', '\n'),
                                          resimURL:
                                              makale.containsKey('imageLink')
                                                  ? makale['imageLink']
                                                  : widget.resimUrl,
                                          referansAktif: widget.referansAktif,
                                          referansList: widget.referansList,
                                          isMakalePremium: makale['premium'],
                                          isUserPremium:
                                              widget.userSubscription == "Free"
                                                  ? false
                                                  : true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      makale.containsKey('imageLink')
                                          ? makale['imageLink']
                                                  .startsWith("https")
                                              ? Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      image:
                                                          new DecorationImage(
                                                        fit: BoxFit.fitWidth,
                                                        alignment:
                                                            FractionalOffset
                                                                .center,
                                                        image: new NetworkImage(
                                                            makale[
                                                                'imageLink']),
                                                      )),
                                                )
                                              : Image.asset(
                                                  makale[
                                                      'imageLink'], // Burada widget.resimUrl yerine parametre olan resimURL kullanılıyor
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    widget.resimUrl,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: 16.0),
                                      Expanded(
                                        child: Text(
                                          makale['baslik'],
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
                                          color: makale['premium']
                                              ? const Color.fromARGB(
                                                  255, 124, 33, 243)
                                              : Color.fromARGB(
                                                  255, 209, 185, 241),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          makale['premium']
                                              ? "Premium"
                                              : "Free",
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
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
