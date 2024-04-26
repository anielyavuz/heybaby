import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/functions/firestoreFunctions.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(widget.userData?['photoURL'] ??
              'https://placekitten.com/200/200'),
        ),
        GestureDetector(
          onTap: () async {
            // BildirimTakip.haftalikBoyutBilgisi(1021, "_testBenzerlik",
            //     "https://placekitten.com/200/200", 10, 00, 29, 04, 2025);

            var _bildirimler = await AwesomeNotifications().cancelAll();
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
          decoration: InputDecoration(
            hintText: 'Geri bildiriminizi buraya yazın',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          child: Text('Geri Bildirim Gönder'),
          onPressed: () async {
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
            var sonuc = await FirestoreFunctions.sendFeedBack(
                {widget.userData?['userName'] ?? 'Guest'},
                {_selectedStarIndex + 1},
                noteController.text,
                DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(DateTime.now())
                    .toString());
            print(sonuc);
            FocusScope.of(context).unfocus();
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
          },
        ),
        // ElevatedButton(
        //   child: Text(
        //     'Beğendiğim Storyler',
        //   ),
        //   onPressed: () {},
        // ),
        SizedBox(height: 44),
        ElevatedButton(
          onPressed: widget.onSignOutPressed,
          child: Text('Çıkış Yap'),
        ),
      ],
    );
  }
}
