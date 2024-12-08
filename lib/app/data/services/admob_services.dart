import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobServices {
  static String? get bannerAdUnitId {
    return 'ca-app-pub-1628403921081444/4330186030';
  }

  static String? get rewordAdUnitId {
    return 'ca-app-pub-1628403921081444/3058548533';
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint("Ad lOADED"),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint("failed to load : $error");
    },
    onAdOpened: (ad) => debugPrint("open"),
    onAdClicked: (ad) => debugPrint("close"),
  );
}
