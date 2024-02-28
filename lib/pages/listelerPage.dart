import 'package:flutter/material.dart';

class BegenilenlerPage extends StatefulWidget {
  @override
  _BegenilenlerPageState createState() => _BegenilenlerPageState();
}

class _BegenilenlerPageState extends State<BegenilenlerPage> {
  List<String> begenilenHikayeler = [
    'Hikaye 1',
    'Hikaye 2',
    'Hikaye 3',
    // Daha fazla hikaye ekleyebilirsiniz
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beğenilen Hikayeler'),
      ),
      body: ListView.builder(
        itemCount: begenilenHikayeler.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(begenilenHikayeler[index]),
          );
        },
      ),
    );
  }
}
