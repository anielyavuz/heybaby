import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HaftalikGuncellemeWidget extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String language;
  final bool referansAktif;
  final List referansList;

  HaftalikGuncellemeWidget(
      {required this.userData,
      required this.language,
      required this.referansAktif,
      required this.referansList});

  @override
  _HaftalikGuncellemeWidgetState createState() =>
      _HaftalikGuncellemeWidgetState();
}

class _HaftalikGuncellemeWidgetState extends State<HaftalikGuncellemeWidget> {
  var _data;
  var selectedNumber = 4;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedNumber = (((DateTime.now().difference(
                  DateTime.parse(widget.userData?['sonAdetTarihi'])))
              .inDays) ~/
          7);
    });

    _getData();
  }

  Future<void> _getData() async {
    String data = "";
    if (widget.language == "Türkçe") {
      data = await rootBundle.loadString('assets/haftalikGuncellemeler.json');
    } else {
      data =
          await rootBundle.loadString('assets/haftalikGuncellemeler_en.json');
    }

    var jsonResult = json.decode(data);
    setState(() {
      _data = jsonResult;
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
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 156.0, // Genişlik ayarı
                        height: 156.0, // Yükseklik ayarı
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/ultrason/$selectedNumber.png'), // Buradaki yol assets klasörünüzün kökünden itibaren belirtilmelidir
                            fit: BoxFit
                                .fill, // Resmi butona tam olarak dolduracak şekilde ayarla
                          ),
                        ),
                      ),
                    ],
                  ),

                  Center(
                    child: Slider(
                      value: selectedNumber.toDouble(),
                      min: 4,
                      max: 40,
                      divisions:
                          36, // İsteğe bağlı, kaydırma çubuğundaki bölümlerin sayısı
                      label: selectedNumber.toString(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedNumber = newValue.toInt();
                        });
                      },
                    ),
                  ),

                  Center(
                    child: Text(
                        "$selectedNumber. ${AppLocalizations.of(context)!.hafta}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19)),
                  ),

                  // Buraya fotoğraf alanı eklenebilir.
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                          "${AppLocalizations.of(context)!.kilosu}: ${_data[selectedNumber.toString()]['kilo']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text(
                          "${AppLocalizations.of(context)!.boyu}: ${_data[selectedNumber.toString()]['boy']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Buraya kilo ve boy bilgilerinin girileceği alanlar eklenebilir.
                  SizedBox(height: 16.0),
                  Text("${AppLocalizations.of(context)!.haftalikBilgiAnne}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 8.0),

                  Text("${_data[selectedNumber.toString()]['anne']}",
                      style: TextStyle(fontWeight: FontWeight.normal)),

                  // Buraya anneyle ilgili metin içeriği girilecek alan eklenebilir.
                  SizedBox(height: 16.0),
                  Text("${AppLocalizations.of(context)!.haftalikBilgiBebek}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 8.0),
                  Text("${_data[selectedNumber.toString()]['bebek']}",
                      style: TextStyle(fontWeight: FontWeight.normal)),

                  // Buraya bebekle ilgili metin içeriği girilecek alan eklenebilir.
                  SizedBox(height: 16.0),
                  _data[selectedNumber.toString()]['esi'] != ""
                      ? Column(
                          children: [
                            Text("Eşi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 8.0),
                            Text("${_data[selectedNumber.toString()]['esi']}",
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),

                            // Buraya eşiyle ilgili metin içeriği girilecek alan eklenebilir.
                            SizedBox(height: 16.0),
                          ],
                        )
                      : SizedBox(),

                  _data[selectedNumber.toString()]['saglikIpucu'] != ""
                      ? Column(
                          children: [
                            Text("Sağlık İpuçları",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 8.0),
                            Text(
                                "${_data[selectedNumber.toString()]['saglikIpucu']}",
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),

                            // Buraya eşiyle ilgili metin içeriği girilecek alan eklenebilir.
                            SizedBox(height: 16.0),
                          ],
                        )
                      : SizedBox(),
                  // Buraya sağlık ipuçlarıyla ilgili metin içeriği girilecek alan eklenebilir.
                  SizedBox(height: 46.0),

                  Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.makaleSorumlulukReddi,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(158, 158, 158, 1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .makaleSorumlulukMetin,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!.makaleReferans,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        widget.referansAktif
                            ? Container(
                                height: widget.referansList.length * 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          158, 158, 158, 1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListView.builder(
                                  itemCount: widget.referansList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        "* " + widget.referansList[index],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
