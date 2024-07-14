import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KesfetMakaleWidget extends StatefulWidget {
  final List stories;
  final String baslik;
  final String resimUrl;
  final String language;

  KesfetMakaleWidget(
      {required this.stories,
      required this.baslik,
      required this.resimUrl,
      required this.language});

  @override
  _KesfetMakaleWidgetState createState() => _KesfetMakaleWidgetState();
}

class _KesfetMakaleWidgetState extends State<KesfetMakaleWidget> {
  late Map<String, dynamic> _data = {};
  late List makaleler = [];
  String data = "";
  @override
  void initState() {
    // print(widget.stories);

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
                icerik.toString(),
                style: TextStyle(fontSize: 18.0),
                softWrap:
                    true, // Metnin satır sonuna geldiğinde otomatik olarak sarılmasını sağlar
                overflow: TextOverflow
                    .visible, // Metin taşarsa görünür olmasını sağlar
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
                                            .format(DateTime.now()),
                                        baslik)
                                    .whenComplete(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Geri bildirim başarılı olarak iletildi.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Color.fromARGB(255, 126, 52,
                                      253), // Snackbar arka plan rengi
                                  duration: Duration(
                                      seconds: 3), // Snackbar gösterim süresi
                                  behavior: SnackBarBehavior
                                      .floating, // Snackbar davranışı
                                  shape: RoundedRectangleBorder(
                                    // Snackbar şekli
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4, // Snackbar yükseltilmesi
                                  margin: EdgeInsets.all(
                                      10), // Snackbar kenar boşlukları
                                ),
                              );
                            });
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
                                            .format(DateTime.now()),
                                        baslik)
                                    .whenComplete(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Geri bildirim başarılı olarak iletildi.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Color.fromARGB(255, 126, 52,
                                      253), // Snackbar arka plan rengi
                                  duration: Duration(
                                      seconds: 3), // Snackbar gösterim süresi
                                  behavior: SnackBarBehavior
                                      .floating, // Snackbar davranışı
                                  shape: RoundedRectangleBorder(
                                    // Snackbar şekli
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4, // Snackbar yükseltilmesi
                                  margin: EdgeInsets.all(
                                      10), // Snackbar kenar boşlukları
                                ),
                              );
                            });

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
