import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HaftalikGuncellemeWidget extends StatefulWidget {
  final Map<String, dynamic>? userData;

  HaftalikGuncellemeWidget({
    required this.userData,
  });

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
    String data =
        await rootBundle.loadString('assets/haftalikGuncellemeler.json');
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
                    child: Text("$selectedNumber. Hafta",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19)),
                  ),

                  // Buraya fotoğraf alanı eklenebilir.
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Kilo: ${_data[selectedNumber.toString()]['kilo']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text("Boy: ${_data[selectedNumber.toString()]['boy']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Buraya kilo ve boy bilgilerinin girileceği alanlar eklenebilir.
                  SizedBox(height: 16.0),
                  Text("Anne",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 8.0),

                  Text("${_data[selectedNumber.toString()]['anne']}",
                      style: TextStyle(fontWeight: FontWeight.normal)),

                  // Buraya anneyle ilgili metin içeriği girilecek alan eklenebilir.
                  SizedBox(height: 16.0),
                  Text("Bebek",
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
    );
  }
}
