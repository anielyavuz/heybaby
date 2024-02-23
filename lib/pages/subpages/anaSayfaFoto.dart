import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:heybaby/functions/jsonFiles.dart';

class TrimesterProgressWidget extends StatefulWidget {
  @override
  State<TrimesterProgressWidget> createState() =>
      _TrimesterProgressWidgetState();
}

class _TrimesterProgressWidgetState extends State<TrimesterProgressWidget> {
  late List<dynamic> jsonList = []; // Global değişken tanımı
  late List<dynamic> jsonList0 = [];
  imageandInfoJsonFileLoad() async {
    jsonList0 = await JsonReader.readJson();
    setState(() {
      jsonList = jsonList0;
    });
    // print(jsonList);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 50), () {
      imageandInfoJsonFileLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime(2024, 5, 8);
    DateTime startDate = DateTime(2024, 1, 1); // Başlangıç tarihi
    DateTime endDate = DateTime(2024, 10, 11); // Bitiş tarihi

    double totalDays = endDate.difference(startDate).inDays.toDouble();
    double passedDays = currentDate.difference(startDate).inDays.toDouble();
////
    int differenceInDays = endDate.difference(currentDate).inDays;
    int _dogumaKalanHafta = differenceInDays ~/ 7;
////
    ///
    Duration difference = currentDate.difference(startDate);

    int differenceDays = difference.inDays;
    int weeks = differenceDays ~/ 7;
    int remainingDays = differenceDays % 7;
    String _tahminiKilo = "";
    String _tahminiBoy = "";
    String _imageLink = "";
    String _gifLink = "";
    String _benzerlik = "";
    if (jsonList.isNotEmpty) {
      if (weeks < 41) {
        if (weeks >= 4) {
          _tahminiKilo = jsonList[weeks - 4]['kilo'];
          _tahminiBoy = jsonList[weeks - 4]['boy'];
          _imageLink = jsonList[weeks - 4]['foto_link'];
          _benzerlik = jsonList[weeks - 4]['benzerlik'];
          _gifLink = jsonList[weeks - 4]['gif_link'];
        } else {
          _tahminiKilo = jsonList[0]['kilo'];
          _tahminiBoy = jsonList[0]['boy'];
          _imageLink = jsonList[0]['foto_link'];
          _benzerlik = jsonList[0]['benzerlik'];
          _gifLink = jsonList[0]['gif_link'];
        }
      } else {
        _tahminiKilo = jsonList[36]['kilo'];
        _tahminiBoy = jsonList[36]['boy'];
        _imageLink = jsonList[36]['foto_link'];
        _benzerlik = jsonList[36]['benzerlik'];
        _gifLink = jsonList[36]['gif_link'];
      }
    }

    String _mevcutTarih;
    if (weeks > 0) {
      _mevcutTarih = '$weeks. hafta';
      if (remainingDays > 0) {
        _mevcutTarih += ' $remainingDays. gün';
      }
    } else {
      _mevcutTarih = '$remainingDays. gün';
    }

    ///
    ///

    double progress = passedDays / totalDays;
    // print("progress " + progress.toString());
    double firstTrimesterProgress = progress.clamp(0.0, 0.333);
    // print("progress1 " + firstTrimesterProgress.toString());
    double secondTrimesterProgress = (progress.clamp(0.333, 0.666)) - 0.333;
    // print("progress2 " + secondTrimesterProgress.toString());
    double thirdTrimesterProgress = (progress.clamp(0.666, 1.0) - 0.666);
    // print("progress3 " + thirdTrimesterProgress.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              // 1. Trimester
              Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: firstTrimesterProgress * 300,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffcdb4db),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: (0.05) *
                            300), // Soldan 16 birimlik bir padding ekler
                    child: Text(
                      "1.Trimester",
                      style: TextStyle(
                          fontSize:
                              14.0), // Opsiyonel olarak stil ekleyebilirsiniz
                    ),
                  )
                ],
              ),
              // 2. Trimester
              Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: secondTrimesterProgress * 300,
                    height: 30,
                    margin: EdgeInsets.only(left: firstTrimesterProgress * 300),
                    decoration: BoxDecoration(
                      color: Color(0xff80ed99),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: (0.373) *
                            300), // Soldan 16 birimlik bir padding ekler
                    child: Text(
                      "2.Trimester",
                      style: TextStyle(
                          fontSize:
                              14.0), // Opsiyonel olarak stil ekleyebilirsiniz
                    ),
                  )
                ],
              ),
              // 3. Trimester
              Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: thirdTrimesterProgress * 300,
                    height: 30,
                    margin: EdgeInsets.only(
                        left:
                            (firstTrimesterProgress + secondTrimesterProgress) *
                                300),
                    decoration: BoxDecoration(
                      color: Color(0xffff4d6d),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: (0.696) *
                            300), // Soldan 16 birimlik bir padding ekler
                    child: Text(
                      "3.Trimester",
                      style: TextStyle(
                          fontSize:
                              14.0), // Opsiyonel olarak stil ekleyebilirsiniz
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        _dogumaKalanHafta > 0
            ? Text(
                'Doğuma yaklaşık $_dogumaKalanHafta hafta kaldı',
                style: TextStyle(fontSize: 15),
              )
            : Text(
                'Doğum çok yakında 😇',
                style: TextStyle(fontSize: 15),
              ),
        SizedBox(height: 5),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: _imageLink != ""
              ? Image.network(
                  _gifLink,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Yükleme tamamlandıysa görüntüyü göster
                    } else {
                      return Image.network(
                        _imageLink, // Yükleme sürecinde gösterilecek ikinci bir GIF
                        fit: BoxFit.cover,
                      );
                    }
                  },
                )
              : CircularProgressIndicator(),
        ),
        Text("Bebeğiniz şuan bir $_benzerlik boyutunda",
            style: TextStyle(fontSize: 14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Boy: $_tahminiBoy',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '$_mevcutTarih',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Ağırlık: $_tahminiKilo',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
