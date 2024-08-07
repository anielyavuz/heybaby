import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heybaby/functions/bildirimTakip.dart';
import 'package:heybaby/pages/subpages/kiloTakip.dart';

class FirestoreFunctions {
  static Future<Map<dynamic, dynamic>> getTotalUserInApp() async {
    Map<dynamic, dynamic> _returnValue = {
      'totalUsers': 0,
      'loginCountByDay': {},
      'loginDocsByDay': {},
      'likedArticles': {},
      'dislikedArticles': {},
      'feedBackNotes': []
    };

    try {
      // Users collection
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("Users").get();

      _returnValue['totalUsers'] = userSnapshot.docs.length;

      // Günlere göre login olan kişi sayısını ve doc.id'leri tutacak harita
      Map<String, List<String>> loginCountByDay = {};

      // Her kullanıcı belgesi için iterasyon yap
      for (var doc in userSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('loginDays')) {
          List<dynamic> loginDays = data['loginDays'];

          for (String day in loginDays) {
            if (!loginCountByDay.containsKey(day)) {
              loginCountByDay[day] = [];
            }
            loginCountByDay[day]!.add(doc.id);
          }
        }
      }

      // Günlere göre kişi sayısını çıkar
      Map<String, int> loginCountSummary =
          loginCountByDay.map((key, value) => MapEntry(key, value.length));

      _returnValue['loginCountByDay'] = loginCountSummary;
      _returnValue['loginDocsByDay'] = loginCountByDay;

      // geriBildirim document
      DocumentSnapshot feedbackDoc = await FirebaseFirestore.instance
          .collection("System")
          .doc('geriBildirim')
          .get();

      if (feedbackDoc.exists) {
        var feedbackData = feedbackDoc.data() as Map<String, dynamic>?;

        if (feedbackData != null && feedbackData.containsKey('makale')) {
          List<dynamic> feedBackNotes = feedbackData['note'];

          for (var feedBackNote in feedBackNotes) {
            _returnValue['feedBackNotes'].add(feedBackNote);
          }

          List<dynamic> articles = feedbackData['makale'];

          Map<String, int> likedArticles = {};
          Map<String, int> dislikedArticles = {};

          for (var article in articles) {
            if (article.containsKey('makaleBaslik') &&
                article.containsKey('durum')) {
              String title = article['makaleBaslik'];
              String status = article['durum'];

              if (status == 'Beğendi') {
                if (!likedArticles.containsKey(title)) {
                  likedArticles[title] = 0;
                }
                likedArticles[title] = likedArticles[title]! + 1;
              } else if (status == 'Beğenmedi') {
                if (!dislikedArticles.containsKey(title)) {
                  dislikedArticles[title] = 0;
                }
                dislikedArticles[title] = dislikedArticles[title]! + 1;
              }
            }
          }

          _returnValue['likedArticles'] = likedArticles;
          _returnValue['dislikedArticles'] = dislikedArticles;
        }
      }

      return _returnValue;
    } catch (e) {
      // Firestore'dan veri çekme sırasında bir hata oluştu
      print('Firestore veri çekme hatası: $e');
      return _returnValue;
    }
  }

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

  static Future<Map<String, dynamic>?> getSystemData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("System")
            .doc('Configs')
            .get();
        // print("Email: " + userSnapshot['email']);
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

  static Future<void> bildirimEkleme(
      _kategori, _id, _isim, _zaman, _language) async {
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
            _isim.toString().split("%%")[1],
            _language);
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
            .update({"notlar": _tempList});

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

  static Future<void> sonAdetTarihiGuncelle(lastPeriodDate) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({
          "sonAdetTarihi": lastPeriodDate

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

  static Future<Map> verileriTemizleveCik() async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .delete()
          .whenComplete(() {
        returnCode['status'] = true;
      });
    } on FirebaseAuthException catch (e) {
      returnCode['status'] = false;
      returnCode['value'] = e.code;
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return returnCode;
  }

  static Future<void> deleteKiloDataRecord(
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
          "dataRecord.$_type": FieldValue.arrayRemove(_tempList)

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

        print('Kilo verisi başarıyla silindi');
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

  static Future<void> tokenSayiGuncelle(tokenCount) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userID = user.uid;

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .update({"myToken": tokenCount}).whenComplete(() {
        print("token sayısı güncellendi $tokenCount ");
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

  static Future<void> addNewStory(
      _storyBaslikController,
      _makaleBaslikController,
      _makaleIcerikController,
      _storyLinkController,
      _selectedKategori,
      _isPremium,
      _tarih) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userID = user.uid;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("System")
          .doc('Configs')
          .get();
      var _storyler = userSnapshot['Stories'];
      int maxID = 0;
      for (var story in _storyler) {
        if (story['id'] > maxID) {
          maxID = story['id'];
        }
      }
      // print(maxID + 1);
      List _tempList = [];
      Map _tempMap = {};
      _tempMap['header'] = _storyBaslikController;
      _tempMap['baslik'] = _makaleBaslikController;
      _tempMap['icerik'] = _makaleIcerikController;
      _tempMap['id'] = maxID + 1;
      _tempMap['imageLink'] = _storyLinkController;
      _tempMap['premium'] = _isPremium;
      _tempMap['tarih'] = _tarih;

      print(_tempMap);
      _tempList.add(_tempMap);
      await FirebaseFirestore.instance
          .collection("System")
          .doc('Configs')
          .update({"Stories": FieldValue.arrayUnion(_tempList)});
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<Map> makaleGeriBildirim(
      userName, durum, tarih, makaleBaslik) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;
      List _tempList = [];
      Map _tempMap = {};
      _tempMap['userID'] = userID;
      _tempMap['tarih'] = tarih;
      _tempMap['durum'] = durum;
      _tempMap['makaleBaslik'] = makaleBaslik;

      _tempList.add(_tempMap);
      try {
        await FirebaseFirestore.instance
            .collection("System")
            .doc('geriBildirim')
            .update({"makale": FieldValue.arrayUnion(_tempList)}).whenComplete(
                () {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> fcmTokenGuncelle(
    String token,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"fcmToken": token}).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> languageGuncelle(
    String _language,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"language": _language}).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> versionGuncelle(
    String _version,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"appVersion": _version}).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> osGuncelle(
    String _deviceOS,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"deviceOS": _deviceOS}).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> loginDaysGuncelle(
    String formattedDate,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      List _tempList = [];

      _tempList.add(formattedDate);
      try {
        await FirebaseFirestore.instance.collection("Users").doc(userID).update(
            {"loginDays": FieldValue.arrayUnion(_tempList)}).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> abonelikGenelDurumGuncelle(
    String abonelikGenelDurum,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({
          "userSubscription": abonelikGenelDurum,
        }).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> abonelikGuncelle(
    Map abonelikDurum,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({
          "abonelik": abonelikDurum,
        }).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> makaleGeriBildirimHaftalik(
      userName, durum, tarih, makaleBaslik) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;
      List _tempList = [];
      Map _tempMap = {};
      _tempMap['userID'] = userID;
      _tempMap['tarih'] = tarih;
      _tempMap['durum'] = durum;
      _tempMap['makaleBaslik'] = makaleBaslik;

      _tempList.add(_tempMap);
      try {
        await FirebaseFirestore.instance
            .collection("System")
            .doc('geriBildirim')
            .update({
          "makaleHaftalik": FieldValue.arrayUnion(_tempList)
        }).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> sendFeedBack(userName, star, feedBackNote, tarih) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      List _tempList = [];
      Map _tempMap = {};
      _tempMap['userName'] = userName;
      _tempMap['userID'] = user.uid;

      _tempMap['tarih'] = tarih;
      _tempMap['star'] = star;
      _tempMap['feedBackNote'] = feedBackNote;
      _tempList.add(_tempMap);
      try {
        await FirebaseFirestore.instance
            .collection("System")
            .doc('geriBildirim')
            .update({"note": FieldValue.arrayUnion(_tempList)}).whenComplete(
                () {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<Map> suBildirimTakipSistemiOlustur(int suHedefi,
      bool waterSummary, bool waterReminder, List waterReminderTimes) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      String userID = user.uid;

      Map _tempMap = {};
      _tempMap['suHedefi'] = suHedefi;
      _tempMap['waterSummary'] = waterSummary;
      _tempMap['waterReminder'] = waterReminder;

      List<String> stringTimes = waterReminderTimes.map((time) {
        final hour = time.hour.toString().padLeft(
            2, '0'); // Saat değerini iki haneli olacak şekilde formatlar
        final minute = time.minute.toString().padLeft(
            2, '0'); // Dakika değerini iki haneli olacak şekilde formatlar
        return '$hour:$minute';
      }).toList();
      _tempMap['waterReminderTimes'] = stringTimes;
      print(_tempMap);
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"suBildirimTakipSistemi": _tempMap}).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
  }

  static Future<void> haftalikBildirimleriEkle(
      List _haftalikBildirimListe) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"bildirimler.boyut": _haftalikBildirimListe});

        print('Veri başarıyla güncellendi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> aiBotContent(String content1, String content2) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);
        List _tempList = [];
        Map _tempMap = {};
        _tempMap['user'] = content1;
        _tempMap['ai'] = content2;
        _tempMap['date'] = DateTime.now();

        _tempList.add(_tempMap);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"aiBotLog": FieldValue.arrayUnion(_tempList)});

        print('Veri başarıyla güncellendi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<void> aiBotContentClear() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        String userID = user.uid;
        print("UserID: " + userID);

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .update({"aiBotLog": []});

        print('AI Bot verileri başarıyla silindi.');
      } catch (e) {
        // Firestore'a veri güncelleme sırasında bir hata oluştu
        print('Firestore veri güncelleme hatası: $e');
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
  }

  static Future<Map> reklamLogu(_icerik, tarih) async {
    User? user = FirebaseAuth.instance.currentUser;
    Map returnCode = {};
    if (user != null) {
      List _tempList = [];
      Map _tempMap = {};
      _tempMap['icerik'] = _icerik;
      _tempMap['userID'] = user.uid;

      _tempMap['tarih'] = tarih;

      _tempList.add(_tempMap);
      try {
        await FirebaseFirestore.instance
            .collection("System")
            .doc('geriBildirim')
            .update({
          "reklamLog": FieldValue.arrayUnion(_tempList)
        }).whenComplete(() {
          returnCode['status'] = true;
        });
      } on FirebaseAuthException catch (e) {
        returnCode['status'] = false;
        returnCode['value'] = e.code;
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    } else {
      print('Kullanıcı giriş yapmamış.');
    }
    return returnCode;
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
