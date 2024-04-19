import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/pages/subpages/kiloTakip.dart';

class FirestoreFunctions {
  static Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .get();
        print("Email: " + userSnapshot['email']);
        return userSnapshot.data() as Map<String, dynamic>?;

        // Alternatif olarak, sadece belirli bir alt küme bilgiyi almak istiyorsanız şu şekilde kullanabilirsiniz:
        // return {
        //   'username': userSnapshot['username'],
        //   'email': userSnapshot['email'],
        //   // Diğer alanlar...
        // };
      } catch (e) {
        // Firestore'dan veri çekme sırasında bir hata oluştu
        print('Firestore veri çekme hatası: $e');
        return null;
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
      return null;
    }
  }

  static Future<void> notlarDataDeleteRecord(_index) async {
    User? user = FirebaseAuth.instance.currentUser;
    List _tempList = [];
    _tempList.add(_index);
    print(_tempList);

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"notlar": FieldValue.arrayRemove(_tempList)});

        print('Veri başarıyla güncellendi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> bildirimEkleme(_kategori, _id, _isim, _zaman) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"bildirimler.$_kategori.$_id": "$_isim%%%$_zaman"});

        BildirimTakip().ilacBildirim(
            _id = _id,
            _isim.toString().split("%%")[0],
            int.parse(_zaman.toString().split('-')[0].split(':')[0]),
            int.parse(_zaman.toString().split('-')[0].split(':')[1]),
            int.parse(_zaman.toString().split('-')[1].split('.')[0]),
            int.parse(_zaman.toString().split('-')[1].split('.')[1]),
            int.parse(_zaman.toString().split('-')[1].split('.')[2]),
            _isim.toString().split("%%")[1]);
        print('Veri başarıyla güncellendi. Bildirimler...');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> notlarDataRecord(_tempList) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({
          "notlar": _tempList

          //       {

          //   "dataRecord": {
          //     "waterDrinkData": {
          //       "type": "Bardak",
          //       "amount": 200,
          //       "count": 1,
          //       "date": DateTime.now()
          //     }
          //   }
          // }
        });

        print('Veri başarıyla güncellendi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> yapilacaklarDataRecord(_tempList) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({
          "dataRecord.yapilacaklarData": _tempList

          //       {

          //   "dataRecord": {
          //     "waterDrinkData": {
          //       "type": "Bardak",
          //       "amount": 200,
          //       "count": 1,
          //       "date": DateTime.now()
          //     }
          //   }
          // }
        });

        print('Veri başarıyla güncellendi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> updateDataRecord(
      Map<String, dynamic> newData, String _type) async {
    User? user = FirebaseAuth.instance.currentUser;
    List _tempList = [];
    _tempList.add(newData);
    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({
          "dataRecord.$_type": FieldValue.arrayUnion(_tempList)

          //       {

          //   "dataRecord": {
          //     "waterDrinkData": {
          //       "type": "Bardak",
          //       "amount": 200,
          //       "count": 1,
          //       "date": DateTime.now()
          //     }
          //   }
          // }
        });

        print('Veri başarıyla güncellendi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> updateKiloDataRecord(
      WeightEntry newData, String _type) async {
    User? user = FirebaseAuth.instance.currentUser;
    List _tempList = [];
    Map _tempMap = {};
    _tempMap['weight'] = newData.weight;
    _tempMap['dateTime'] = newData.dateTime;
    _tempMap['isMotherWeight'] = newData.isMotherWeight;
    _tempMap['dogumOnceSonra'] = newData.dogumOnceSonra;
    _tempList.add(_tempMap);
    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({
          "dataRecord.$_type": FieldValue.arrayUnion(_tempList)

          //       {

          //   "dataRecord": {
          //     "waterDrinkData": {
          //       "type": "Bardak",
          //       "amount": 200,
          //       "count": 1,
          //       "date": DateTime.now()
          //     }
          //   }
          // }
        });

        print('Veri başarıyla güncellendi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> deleteCalendarDataRecord(selectedDay, _liste) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userID = user.uid;
      String _tempselectedDay = selectedDay
          .toString()
          .substring(0, selectedDay.toString().length - 7);
      print("UserID: " + userID);
      List k = [];
      k.add(_liste);

      await FirebaseFirestore.instance.collection("Users").doc(userID).update({
        "calendarListEvents.$_tempselectedDay": FieldValue.arrayRemove(k)
      }).whenComplete(() {
        print("takvimden veri silindi");
      });
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> duzenleCalendarDataRecord(
      selectedDay, calendarListEventsForDay) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userID = user.uid;
      print("UserID: " + userID);
      String _tempselectedDay = selectedDay
          .toString()
          .substring(0, selectedDay.toString().length - 7);
      print("CCCCC");
      FirebaseFirestore.instance.collection("Users").doc(userID).update({
        "calendarListEvents.$_tempselectedDay": calendarListEventsForDay,
      });

      // String _tempselectedDay = selectedDay
      //     .toString()
      //     .substring(0, selectedDay.toString().length - 7);
      // print("CCCCC");
      // // print(_tempList);
      // int _tempIndex = 0;
      // await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc(userID)
      //     .get()
      //     .then((gelenVeri) {
      //   print(gelenVeri.data()!['calendarListEvents'][_tempselectedDay]);
      //   for (var _elemanlar in gelenVeri
      //       .data()!['calendarListEvents'][_tempselectedDay]
      //       .toList()) {
      //     print(_elemanlar['id']);
      //     if (_elemanlar['id'] == editId) {
      //       print(_elemanlar['id'].toString() + " için düzenleme yapılacak");

      //       FirebaseFirestore.instance.collection("Users").doc(userID).update({
      //         "calendarListEvents.$_tempselectedDay":
      //             calendarListEventsForDay,
      //       });
      //     }
      //     _tempIndex = _tempIndex + 1;
    }

    // if (gelenVeri.data()!["settings"]["host"] == widget.userName) {
    //   var _geciciKeyListe = gelenVeri.data().keys.toList();

    //   for (var item in _geciciKeyListe) {
    //     if (item != "settings") {
    //       if (item != widget.userName) {
    //         if (!_hostuDegistirdimMi) {
    //           _hostuDegistirdimMi = true;
    //           print(item);
    //           FirebaseFirestore.instance
    //               .collection('Multiplayer')
    //               .doc(widget.lobbyid)
    //               .update({
    //             "settings.host": item,
    //             item + ".ready": true,
    //           }).whenComplete(() {
    //             FirebaseFirestore.instance
    //                 .collection('MultiplayerLobby')
    //                 .doc(widget.lobbyid)
    //                 .update({
    //               "host": item,
    //             });
    //           });
    //         }
    //       }
    //     }
    //   }
    // }
    // print("Kazanan " + kazanan.toString());
  }

  static Future<void> updateCalendarDataRecord(
    _tempList,
    selectedDay,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userID = user.uid;
      print("UserID: " + userID);
      String _tempselectedDay = selectedDay
          .toString()
          .substring(0, selectedDay.toString().length - 7);
      print(_tempselectedDay);
      print(_tempList);

      await FirebaseFirestore.instance.collection("Users").doc(userID).update({
        "calendarListEvents.$_tempselectedDay": FieldValue.arrayUnion(_tempList)
      });
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  // static Future<void> addIlacDataRecord(
  //   Map<String, dynamic> newData,
  // ) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   List _tempList = [];
  //   _tempList.add(newData);
  //   if (user != null) {
  //     try {
  //       String userID = user.uid;
  //       print("UserID: " + userID);

  //       await FirebaseFirestore.instance
  //           .collection("Users")
  //           .doc(userID)
  //           .update({"ilacListesi": FieldValue.arrayUnion(_tempList)});

  //       print('Veri başarıyla güncellendi.');
  //     } catch (e) {
  //       // Firestore'a veri güncelleme sırasında bir hata oluştu
  //       print('Firestore veri güncelleme hatası: $e');
  //     }
  //   } else {
  //     print('Kullanıcı giriş yapmamış.');
  //   }
  // }
}
