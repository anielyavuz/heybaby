import 'package:flutter/material.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';

class NotlarPage extends StatefulWidget {
  const NotlarPage({
    Key? key,
    this.userData,
  }) : super(key: key);
  final Map<String, dynamic>? userData;

  @override
  _NotlarPageState createState() => _NotlarPageState();
}

class _NotlarPageState extends State<NotlarPage> {
  List notlar = [];
  int selectedWeek = 1;

  gunlukDBEkle() async {
    var _result2 = await FirestoreFunctions.notlarDataRecord(notlar);
  }

  @override
  void initState() {
    // print(widget.userData);
    selectedWeek = (((DateTime.now()
                .difference(DateTime.parse(widget.userData?['sonAdetTarihi'])))
            .inDays) ~/
        7);

    if (widget.userData != null && widget.userData!.containsKey('notlar')) {
      setState(() {
        // notlar = widget.userData!['notlar'];
        for (var _element in widget.userData!['notlar']) {
          Map _tempMap = {};

          _tempMap['favori'] = _element['favori'];
          _tempMap['icerik'] = _element['icerik'];
          _tempMap['tarih'] = _element['tarih'];
          ;
          notlar.add(_tempMap);
        }
      });
    } else {
      print('yapilacaklarData parametresi bulunamadı veya null.');
    }
    print(notlar);

    // print((((DateTime.now().difference(
    //                 DateTime.parse(widget.userData?['sonAdetTarihi'])))
    //             .inDays) ~/
    //         7)
    //     .toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Kalplenen notları en üstte göstermek için sıralama yapılıyor
    notlar.sort((a, b) {
      if (a['favori'] && !b['favori']) {
        return -1;
      } else if (!a['favori'] && b['favori']) {
        return 1;
      } else {
        return b['tarih'].compareTo(a['tarih']);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Günlük'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 116, 0, 248),
              Color.fromARGB(255, 154, 118, 232)
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: notlar.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(notlar[index].toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                onDismissed: (direction) async {
                  var _result2 =
                      await FirestoreFunctions.notlarDataDeleteRecord(
                          notlar[index]);
                  setState(() {
                    print(notlar);
                    notlar.removeAt(index);
                    print(notlar);
                  });
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(notlar[index]['icerik']),
                        // subtitle: Text(
                        //   DateFormat.yMd()
                        //       .add_jm()
                        //       .format(notlar[index]['tarih']),
                        //   style: TextStyle(fontSize: 10.0),
                        // ),
                        trailing: IconButton(
                          icon: Icon(notlar[index]['favori']
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            setState(() {
                              print("INDEXXXxx $index");
                              notlar[index]['favori'] =
                                  !notlar[index]['favori'];
                            });
                            gunlukDBEkle();
                            print(notlar);
                          },
                        ),
                      ),
                      Divider(), // Yatay çizgi
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          DateFormat("HH:mm MM/dd/yyyy").format(
                              DateFormat("HH:mm MM/dd/yyyy")
                                  .parse(notlar[index]['tarih'])),
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 92, 64, 219),
        foregroundColor: Colors.white,
        onPressed: () {
          _showChatModalBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _showChatModalBottomSheet(BuildContext context) async {
    TextEditingController notController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height *
              0.95, // İstediğiniz yükseklik

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        notlar.add({
                          'icerik': notController.text,
                          'tarih': DateFormat("HH:mm MM/dd/yyyy")
                              .format(DateTime.now()),
                          'favori': false,
                        });
                      });
                      gunlukDBEkle();
                      Navigator.of(context).pop();
                    },
                    child: Text("Bitti"),
                  ),
                ],
              ),
              Expanded(
                child: TextFormField(
                  controller: notController,
                  decoration: InputDecoration(
                    hintText:
                        'Yazmaya başlayın...', // labelText yerine hintText kullanıldı
                    border: InputBorder.none, // Alt çizgiyi kaldırır
                  ),
                  maxLines: null, // Yeni satırlara izin vermek için
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: NotlarPage(),
    ),
  );
}
