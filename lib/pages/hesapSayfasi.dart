import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:heybaby/pages/adminPages/storyPaylas.dart';
import 'package:heybaby/pages/subpages/ayarlar.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HesapSayfasi extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback? onSignOutPressed;

  HesapSayfasi({Key? key, this.userData, this.onSignOutPressed})
      : super(key: key);

  @override
  _HesapSayfasiState createState() => _HesapSayfasiState();
}

class _HesapSayfasiState extends State<HesapSayfasi> {
  int _selectedStarIndex = -1;
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String lastPeriodDate = "";
  String _version = 'Unknown';

  String formatDate(String dateString) //yıl-ay-gün formatı gün-ay-yıl a çevirir
  {
    // İlk olarak, verilen stringi DateTime nesnesine dönüştürüyoruz
    DateTime dateTime = DateTime.parse(dateString);

    // Ardından, istediğimiz tarih formatını belirleyip uyguluyoruz
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    // Son olarak, yeni formatlanmış tarih string'ini döndürüyoruz
    return formattedDate;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  void initState() {
    super.initState();
    lastPeriodDate = widget.userData?['sonAdetTarihi'];
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(widget.userData?['photoURL'] ??
              'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/story0.png?alt=media&token=2025fa1c-755d-423a-9ea9-7e63e2887b9f'),
        ),
        GestureDetector(
          onTap: () async {
            var _bildirimler = await AwesomeNotifications().cancelAll();
            // await BildirimTakip().bildirimKur();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bütün bildirimler temizlendi !!!')),
            );
          },
          child: Text(
            widget.userData?['userName'] ?? 'Guest',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.userData?['email'] ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          widget.userData?['id'].substring(0, 3) +
              '....' +
              widget.userData?['id']
                  .substring(widget.userData?['id'].length - 3),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'App Version: $_version',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index <= _selectedStarIndex ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _selectedStarIndex = index;
                });
              },
            );
          }),
        ),
        SizedBox(height: 16),
        TextField(
          maxLines: 2,
          controller: noteController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Geri bildirim ve önerilerinizi bize yazın 😊',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          child: Text('Geri Bildirim Gönder'),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (noteController.text != "") {
              var sonuc = await FirestoreFunctions.sendFeedBack(
                  {widget.userData?['userName'] ?? 'Guest'},
                  {_selectedStarIndex + 1},
                  noteController.text,
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(DateTime.now())
                      .toString());
              print(sonuc);

              if (sonuc['status']) {
                noteController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Geri bildirim başarılı olarak iletildi.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Color.fromARGB(
                        255, 126, 52, 253), // Snackbar arka plan rengi
                    duration: Duration(seconds: 3), // Snackbar gösterim süresi
                    behavior: SnackBarBehavior.floating, // Snackbar davranışı
                    shape: RoundedRectangleBorder(
                      // Snackbar şekli
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4, // Snackbar yükseltilmesi
                    margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sonuc['value'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Color.fromARGB(
                        255, 126, 52, 253), // Snackbar arka plan rengi
                    duration: Duration(seconds: 3), // Snackbar gösterim süresi
                    behavior: SnackBarBehavior.floating, // Snackbar davranışı
                    shape: RoundedRectangleBorder(
                      // Snackbar şekli
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4, // Snackbar yükseltilmesi
                    margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Lütfen geri bildirim göndermek için bir kaç kelime yazın.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Color.fromARGB(
                      255, 126, 52, 253), // Snackbar arka plan rengi
                  duration: Duration(seconds: 3), // Snackbar gösterim süresi
                  behavior: SnackBarBehavior.floating, // Snackbar davranışı
                  shape: RoundedRectangleBorder(
                    // Snackbar şekli
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4, // Snackbar yükseltilmesi
                  margin: EdgeInsets.all(10), // Snackbar kenar boşlukları
                ),
              );
            }
          },
        ),
        SizedBox(height: 26),
        Spacer(),
        widget.userData!['userSubscription'] == "Admin"
            ? ElevatedButton(
                child: Text('Admin Features'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: Text("Admin Features")),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return StoryPaylasPage();
                                }));

                                // Yeni makale ilet butonuna basıldığında yapılacak işlemler
                                // Popup'ı kapat
                                // Yeni makale ilet işlemleri
                              },
                              child: Text("Story Paylaş"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                var _bildirimler = await AwesomeNotifications()
                                    .listScheduledNotifications();
                                List _bildirimIdleri = [];
                                for (var _bildirim in _bildirimler) {
                                  _bildirimIdleri.add(_bildirim.content!.id);
                                }
                                print(_bildirimIdleri);
                                // Rapor çek butonuna basıldığında yapılacak işlemler
                                // Navigator.pop(context); // Popup'ı kapat
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(_bildirimIdleri.toString())),
                                );
                              },
                              child: Text("Bildirim ID'lerini print et"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            : SizedBox(),
        SizedBox(height: 14),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return SettingsPage(userData: widget.userData);
            }));
          },
          child: Text('Ayarlar'),
        ),
        SizedBox(height: 14),
        ElevatedButton(
          onPressed: widget.onSignOutPressed,
          child: Text('Çıkış Yap'),
        ),
      ],
    );
  }
}
