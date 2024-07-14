import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BildirimTakip {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> fcmBildirimGonder(String title, String body) async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      // Burada kendi backend sunucunuzdan veya Firebase Cloud Functions kullanarak FCM mesajını gönderin
      // Örnek POST isteği:
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=YOUR_SERVER_KEY',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'to': token,
          },
        ),
      );
      if (response.statusCode == 200) {
        print('FCM bildirimi başarıyla gönderildi.');
      } else {
        print('FCM bildirimi gönderilemedi: ${response.body}');
      }
    }
  }

  bildirimKur() async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: "basic_channel",
          title: "Merhaba Annecim",
          body: "Bu hafta A. boyutunda olacağım. Tıklayıp resmime bak ☺️",
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture:
              'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/childImages%2Fbezelye_image_week6_low.jpg?alt=media&token=9a729c15-6f59-498d-840e-ffc25229469c'),
      schedule: NotificationCalendar(
        timeZone: utcTimeZone,
        day: 13,
        month: 05,
        year: 2024,
        hour: 22,
        minute: 37,
        second: 59,
      ),
    );
    var t = await AwesomeNotifications().listScheduledNotifications();
    print(t.toList().length);
  }

  ilacBildirim(int _id, String _ilacAdi, int _hour, int _minute, int _day,
      int _month, int _year, String _tok, String _language) async {
    String _header = "";
    String _body = "";
    if (_language == "Türkçe") {
      _header = "İlaç Hatırlatması🔔";
      _body = "$_ilacAdi ilacını içme vakti. ($_tok)";
    } else {
      _header = "Medicine Reminder🔔";
      _body = "Time to get $_ilacAdi";
    }
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _id,
        channelKey: "basic_channel",
        title: _header,
        body: _body,
        wakeUpScreen: true,
        // notificationLayout:
        //     NotificationLayout.BigPicture,
        // bigPicture:
        //     'https://firebasestorage.googleapis.com/v0/b/heybaby-d341f.appspot.com/o/childImages%2Fbezelye_image_week6_low.jpg?alt=media&token=9a729c15-6f59-498d-840e-ffc25229469c'
      ),
      schedule: NotificationCalendar(
        timeZone: utcTimeZone,
        day: _day,
        month: _month,
        year: _year,
        hour: _hour,
        minute: _minute,
        second: 00,
      ),
    );
    var t = await AwesomeNotifications().listScheduledNotifications();
    print(t.toList().length);
  }

  static Future<void> haftalikBoyutBilgisi(
      int _id,
      String meyve,
      String _firebaseLink,
      int _hour,
      int _minute,
      int _day,
      int _month,
      int _year,
      String _language) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String _header = "";
    String _body = "";
    if (_language == "Türkçe") {
      _header = "Merhaba Annecim";
      _body =
          "Bu hafta bir $meyve boyutundayım. Resmime bakıp haftalık ipuçlarını okumak için tıkla ☺️";
    } else {
      _header = "Hello Mommy";
      _body =
          "This week I am the size of a $meyve. Click to see my picture and read the weekly tips ☺️";
    }
    // print(
    //     "AAA  $_id - $meyve - $_firebaseLink, $_minute :$_hour $_day $_month $_year");
    await AwesomeNotifications()
        .createNotification(
      content: NotificationContent(
          id: _id,
          channelKey: "basic_channel",
          title: _header,
          body: _body,
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: _firebaseLink),
      schedule: NotificationCalendar(
        timeZone: utcTimeZone,
        day: _day,
        month: _month,
        year: _year,
        hour: _hour,
        minute: _minute,
        second: 00,
      ),
    )
        .whenComplete(() async {
      print(
          "$_id için tanım yapıldı detaylar: $meyve $_hour:$_minute $_day.$_month.$_year");
      // var t = await AwesomeNotifications().listScheduledNotifications();
      // print(t.length);
    });
    // for (var _bildirim in t) {
    //   print(_bildirim.content!.id);
    //   print(_bildirim.content!.body);
    // }
  }

  static Future<void> gunlukSuIc(int _id, int _hour, int _minute, int _day,
      int _month, int _year, String _language) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    String _header = "";
    String _body = "";
    if (_language == "Türkçe") {
      _header = "Günlük Su Özetin Annecim 🐳";
      _body =
          "Bugünkü su hedefini doldurmamış görünüyorsun annecim. 🥲 Hadi biraz su iç ve listene kaydet.😊";
    } else {
      _header = "Daily Water Summary Mommy 🐳";
      _body =
          "You don't seem to have met your water goal for today, mom. 🥲 Come on, drink some water and save it to your list 😊";
    }

    // print(
    //     "AAA  $_id - $meyve - $_firebaseLink, $_minute :$_hour $_day $_month $_year");
    await AwesomeNotifications()
        .createNotification(
      content: NotificationContent(
        id: _id,
        channelKey: "basic_channel",
        title: _header,
        body: _body,
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        timeZone: utcTimeZone,
        day: _day,
        month: _month,
        year: _year,
        hour: _hour,
        minute: _minute,
        second: 00,
      ),
    )
        .whenComplete(() async {
      // print(
      //     "$_id için tanım yapıldı detaylar:  $_hour:$_minute $_day.$_month.$_year");
      // var t = await AwesomeNotifications().listScheduledNotifications();
      // print(t.length);
    });
    // for (var _bildirim in t) {
    //   print(_bildirim.content!.id);
    //   print(_bildirim.content!.body);
    // }
  }

  static Future<void> gunIciSuHatirlatici(int _id, int _hour, int _minute,
      int _day, int _month, int _year, String _language) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // print(
    //     "AAA  $_id - $meyve - $_firebaseLink, $_minute :$_hour $_day $_month $_year");

    String _header = "";
    String _body = "";
    if (_language == "Türkçe") {
      _header = "Su İçme Vakti Annecim 🐳";
      _body =
          "Ben biraz susadım da... 😇 Hadi bir bardak su iç ve listene kaydet. 🥤";
    } else {
      _header = "Time to drink water, Mommy 🐳";
      _body =
          "I'm a little thirsty... 😇 Drink a glass of water and put it on your list. 🥤";
    }

    try {
      await AwesomeNotifications()
          .createNotification(
        content: NotificationContent(
            id: _id,
            channelKey: "basic_channel",
            title: _header,
            body: _body,
            wakeUpScreen: true,
            payload: {'page': 'suTakip'}),
        schedule: NotificationCalendar(
          timeZone: utcTimeZone,
          // day: _day,
          // month: _month,
          // year: _year,
          hour: _hour,
          minute: _minute,
          second: 00,
          repeats: true,
        ),
      )
          .whenComplete(() async {
        print(
            "$_id için tanım yapıldı detaylar:  $_hour:$_minute $_day.$_month.$_year");
        // var t = await AwesomeNotifications().listScheduledNotifications();
        // print(t.length);
      });
    } catch (e) {
      print("Bir hata oluştu: $e");
    }

    // for (var _bildirim in t) {
    //   print(_bildirim.content!.id);
    //   print(_bildirim.content!.body);
    // }
  }

  static Future<void> gunlukSuIcYeni(int _hour, int _minute, int _day,
      int _month, int _year, String _language) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // print(
    //     "AAA  $_id - $meyve - $_firebaseLink, $_minute :$_hour $_day $_month $_year");
    String _header = "";
    String _body = "";
    if (_language == "Türkçe") {
      _header = "Günlük Su Özetin🐳";
      _body =
          "Bugünkü su hedefini doldurmamış görünüyorsun annecim. 🥲 Hadi biraz su iç ve listene kaydet.😊";
    } else {
      _header = "Your Daily Water Summary🐳";
      _body =
          "You don't seem to have met your water goal for today, mom. 🥲 Come on, drink some water and save it to your list 😊";
    }

    try {
      await AwesomeNotifications()
          .createNotification(
        content: NotificationContent(
            id: 3,
            channelKey: "basic_channel",
            title: _header,
            body: _body,
            wakeUpScreen: true,
            payload: {'page': 'suTakip'}),
        schedule: NotificationCalendar(
          timeZone: utcTimeZone,
          day: _day,
          month: _month,
          year: _year,
          hour: _hour,
          minute: _minute,
          second: 00,
          repeats: true,
        ),
      )
          .whenComplete(() async {
        print("yeni su için tanım yapıldı detaylar:  ");
        // var t = await AwesomeNotifications().listScheduledNotifications();
        // print(t.length);
      });
    } catch (e) {
      print("Bir hata oluştu: $e");
    }

    // for (var _bildirim in t) {
    //   print(_bildirim.content!.id);
    //   print(_bildirim.content!.body);
    // }
  }

  static Future<void> aktiviteAlarm(int _id, int _hour, int _minute, int _day,
      int _month, int _year, String _aktivite, String _language) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // print(
    //     "AAA  $_id - $meyve - $_firebaseLink, $_minute :$_hour $_day $_month $_year");

    String _header = "";
    String _body = "";
    if (_language == "Türkçe") {
      _header = "Aktivite Vakti 🗓️";
      _body = "$_aktivite aktivitesi için planladığın zaman geldi. 😇";
    } else {
      _header = "Activity Time 🗓️";
      _body = "It's time for your planned $_aktivite activity. 😇";
    }

    try {
      await AwesomeNotifications()
          .createNotification(
        content: NotificationContent(
            id: _id,
            channelKey: "basic_channel",
            title: _header,
            body: _body,
            wakeUpScreen: true,
            payload: {'page': 'suTakip'}),
        schedule: NotificationCalendar(
          timeZone: utcTimeZone,
          day: _day,
          month: _month,
          year: _year,
          hour: _hour,
          minute: _minute,
          second: 00,
        ),
      )
          .whenComplete(() async {
        print(
            "$_id için tanım yapıldı detaylar:  $_hour:$_minute $_day.$_month.$_year");
        // var t = await AwesomeNotifications().listScheduledNotifications();
        // print(t.length);
      });
    } catch (e) {
      print("Bir hata oluştu: $e");
    }

    // for (var _bildirim in t) {
    //   print(_bildirim.content!.id);
    //   print(_bildirim.content!.body);
    // }
  }
}
