import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mazar/common/providers/cart_provider.dart';
import 'package:mazar/common/providers/language_provider.dart';
import 'package:mazar/common/providers/localization_provider.dart';
import 'package:mazar/common/providers/news_letter_provider.dart';
import 'package:mazar/common/providers/product_provider.dart';
import 'package:mazar/common/providers/theme_provider.dart';
import 'package:mazar/common/widgets/third_party_chat_widget.dart';
import 'package:mazar/features/address/providers/location_provider.dart';
import 'package:mazar/features/auth/providers/auth_provider.dart';
import 'package:mazar/features/auth/providers/verification_provider.dart';
import 'package:mazar/features/category/providers/category_provider.dart';
import 'package:mazar/features/chat/providers/chat_provider.dart';
import 'package:mazar/features/coupon/providers/coupon_provider.dart';
import 'package:mazar/features/home/providers/banner_provider.dart';
import 'package:mazar/features/home/providers/flash_deal_provider.dart';
import 'package:mazar/features/notification/providers/notification_provider.dart';
import 'package:mazar/features/onboarding/providers/onboarding_provider.dart';
import 'package:mazar/features/order/providers/image_note_provider.dart';
import 'package:mazar/features/order/providers/order_provider.dart';
import 'package:mazar/features/profile/providers/profile_provider.dart';
import 'package:mazar/features/review/providers/review_provider.dart';
import 'package:mazar/features/search/providers/search_provider.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/features/wallet_and_loyalty/providers/wallet_provider.dart';
import 'package:mazar/features/wishlist/providers/wishlist_provider.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/helper/route_helper.dart';
import 'package:mazar/theme/dark_theme.dart';
import 'package:mazar/theme/light_theme.dart';
import 'package:mazar/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'common/widgets/cookies_widget.dart';
import 'di_container.dart' as di;
import 'localization/app_localization.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

AndroidNotificationChannel? channel;
Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  int? orderID;
  try {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('error---> ${e.toString()}');
    }
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NewsLetterProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<WalletAndLoyaltyProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashDealProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReviewProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<VerificationProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<OrderImageNoteProvider>()),
    ],
    child: MyApp(orderID: orderID, isWeb: !kIsWeb),
  ));
}

class MyApp extends StatefulWidget {
  final int? orderID;
  final bool isWeb;
  const MyApp({Key? key, required this.orderID, required this.isWeb})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouteHelper.setupRouter();

    if (kIsWeb) {
      Provider.of<SplashProvider>(context, listen: false).initSharedData();
      Provider.of<CartProvider>(context, listen: false).getCartData();
      _route();
    }
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig()
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: ResponsiveHelper.isMobilePhone() ? 1 : 0),
            () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false).updateToken();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return (kIsWeb && splashProvider.configModel == null)
            ? const SizedBox()
            : MaterialApp(
                title: splashProvider.configModel != null
                    ? splashProvider.configModel!.ecommerceName ?? ''
                    : AppConstants.appName,
                initialRoute: ResponsiveHelper.isMobilePhone()
                    ? widget.orderID == null
                        ? RouteHelper.splash
                        : RouteHelper.getOrderDetailsRoute('${widget.orderID}')
                    : splashProvider.configModel!.maintenanceMode!
                        ? RouteHelper.getMaintenanceRoute()
                        : RouteHelper.menu,
                onGenerateRoute: RouteHelper.router.generator,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                theme: Provider.of<ThemeProvider>(context).darkTheme
                    ? dark
                    : light,
                // locale: Provider.of<LocalizationProvider>(context).locale,
                locale: const Locale('ar', 'SA'),
                localizationsDelegates: const [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('ar', 'SA'),
                  // Locale('en', 'US'),
                ],
                // supportedLocales: locals,
                scrollBehavior:
                    const MaterialScrollBehavior().copyWith(dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                }),
                builder: (context, widget) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                      textScaler:
                          TextScaler.linear(size.width < 380 ? 0.8 : 1)),
                  child: Material(
                      child: Stack(children: [
                    widget!,
                    if (ResponsiveHelper.isDesktop(context))
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 20),
                              child: ThirdPartyChatWidget(
                                  configModel: splashProvider.configModel!),
                            )),
                      ),
                    if (kIsWeb &&
                        splashProvider.configModel!.cookiesManagement != null &&
                        splashProvider
                            .configModel!.cookiesManagement!.status! &&
                        !splashProvider.getAcceptCookiesStatus(splashProvider
                            .configModel!.cookiesManagement!.content) &&
                        splashProvider.cookiesShow)
                      const Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: CookiesWidget()),
                      ),
                  ])),
                ),
              );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
