import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  SettingsPage({Key? key, this.userData}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int waterIntake = 2000;
  String premiumStatus = "Free";
  bool waterReminder = true;
  String selectedLanguage = "Türkçe";
  String lastPeriodDate = "";

  String formatDate(String dateString) //yıl-ay-gün formatı gün-ay-yıl a çevirir
  {
    // İlk olarak, verilen stringi DateTime nesnesine dönüştürüyoruz
    DateTime dateTime = DateTime.parse(dateString);

    // Ardından, istediğimiz tarih formatını belirleyip uyguluyoruz
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    // Son olarak, yeni formatlanmış tarih string'ini döndürüyoruz
    return formattedDate;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    setState(() {
      lastPeriodDate = widget.userData?['sonAdetTarihi'];
      premiumStatus = widget.userData!['userSubscription'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.hesapAyarlar),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.hesapHesapDurumu),
                Text(premiumStatus),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.hesapDil),
                Text(AppLocalizations.of(context)!.language)
                // DropdownButton<String>(
                //   value: selectedLanguage,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       selectedLanguage = newValue!;
                //     });
                //   },
                //   items: <String>[
                //     'Türkçe',
                //     // 'İngilizce',
                //     // 'Almanca',
                //     // 'İspanyolca'
                //   ].map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.hesapSonReglTarihi} ${formatDate(lastPeriodDate)}',
                  style: TextStyle(
                    // fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    print("Test");
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(lastPeriodDate),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null &&
                        DateFormat('yyyy-MM-dd').format(picked) !=
                            lastPeriodDate) {
                      setState(() {
                        print(lastPeriodDate);
                        lastPeriodDate =
                            DateFormat('yyyy-MM-dd').format(picked);
                        print(lastPeriodDate);
                      });
                      var sonuc =
                          await FirestoreFunctions.sonAdetTarihiGuncelle(
                              lastPeriodDate);

                      var _bildirimler = await AwesomeNotifications()
                          .listScheduledNotifications();
                      List _bildirimIdleri = [];
                      List _haftalikBildirimler = [];
                      for (var _bildirim in _bildirimler) {
                        if (_bildirim.content!.id! < 1999) {
                          var a = await AwesomeNotifications()
                              .cancel(_bildirim.content!.id!)
                              .whenComplete(() => print(
                                  "${_bildirim.content!.id!}  id'li bildirim silindi"));
                        }
                      }
                    }
                  },
                  child: Icon(
                    Icons.settings,
                    color: const Color.fromARGB(255, 139, 87, 149),
                  ),
                )
              ],
            ),
            Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.gunlukKaydet),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
