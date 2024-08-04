import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';

class AdminFunctions extends StatefulWidget {
  @override
  _AdminFunctionsState createState() => _AdminFunctionsState();
}

class _AdminFunctionsState extends State<AdminFunctions> {
  int totalUsers = 0;
  Map loginCountByDay = {};
  Map loginDocsByDay = {};
  Map likedArticles = {};
  Map dislikedArticles = {};
  List feedBackNotes = [];
  int usersForSelectedDay = 0;
  List<String> likedContents = ['Content A', 'Content B', 'Content C'];
  List<String> dislikedContents = ['Content D', 'Content E', 'Content F'];
  List<String> feedbackMessages = [
    'Great app!',
    'Needs improvement.',
    'Loved the new feature!'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Functions'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Uyarı'),
                        content: Text(
                            'Bu işlem yüksek veri tüketimine sebep olabilir ve nadir yapılması önerilir. Devam etmek istiyor musunuz?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('İptal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              collectInformations();
                            },
                            child: Text('Devam'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Center(child: Text('Verileri Çek')),
              ),
              SizedBox(height: 20.0),

              // Total Users Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Toplam kullanıcı sayısı',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(totalUsers == 0 ? '?' : '$totalUsers'),
                ],
              ),
              SizedBox(height: 20.0),
              Text('Günlük Loginler',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // Users for Selected Day Section
              loginDocsByDay.keys.length == 0
                  ? SizedBox()
                  : ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: loginDocsByDay.entries.map((entry) {
                        String day = entry.key;
                        List<String> ids = entry.value;
                        return ExpansionTile(
                          title: Text('$day - ${ids.length} kişi girdi'),
                          children: ids
                              .map((id) => ListTile(title: Text(id)))
                              .toList(),
                        );
                      }).toList(),
                    ),
              SizedBox(height: 20.0),

              // Liked and Disliked Contents Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Beğenilen İçerikler',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...likedArticles.entries
                      .map((entry) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(entry.key)),
                              Text('${entry.value} kişi beğendi'),
                            ],
                          ))
                      .toList(),
                  SizedBox(height: 20),
                  Text('Beğenilmeyen İçerikler',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...dislikedArticles.entries
                      .map((entry) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(entry.key)),
                              Text('${entry.value} kişi beğenmedi'),
                            ],
                          ))
                      .toList(),
                ],
              ),

              SizedBox(height: 20.0),

              // Feedback Section
              Text('Geri Bildirimler',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: feedBackNotes.map((feedback) {
                  return ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${feedback['userName'].toString()} - ${feedback['tarih'].toString()}'),
                        Text('${feedback['star'].toString()}'),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(feedback['feedBackNote']),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  collectInformations() async {
    var _result2 = await FirestoreFunctions.getTotalUserInApp();

    print(_result2);
    setState(() {
      totalUsers = _result2['totalUsers'];
      loginCountByDay = _result2['loginCountByDay'];
      loginDocsByDay = _result2['loginDocsByDay'];
      likedArticles = _result2['likedArticles'];
      dislikedArticles = _result2['dislikedArticles'];
      feedBackNotes = _result2['feedBackNotes'];

      // Date format for parsing
      final dateFormat = DateFormat('dd/MM/yyyy');

      // Sort loginDocsByDay by date
      var sortedEntries = loginDocsByDay.entries.toList()
        ..sort((b, a) =>
            dateFormat.parse(a.key).compareTo(dateFormat.parse(b.key)));

      loginDocsByDay = Map.fromEntries(sortedEntries);

      feedBackNotes.sort((a, b) =>
          DateTime.parse(b['tarih']).compareTo(DateTime.parse(a['tarih'])));
    });
    print(_result2);
    return 100;
  }

  int getUsersForSelectedDay() {
    return 25;
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminFunctions(),
  ));
}
