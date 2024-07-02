import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7873015234955456/1391119358";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7873015234955456/7256655718";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7873015234955456/1391119358";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7873015234955456/7256655718";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
