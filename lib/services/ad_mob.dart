import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();

  factory AdMobService() => _instance;

  AdMobService._internal();

  InterstitialAd? _interstitialAd;

  DateTime? _lastShownTime;

  final Duration cooldownDuration = const Duration(minutes: 10);

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

  void showInterstitialAdIfAllowed() {
    final now = DateTime.now();

    if (_lastShownTime == null ||
        now.difference(_lastShownTime!) >= cooldownDuration) {
      _showInterstitialAd();
      _lastShownTime = now;
    }
  }

  void _showInterstitialAd() {
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
