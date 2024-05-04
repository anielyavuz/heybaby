import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';

class KesfetMakaleWidget extends StatefulWidget {
  final String baslik;
  final String resimUrl;

  KesfetMakaleWidget({
    required this.baslik,
    required this.resimUrl,
  });

  @override
  _KesfetMakaleWidgetState createState() => _KesfetMakaleWidgetState();
}

class _KesfetMakaleWidgetState extends State<KesfetMakaleWidget> {
  late Map<String, dynamic> _data;

  @override
  void initState() {
    print("TTTT");
    print(widget.baslik.toString());
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    String data = await rootBundle.loadString('assets/kesfetMakale.json');
    Map<String, dynamic> jsonResult = json.decode(data);
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _data['Makaleler'][widget.baslik]
                          .map<Widget>((makale) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MakaleDetay(
                                          baslik: makale['baslik'],
                                          icerik: makale['icerik'],
                                          resimURL: widget.resimUrl,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
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
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
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
