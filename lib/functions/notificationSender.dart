import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationSetup {
  static void scheduleWeeklyNotification(int currentWeek) async {
    for (int i = currentWeek + 1; i <= 40; i++) {
      DateTime nextMonday = _getNextMonday();
      nextMonday = nextMonday.add(Duration(days: (i - currentWeek - 1) * 7));

      // Saati 10:00 olarak ayarlayalım
      nextMonday =
          DateTime(nextMonday.year, nextMonday.month, nextMonday.day, 10, 0, 0);
      print(
          'Bildirim $i tarihinde saat ${nextMonday.hour}:${nextMonday.minute} olarak ayarlandı.');

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: "basic_channel",
          title: "Merhaba Annecim",
          body: "Bu hafta $i. boyutunda olacağım. Tıklayıp resmime bak ☺️",
        ),
        schedule: NotificationCalendar(
          timeZone: 'Turkey/Istanbul',
          day: nextMonday.day,
          month: nextMonday.month,
          year: nextMonday.year,
          hour: nextMonday.hour,
          minute: nextMonday.minute,
          second: nextMonday.second,
        ),
      );
    }
  }

  static DateTime _getNextMonday() {
    DateTime today = DateTime.now();
    int daysUntilNextMonday = DateTime.monday - today.weekday;
    if (daysUntilNextMonday <= 0) {
      daysUntilNextMonday += 7;
    }
    return today.add(Duration(days: daysUntilNextMonday));
  }
}
