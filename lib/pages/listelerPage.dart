import 'package:flutter/material.dart';

class ListelerPage extends StatefulWidget {
  const ListelerPage({Key? key, this.userData}) : super(key: key);
  final Map<String, dynamic>? userData;
  @override
  _ListelerPageState createState() => _ListelerPageState();
}

class _ListelerPageState extends State<ListelerPage> {
  TextEditingController hatirlaticiController = TextEditingController();
  List<Animsatici> hatirlaticilar = [];
  List<Animsatici> tamamlananlar = [];

  bool tamamlananlarAcik = false; // Detayları göster/gizle durumu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Anımsatıcı Ekleme Formu
            TextFormField(
              controller: hatirlaticiController,
              decoration: InputDecoration(
                labelText: 'Yeni Anımsatıcı Ekle',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  hatirlaticilar.add(Animsatici(hatirlaticiController.text));
                  hatirlaticiController.clear();
                });
              },
              child: Text("Ekle"),
            ),
            SizedBox(height: 24.0),
            // Anımsatıcı Listesi
            Text(
              'Anımsatıcılar',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: hatirlaticilar.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: hatirlaticilar[index].tamamlandi,
                      onChanged: (value) {
                        setState(() {
                          hatirlaticilar[index].tamamlandi = value!;
                          if (hatirlaticilar[index].tamamlandi) {
                            tamamlananlar.add(hatirlaticilar[index]);
                            hatirlaticilar.removeAt(index);
                          }
                        });
                      },
                    ),
                    title: Text(hatirlaticilar[index].icerik),
                  );
                },
              ),
            ),
            SizedBox(height: 24.0),
            // Tamamlananlar Listesi
            GestureDetector(
              onTap: () {
                setState(() {
                  tamamlananlarAcik = !tamamlananlarAcik;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tamamlananlar',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    tamamlananlarAcik
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            tamamlananlarAcik
                ? Expanded(
                    child: ListView.builder(
                      itemCount: tamamlananlar.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(tamamlananlar[index].icerik),
                          // Burada tarih, saat veya başka bilgiler de ekleyebilirsiniz.
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Toplam Tamamlananlar: ${tamamlananlar.length}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class Animsatici {
  String icerik;
  bool tamamlandi;

  Animsatici(this.icerik, {this.tamamlandi = false});
}

void main() {
  runApp(
    MaterialApp(
      home: ListelerPage(),
    ),
  );
}
