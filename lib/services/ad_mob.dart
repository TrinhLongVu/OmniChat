import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  // Singleton setup
  static final AdMobService _instance = AdMobService._internal();

  factory AdMobService() => _instance;

  AdMobService._internal();

  InterstitialAd? _interstitialAd;

  // Get platform-specific interstitial ad unit ID
  static String? get interstitialAdUnitId {
    if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    }
    return null;
  }

  void initialize() {
    MobileAds.instance.initialize();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    final adUnitId = interstitialAdUnitId;
    if (adUnitId == null) {
      return;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd(); // preload next ad
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd(); // preload next ad
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null; // prevent reuse
    } else {
      _createInterstitialAd();
    }
  }
}
