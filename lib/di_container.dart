import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mazar/common/providers/cart_provider.dart';
import 'package:mazar/common/providers/language_provider.dart';
import 'package:mazar/common/providers/localization_provider.dart';
import 'package:mazar/common/providers/news_letter_provider.dart';
import 'package:mazar/common/providers/product_provider.dart';
import 'package:mazar/common/providers/theme_provider.dart';
import 'package:mazar/common/reposotories/cart_repo.dart';
import 'package:mazar/common/reposotories/language_repo.dart';
import 'package:mazar/common/reposotories/product_repo.dart';
import 'package:mazar/features/address/domain/reposotories/location_repo.dart';
import 'package:mazar/features/address/providers/location_provider.dart';
import 'package:mazar/features/auth/domain/reposotories/auth_repo.dart';
import 'package:mazar/features/auth/providers/auth_provider.dart';
import 'package:mazar/features/auth/providers/verification_provider.dart';
import 'package:mazar/features/category/domain/reposotories/category_repo.dart';
import 'package:mazar/features/category/providers/category_provider.dart';
import 'package:mazar/features/chat/domain/reposotories/chat_repo.dart';
import 'package:mazar/features/chat/providers/chat_provider.dart';
import 'package:mazar/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:mazar/features/coupon/providers/coupon_provider.dart';
import 'package:mazar/features/home/domain/reposotories/banner_repo.dart';
import 'package:mazar/features/home/providers/banner_provider.dart';
import 'package:mazar/features/home/providers/flash_deal_provider.dart';
import 'package:mazar/features/notification/domain/reposotories/notification_repo.dart';
import 'package:mazar/features/notification/providers/notification_provider.dart';
import 'package:mazar/features/onboarding/domain/reposotories/onboarding_repo.dart';
import 'package:mazar/features/onboarding/providers/onboarding_provider.dart';
import 'package:mazar/features/order/domain/reposotories/order_repo.dart';
import 'package:mazar/features/order/providers/image_note_provider.dart';
import 'package:mazar/features/order/providers/order_provider.dart';
import 'package:mazar/features/profile/domain/reposotories/profile_repo.dart';
import 'package:mazar/features/profile/providers/profile_provider.dart';
import 'package:mazar/features/review/providers/review_provider.dart';
import 'package:mazar/features/search/domain/reposotories/search_repo.dart';
import 'package:mazar/features/search/providers/search_provider.dart';
import 'package:mazar/features/splash/domain/reposotories/splash_repo.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/features/wallet_and_loyalty/domain/reposotories/wallet_repo.dart';
import 'package:mazar/features/wallet_and_loyalty/providers/wallet_provider.dart';
import 'package:mazar/features/wishlist/domain/reposotories/wishlist_repo.dart';
import 'package:mazar/features/wishlist/providers/wishlist_provider.dart';
import 'package:mazar/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/reposotories/news_letter_repo.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ChatRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => CouponRepo(dioClient: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NewsLetterRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WishListRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => WalletRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LocalizationProvider(
      dioClient: sl(), sharedPreferences: sl(), languageRepo: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => CategoryProvider(
      categoryRepo: sl(), productRepo: sl(), searchRepo: sl()));
  sl.registerFactory(
      () => ProductProvider(productRepo: sl(), searchRepo: sl()));
  sl.registerFactory(() => SearchProvider(searchRepo: sl()));
  sl.registerFactory(
      () => ChatProvider(chatRepo: sl(), notificationRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));
  sl.registerFactory(() => CouponProvider(couponRepo: sl()));
  sl.registerFactory(
      () => LocationProvider(locationRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(
      () => OrderProvider(orderRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => NewsLetterProvider(newsLetterRepo: sl()));
  sl.registerFactory(() => WishListProvider(wishListRepo: sl()));
  sl.registerFactory(() => WalletAndLoyaltyProvider(walletRepo: sl()));
  sl.registerFactory(() => FlashDealProvider(productRepo: sl()));
  sl.registerFactory(() => ReviewProvider(orderRepo: sl()));
  sl.registerFactory(() => VerificationProvider(authRepo: sl()));
  sl.registerFactory(() => OrderImageNoteProvider());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
