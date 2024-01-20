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
  List<Not> notlar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Notlar',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: notlar.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notlar[index].icerik),
                    subtitle: Text(
                      DateFormat.yMd().add_jm().format(notlar[index].tarih),
                      style: TextStyle(fontSize: 10.0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _eklemePopup(context);
        },
        child: Icon(Icons.add),
      ),
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
                  notlar.add(Not(notController.text, DateTime.now()));
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

class Not {
  String icerik;
  DateTime tarih;

  Not(this.icerik, this.tarih);
}

void main() {
  runApp(
    MaterialApp(
      home: NotlarPage(),
    ),
  );
}
