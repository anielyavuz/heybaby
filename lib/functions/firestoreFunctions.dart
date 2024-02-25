import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}
