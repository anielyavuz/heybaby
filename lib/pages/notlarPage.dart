import 'package:firebase_messaging/firebase_messaging.dart';
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
  void initState() {
    // init();  //firebase messaging modülü ama çalışmıyor.
    super.initState();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print("###### PRINT DEVICE TOKEN TO USE FOR PUSH NOTIFCIATION ######");
    print(deviceToken);
    print("############################################################");

    // listen for user to click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      String? title = remoteMessage.notification!.title;
      String? description = remoteMessage.notification!.body;
      print(title);
      print(description);
      //im gonna have an alertdialog when clicking from push notification
      // Alert(
      //   context: context,
      //   type: AlertType.error,
      //   title: title, // title from push notification data
      //   desc: description, // description from push notifcation data
      //   buttons: [
      //     DialogButton(
      //       child: Text(
      //         "COOL",
      //         style: TextStyle(color: Colors.white, fontSize: 20),
      //       ),
      //       onPressed: () => Navigator.pop(context),
      //       width: 120,
      //     )
      //   ],
      // ).show();
    });
  }

  //get device token to use for push notification
  Future getDeviceToken() async {
    //request user permission for push notification
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }

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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // FAB'ın konumunu sola alır
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
