import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

class BildirimTakip {
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
      int _month, int _year, String _tok) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _id,
        channelKey: "basic_channel",
        title: "İlaç Hatırlatması",
        body: "$_ilacAdi ilacını içme vakti. ($_tok)",
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
  ) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // print(
    //     "AAA  $_id - $meyve - $_firebaseLink, $_minute :$_hour $_day $_month $_year");
    await AwesomeNotifications()
        .createNotification(
      content: NotificationContent(
          id: _id,
          channelKey: "basic_channel",
          title: "Merhaba Annecim",
          body: "Bu hafta bir $meyve boyutundayım. Tıklayıp resmime bak ☺️",
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

  static Future<void> gunlukSuIc(
    int _id,
    int _hour,
    int _minute,
    int _day,
    int _month,
    int _year,
  ) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // print(
    //     "AAA  $_id - $meyve - $_firebaseLink, $_minute :$_hour $_day $_month $_year");
    await AwesomeNotifications()
        .createNotification(
      content: NotificationContent(
        id: _id,
        channelKey: "basic_channel",
        title: "Su içme vakti. 🐳",
        body:
            "Bugünkü su hedefini doldurmamış görünüyorsun, hadi bir bardak su iç ve listene kaydet.😊",
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
      print(
          "$_id için tanım yapıldı detaylar:  $_hour:$_minute $_day.$_month.$_year");
      // var t = await AwesomeNotifications().listScheduledNotifications();
      // print(t.length);
    });
    // for (var _bildirim in t) {
    //   print(_bildirim.content!.id);
    //   print(_bildirim.content!.body);
    // }
  }
}
