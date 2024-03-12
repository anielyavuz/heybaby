import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> notlar = [];

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
              return Card(
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(notlar[index]['icerik']),
                      subtitle: Text(
                        DateFormat.yMd()
                            .add_jm()
                            .format(notlar[index]['tarih']),
                        style: TextStyle(fontSize: 10.0),
                      ),
                      trailing: IconButton(
                        icon: Icon(notlar[index]['favori']
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: () {
                          setState(() {
                            notlar[index]['favori'] = !notlar[index]['favori'];
                          });
                        },
                      ),
                    ),
                    Divider(), // Yatay çizgi
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "Tarih: ${DateFormat.yMd().add_jm().format(notlar[index]['tarih'])}",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _eklemePopup(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _eklemePopup(BuildContext context) async {
    TextEditingController notController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Not Ekle"),
          content: TextFormField(
            controller: notController,
            decoration: InputDecoration(
              labelText: 'Notunuzu Buraya Ekleyin',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notlar.add({
                    'icerik': notController.text,
                    'tarih': DateTime.now(),
                    'favori': false,
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text("Ekle"),
            ),
          ],
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
