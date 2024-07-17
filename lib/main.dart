import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heybaby/firebase_options.dart';
import 'package:heybaby/functions/boxes.dart';
import 'package:heybaby/functions/person.dart';
import 'package:heybaby/l10n/l10n.dart';
import 'package:heybaby/pages/authentication.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('personBox');

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: "basic_channel",
        channelName: "Basic Notification",
        channelDescription: "Basic  notification channel")
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "basic_channel_group", channelGroupName: "Basic Group")
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  } else {
    // print("Bildirim yetkisi var");
  }

  // Telefonun varsayılan dilini al ve kontrol et
  Locale deviceLocale = ui.window.locale;
  Locale appLocale;
  if (deviceLocale.languageCode == 'tr') {
    appLocale = Locale('tr');
  } else {
    appLocale = Locale('en');
  }

  runApp(MyApp(appLocale: appLocale));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Bu fonksiyon arka planda gelen mesajları işler
}

class MyApp extends StatelessWidget {
  final Locale appLocale;

  const MyApp({super.key, required this.appLocale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleNotifier(appLocale),
      child: Consumer<LocaleNotifier>(
        builder: (context, localeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '',
            supportedLocales: L10n.all,
            locale: localeNotifier.currentLocale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 157, 107, 242)),
              useMaterial3: true,
            ),
            home: CheckAuth(),
          );
        },
      ),
    );
  }
}

class LocaleNotifier extends ChangeNotifier {
  Locale _currentLocale;

  LocaleNotifier(this._currentLocale);

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }
}
