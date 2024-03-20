import 'package:flutter/material.dart';

class KesfetMakaleWidget extends StatelessWidget {
  final String baslik;
  final String makale;
  final String resimUrl;

  KesfetMakaleWidget({
    required this.baslik,
    required this.makale,
    required this.resimUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(baslik),
          ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              resimUrl,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              baslik,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              makale,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

// Kullanım örneği:
// KesfetMakaleWidget(
//   başlık: "Flutter ile Mobil Uygulama Geliştirme",
//   makale: "Flutter, Google tarafından geliştirilen açık kaynaklı bir UI kitidir...",
//   resimUrl: 'assets/yiyecek_icicek.jpg',
// )
