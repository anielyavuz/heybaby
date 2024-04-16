import 'package:awesome_notifications/awesome_notifications.dart';

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
        day: 14,
        month: 04,
        year: 2024,
        hour: 11,
        minute: 29,
        second: 50,
      ),
    );
    var t = await AwesomeNotifications().listScheduledNotifications();
    print(t.toList().length);
  }

  ilacBildirim(int _id, String _ilacAdi, int _hour, int _minute, int _day,
      int _month, int _year) async {
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _id,
        channelKey: "basic_channel",
        title: "İlaç Hatırlatması",
        body: "$_ilacAdi ilacını içme vakti.",
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
}
