import 'dart:io';

import 'package:heybaby/pages/subpages/makaleDetay.dart';

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
import 'package:heybaby/pages/subpages/kesfetMakale.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart'; // RevenueCat paketini ekleyin
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart'; // RevenueCat UI paketini ekleyin
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
        channelDescription: "Basic notification channel")
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
  FirebaseMessaging.onMessageOpenedApp
      .listen(_firebaseMessagingOpenedAppHandler);
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

  // await _configureSDK();
}

Future<void> _configureSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);

  PurchasesConfiguration? configuration;

  if (Platform.isAndroid) {
    // configure for Google play store
  } else if (Platform.isIOS) {
    configuration = PurchasesConfiguration("appl_vFGFjyUkszfdkFPjiszIoVgsvVG");
  }

  if (configuration != null) {
    await Purchases.configure(configuration);
  } else {
    print("Ödeme configuration null");
  }
}

Future<void> _paymentUI() async {
  final paywallResult = await RevenueCatUI.presentPaywallIfNeeded("premium");
  print('Paywall result: $paywallResult');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data['screen'] == 'makaleDetay') {
    bool _isMakalePremium = false;
    bool _isUserPremium = false;
    if (message.data['isMakalePremium'] == 'Premium') {
      _isMakalePremium = true;
    }
    if (message.data['isUserPremium'] == 'Premium') {
      _isUserPremium = true;
    }

    navigatorKey.currentState?.pushNamed(
      '/makaleDetay',
      arguments: {
        'baslik': message.data['baslik'],
        'icerik': message.data['icerik'],
        'resimURL': message.data['resimURL'],
        'isMakalePremium': _isMakalePremium,
        'isUserPremium': _isUserPremium,
      },
    );
  }
  // Bu fonksiyon arka planda gelen mesajları işler
}

void _firebaseMessagingOpenedAppHandler(RemoteMessage message) {
  // Bildirime tıklandığında yapılacak işlemler

  // Örneğin, yönlendirme için mesaj verisini kullanabilirsiniz
  if (message.data['screen'] == 'makaleDetay') {
    bool _isMakalePremium = false;
    bool _isUserPremium = false;
    if (message.data['isMakalePremium'] == 'Premium') {
      _isMakalePremium = true;
    }
    if (message.data['isUserPremium'] == 'Premium') {
      _isUserPremium = true;
    }
    // MyApp'in context'ine erişmek için bir GlobalKey kullanmalısınız
    navigatorKey.currentState?.pushNamed(
      '/makaleDetay',
      arguments: {
        'baslik': message.data['baslik'],
        'icerik': message.data['icerik'],
        'resimURL': message.data['resimURL'],
        'isMakalePremium': _isMakalePremium,
        'isUserPremium': _isUserPremium,
      },
    );
  }

  print(message.data);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
            navigatorKey: navigatorKey, // GlobalKey'i burada ekliyoruz
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
            onGenerateRoute: (settings) {
              if (settings.name == '/makaleDetay') {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) {
                    return MakaleDetay(
                      baslik: args['baslik'],
                      icerik: args['icerik'],
                      resimURL: args['resimURL'],
                      referansAktif: false,
                      referansList: [],
                      isMakalePremium: args['isMakalePremium'],
                      isUserPremium: args['isUserPremium'],
                    );
                  },
                );
              }
              // else if (settings.name == '/suTakip') {
              //   final args = settings.arguments as Map<String, dynamic>;
              //   return MaterialPageRoute(
              //     builder: (context) {
              //       return MakaleDetay(
              //         baslik: args['baslik'],
              //         icerik: args['icerik'],
              //         resimURL: args['resimURL'],
              //         referansAktif: false,
              //         referansList: [],

              //       );
              //     },
              //   );
              // }
              // Diğer yönlendirmeler
              return null;
            },
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
