import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email'],
  //   hostedDomain: '',
  // );
  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;

  Future<Map> anonymSignIn(bool _isPregnant, DateTime _tarih) async {
    Map returnCode = {};
    try {
      var user = await _auth.signInAnonymously();
      var _finalData;
      if (_isPregnant) {
        _finalData = {
          "userName": "Guest",
          "email": "",
          "photoUrl": "",
          "dataRecord": {},
          "registerType": "Anonym",
          "dogumOnceSonra": "Once",
          "isPregnant": true,
          "sonAdetTarihi": DateFormat('yyyy-MM-dd').format(_tarih),
          "bebekDogumTarihi": DateFormat('yyyy-MM-dd').format(_tarih),
          "id": user.user!.uid,
          "bildirimler": {
            "ilac": {'100000': "Dvit"},
            "boyut": {},
            "gunluk": {},
            "su": {},
            "takvim": {},
            "genel": {},
          },
          "userAuth": "Prod",
          "userSubscription": "Free",
          "createTime": DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
        };
      } else {
        _finalData = {
          "userName": "Guest",
          "email": "",
          "photoUrl": "",
          "dataRecord": {},
          "registerType": "Anonym",
          "dogumOnceSonra": "Sonra",
          "isPregnant": false,
          "sonAdetTarihi": DateFormat('yyyy-MM-dd').format(_tarih),
          "bebekDogumTarihi": DateFormat('yyyy-MM-dd').format(_tarih),
          "id": user.user!.uid,
          "bildirimler": {
            "ilac": {'100000': "Dvit"},
            "boyut": {},
            "gunluk": {},
            "su": {},
            "takvim": {},
            "genel": {},
          },
          "userAuth": "Prod",
          "userSubscription": "Free",
          "createTime": DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
        };
      }

      await _firestore.collection("Users").doc(user.user!.uid).set(_finalData);
    } on FirebaseAuthException catch (e) {
      returnCode['status'] = false;
      returnCode['value'] = e.code;
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return returnCode;
  }

  Future<Map> signIn(String email, String password) async {
    Map returnCode = {};
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      returnCode['status'] = true;
      returnCode['value'] = user.user;
      // print(returnCode);
      return returnCode;
    } on FirebaseAuthException catch (e) {
      returnCode['status'] = false;
      returnCode['value'] = e.code;
      // print('Failed with error code: ${e.code}');
      print(e.message);
      return returnCode;
    }
  }

  Future<Map> createPerson(
    String _currentID,
    String email,
    String password,
    bool _isPregnant,
    String _tarih,
    String userName,
    Map _bildirimler,
    String _dogumOnceSonra,
    String _createTime,
    Map _dataRecord,
  ) async {
    Map returnCode = {};
    try {
      await _auth.signOut();

      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (_isPregnant) {
        await _firestore.collection("Users").doc(user.user?.uid).set({
          'id': user.user?.uid,
          'email': email,
          "userName": userName,
          "photoUrl": "",
          "bildirimler": {
            "ilac": {'100000': "Dvit"},
            "boyut": {},
            "gunluk": {},
            "su": {},
            "takvim": {},
            "genel": {},
          },
          "registerType": "Authenticated",
          "dogumOnceSonra": "Once",
          "isPregnant": true,
          "dataRecord": {},
          "sonAdetTarihi": _tarih,
          "bebekDogumTarihi": _tarih,
          "userAuth": "Prod",
          "userSubscription": "Free",
          "createTime": DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
        }).whenComplete(() async {});
      } else {
        await _firestore.collection("Users").doc(user.user?.uid).set({
          'id': user.user?.uid,
          'email': email,
          "userName": userName,
          "photoUrl": "",
          "bildirimler": {
            "ilac": {'100000': "Dvit"},
            "boyut": {},
            "gunluk": {},
            "su": {},
            "takvim": {},
            "genel": {},
          },
          "dataRecord": {},
          "registerType": "Authenticated",
          "dogumOnceSonra": "Sonra",
          "isPregnant": false,
          "sonAdetTarihi": _tarih,
          "bebekDogumTarihi": _tarih,
          "userAuth": "Prod",
          "userSubscription": "Free",
          "createTime": DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString(),
        }).whenComplete(() async {});
      }
      returnCode['status'] = true;
      returnCode['value'] = user.user;

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(_currentID)
            .delete();
        print("$_currentID User deleted successfully");
      } catch (e) {
        print("Error deleting user: $e");
      }

      return returnCode;
    } on FirebaseAuthException catch (e) {
      returnCode['status'] = false;
      returnCode['value'] = e.code;
      print('Failed with error code: ${e.code}');
      print(e.message);
      return returnCode;
    }

    // var user = await _auth.createUserWithEmailAndPassword(
    //     email: email, password: password);

    // await _firestore
    //     .collection("Person")
    //     .doc(user.user.uid)
    //     .set({'userName': name, 'email': email});

    // return user.user;
  }

  // Future appleLoginFromMainPage() async {
  //   // 1. perform the sign-in request
  //   final result = await TheAppleSignIn.performRequests([
  //     AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   ]);
  //   print(result.error);
  //   // 2. check the result
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential!;
  //       final oAuthProvider = OAuthProvider('apple.com');
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken!),
  //         accessToken:
  //             String.fromCharCodes(appleIdCredential.authorizationCode!),
  //       );

  //       final newUser = await _auth.signInWithCredential(credential);
  //       final firebaseUser = newUser.user!;
  //       print("AAAAAAAAAAAAA11");
  //       // print(newUser.user!.uid);
  //       print(newUser.user);

  //       await _firestore.collection("Users").doc(newUser.user!.uid).set({
  //         "userName": newUser.user!.displayName != null
  //             ? newUser.user!.displayName
  //             : "KiWi User",
  //         "email": newUser.user!.email != null ? newUser.user!.email : "",
  //         "photoUrl": newUser.user!.photoURL != null
  //             ? newUser.user!.photoURL
  //             : "https://firebasestorage.googleapis.com/v0/b/kiwihabitapp-5f514.appspot.com/o/kiwiLogo.png?alt=media&token=90320926-0ff1-4fc8-a3eb-62c9d85e0ef0",
  //         "registerType": "Apple",
  //         "id": newUser.user!.uid,
  //         "userAuth": "Prod",
  //         "userSubscription": "Free",
  //       }).then((value) async {
  //         //silemedik çünkü user log out oldu ve yetkisi gitti...
  //         // var k = await FirebaseFirestore.instance
  //         //     .collection("Users")
  //         //     .doc(anonymData['id'])
  //         //     .delete();
  //       });
  //     // if (!doesGoogleUserExist(newUser.user!.uid)) {
  //     //   await _firestore.collection("Users").doc(newUser.user!.uid).set(anonymData);
  //     // }
  //     case AuthorizationStatus.cancelled:
  //     // TODO: Handle this case.
  //     case AuthorizationStatus.error:
  //     // TODO: Handle this case.
  //   }
  // }

  // googleLoginFromMainPage() async {
  //   await _auth.signOut();
  //   final googleUser = await _googleSignIn.signIn();

  //   if (googleUser == null) return;
  //   _user = googleUser;
  //   final googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   var newUser = await FirebaseAuth.instance.signInWithCredential(credential);
  //   print("newUser --- $newUser");
  //   await _firestore.collection("Users").doc(newUser.user!.uid).set({
  //     "userName": googleUser.displayName,
  //     "email": googleUser.email,
  //     "photoUrl": googleUser.photoUrl,
  //     "registerType": "Google",
  //     "id": newUser.user!.uid,
  //     "userAuth": "Prod",
  //     "userSubscription": "Free",
  //   }).then((value) async {
  //     //silemedik çünkü user log out oldu ve yetkisi gitti...
  //     // var k = await FirebaseFirestore.instance
  //     //     .collection("Users")
  //     //     .doc(anonymData['id'])
  //     //     .delete();
  //   });
  //   // if (!doesGoogleUserExist(newUser.user!.uid)) {
  //   //   await _firestore.collection("Users").doc(newUser.user!.uid).set(anonymData);
  //   // }
  // }

  signOut() async {
    return await _auth.signOut();
  }
}
