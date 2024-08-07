import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

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

  Future<void> _premiumOl() async {
    // await Purchases.setLogLevel(LogLevel.debug);
    // print("Purchases log level set to debug.");

    // PurchasesConfiguration? configuration;

    // if (Platform.isAndroid) {
    //   print("Platform is Android.");
    //   // Android için yapılandırma ekleyin
    // } else if (Platform.isIOS) {
    //   print("Platform is iOS.");
    //   configuration =
    //       PurchasesConfiguration("appl_vFGFjyUkszfdkFPjiszIoVgsvVG");
    //   print("PurchasesConfiguration created for iOS.");
    //   await Purchases.configure(configuration);
    // }

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.activeSubscriptions.isNotEmpty) {
        String activeSubscription = customerInfo.activeSubscriptions.first;
        print("User has an active subscription: $activeSubscription");

        // Abonelik paketinin detaylarını alın
        List<EntitlementInfo> entitlements =
            customerInfo.entitlements.all.values.toList();
        for (EntitlementInfo entitlement in entitlements) {
          print(
              "Entitlement ID: ${entitlement.identifier}, isActive: ${entitlement.isActive}");
        }
      } else {
        print("User does not have an active subscription.");
        await _paymentUI();
      }
    } catch (e) {
      print("Failed to get customer info: $e");
    }

    // if (configuration != null) {
    //   try {
    //     print("Configuring Purchases...");
    //     await Purchases.configure(configuration);
    //     print("Purchases configured successfully.");
    //     await _paymentUI();
    //   } catch (e) {
    //     print("Error during Purchases configuration: $e");
    //   }
    // } else {
    //   print("Ödeme configuration null");
    // }
  }

  Future<void> _paymentUI() async {
    try {
      final paywallResult =
          await RevenueCatUI.presentPaywallIfNeeded("premium");
      print('Paywall result: $paywallResult');
    } catch (e) {
      print("Error during presenting paywall: $e");
    }
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
                GestureDetector(
                    onTap: () {
                      if (premiumStatus == "Free") {
                        _premiumOl();
                      }
                    },
                    child: Text(
                      premiumStatus,
                      style: premiumStatus == "Free"
                          ? TextStyle(
                              // fontSize: 12,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 139, 87, 149),
                            )
                          : TextStyle(
                              // fontSize: 12,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 122, 100, 14),
                            ),
                    )),
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
