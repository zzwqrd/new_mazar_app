import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mazar/common/providers/cart_provider.dart';
import 'package:mazar/features/auth/providers/auth_provider.dart';
import 'package:mazar/features/onboarding/screens/on_boarding_screen.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/helper/route_helper.dart';
import 'package:mazar/localization/app_localization.dart';
import 'package:mazar/utill/app_constants.dart';
import 'package:mazar/utill/images.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    _route();
  }

  void _route() {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    // Provider.of<SplashProvider>(context, listen: false).removeSharedData();
    splashProvider.initConfig().then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double minimumVersion = 0.0;
          if (Platform.isAndroid) {
            if (splashProvider.configModel?.playStoreConfig?.minVersion !=
                null) {
              minimumVersion =
                  splashProvider.configModel?.playStoreConfig?.minVersion ??
                      AppConstants.appVersion;
            }
          } else if (Platform.isIOS) {
            if (splashProvider.configModel?.appStoreConfig?.minVersion !=
                null) {
              minimumVersion =
                  splashProvider.configModel?.appStoreConfig?.minVersion ??
                      AppConstants.appVersion;
            }
          }
          if (AppConstants.appVersion < minimumVersion &&
              !ResponsiveHelper.isWeb()) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteHelper.getUpdateRoute(), (route) => false);
          } else {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(RouteHelper.menu, (route) => false);
            } else {
              if (Provider.of<SplashProvider>(context, listen: false)
                  .showIntro()) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteHelper.onBoarding, (route) => false,
                    arguments: OnBoardingScreen());
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteHelper.login, (route) => false);
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(Images.moreLogo, height: 130, width: 500),
          // const SizedBox(height: Dimensions.paddingSizeSmall),
          // Text(AppConstants.appName,
          //     textAlign: TextAlign.center,
          //     style: poppinsMedium.copyWith(
          //       color: Theme.of(context).primaryColor,
          //       fontSize: 30,
          //     )),
        ],
      ),
    );
  }
}
