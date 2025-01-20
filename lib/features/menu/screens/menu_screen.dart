import 'package:flutter/material.dart';
import 'package:mazar/common/providers/cart_provider.dart';
import 'package:mazar/common/providers/theme_provider.dart';
import 'package:mazar/common/widgets/custom_asset_image_widget.dart';
import 'package:mazar/common/widgets/custom_image_widget.dart';
import 'package:mazar/common/widgets/web_app_bar_widget.dart';
import 'package:mazar/features/address/providers/location_provider.dart';
import 'package:mazar/features/auth/providers/auth_provider.dart';
import 'package:mazar/features/menu/domain/models/custom_drawer_controller_model.dart';
import 'package:mazar/features/menu/screens/main_screen.dart';
import 'package:mazar/features/menu/screens/setting_screen.dart';
import 'package:mazar/features/menu/widgets/menu_list_web_widget.dart';
import 'package:mazar/features/menu/widgets/sign_out_dialog_widget.dart';
import 'package:mazar/features/notification/screens/notification_screen.dart';
import 'package:mazar/features/profile/providers/profile_provider.dart';
import 'package:mazar/features/profile/screens/profile_screen.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/helper/route_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/color_resources.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/images.dart';
import 'package:mazar/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../cart/screens/cart_screen.dart';
import '../../category/screens/all_categories_screen.dart';
import '../../home/screens/home_screens.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import '../domain/models/main_screen_model.dart';

//ezzmuhyammed22@gmal.com
class MenuScreen extends StatefulWidget {
  final bool isReload;
  const MenuScreen({Key? key, this.isReload = true}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CustomDrawerController _drawerController = CustomDrawerController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    if (widget.isReload) {
      HomeScreen.loadData(true, Get.context!);
    }

    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (isLoggedIn && widget.isReload) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
      Provider.of<LocationProvider>(context, listen: false).initAddressList();
    } else {
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
          : CustomAppBar(
              pageIndex: _currentIndex,
              isDarkTheme: themeProvider.darkTheme,
              onDrawerOpen: () {
                setState(() {
                  Scaffold.of(context).openDrawer();
                });
              },
              onSearchTap: () {
                setState(() {
                  Navigator.pushNamed(context, RouteHelper.searchProduct);
                });
              },
              onCartTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              cartCount: cartProvider.cartList.length,
              appName: AppConstants.appName,
              title: _currentIndex == 0
                  ? null
                  : _currentIndex < screenList.length
                      ? screenList[_currentIndex].title
                      : 'الرئيسية',
              isHome: true,
            ),
      drawer: CustomDrawer(
        drawerController: _drawerController,
        screenList: screenListA,
        onItemTap: (index) {
          if (screenList
              .any((screen) => screen.title == screenListA[index].title)) {
            setState(() {
              _currentIndex = screenList.indexWhere(
                  (screen) => screen.title == screenListA[index].title);
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: CustomAppBar(
                    isHome: false,
                    onSearchTap: () {
                      Navigator.pushNamed(context, RouteHelper.searchProduct);
                    },
                    pageIndex: index,
                    isDarkTheme: themeProvider.darkTheme,
                    title: screenListA[index].title,
                    onDrawerOpen: () {
                      setState(() {
                        Navigator.pop(context);
                        // Scaffold.of(context).openDrawer();
                      });
                    },
                    onCartTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                    cartCount: cartProvider.cartList.length,
                  ),
                  body: screenListA[index].screen,
                ),
              ),
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => screenListA[index].screen,
            //   ),
            // );
          }
          // Navigator.pop(context); // إغلاق Drawer
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => screenList[index].screen,
          //   ),
          // );
          // setState(() {
          //   _currentIndex = index; // تحديث الصفحة عند اختيار عنصر
          // });
        },
      ),
      // drawer: MenuWidget(drawerController: _drawerController),
      body: _getSelectedPage(_currentIndex),
      bottomNavigationBar: buildCustomBottomNavigationBar(context),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const SizedBox(height: 13),
          FloatingActionButton(
            // mini: true,
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
            backgroundColor: const Color(0xFF0069AA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(
              Images.orderBag,
              width: 22,
            ),
            // child: const Icon(
            //   Icons.shopping_bag_outlined,
            //   size: 25,
            //   color: Colors.white,
            // ),
          ),
          // const SizedBox(height: 3),
          // const Text(
          //   "عربة التسوق",
          //   style: TextStyle(fontSize: 12),
          // ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getSelectedPage(int index) {
    if (index >= 0 && index < screenList.length) {
      return screenList[index].screen;
    } else {
      return screenList[0].screen;
    }
  }

  Widget buildNavItem(
      {required BuildContext context,
      required int index,
      required dynamic icon,
      required bool isActive,
      required String label}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 24,
            fit: BoxFit.cover,
            color: isActive ? const Color(0xFF0069AA) : const Color(0xFFC9CAD6),
          ),
          // Icon(
          //   icon,
          //   size: 24,
          //   color: isActive ? const Color(0xFFEF5730) : const Color(0xFFC9CAD6),
          // ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  isActive ? const Color(0xFF0069AA) : const Color(0xFFC9CAD6),
            ),
          ),
        ],
      ),
      // child: SvgPicture.asset(
      //   icon,
      //   width: 24,
      //   fit: BoxFit.cover,
      //   color: isActive ? Colors.amber : Colors.red,
      // ),
    );
  }

  Widget buildCustomBottomNavigationBar(BuildContext context) {
    return Container(
      height: 67,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(
            context: context,
            index: 0,
            icon: Images.home,
            label: "الرئيسية",
            isActive: _currentIndex == 0,
          ),
          buildNavItem(
            context: context,
            index: 1,
            icon: Images.list,
            label: "الفئات",
            isActive: _currentIndex == 1,
          ),
          const SizedBox(width: 23),
          buildNavItem(
            context: context,
            index: 3,
            icon: Images.favouriteIcon,
            label: "المفضله",
            isActive: _currentIndex == 3,
          ),
          buildNavItem(
            context: context,
            index: 4,
            icon: Images.settings,
            label: "الاعددات",
            isActive: _currentIndex == 4,
          ),
        ],
      ),
    );
  }

  List<MainScreenModel> screenList = [
    MainScreenModel(const HomeScreen(), 'home', Images.home),
    MainScreenModel(const AllCategoriesScreen(), 'all_categories', Images.list),
    MainScreenModel(const CartScreen(), 'shopping_bag', Images.orderBag),
    MainScreenModel(const WishListScreen(), 'favourite', Images.favouriteIcon),
    MainScreenModel(const SettingsScreen(), 'settings', Images.settings),
  ];
}

// class _MenuScreenState extends State<MenuScreen> {
//   final CustomDrawerController _drawerController = CustomDrawerController();
//
//   @override
//   void initState() {
//     if (widget.isReload) {
//       HomeScreen.loadData(true, Get.context!);
//     }
//     super.initState();
//     final bool isLoggedIn =
//         Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
//     if (isLoggedIn && widget.isReload) {
//       Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
//       Provider.of<LocationProvider>(context, listen: false).initAddressList();
//     } else {
//       Provider.of<CartProvider>(context, listen: false).getCartData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final splashProvider = Provider.of<SplashProvider>(context, listen: false);
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
//     final LocalizationProvider localizationProvider =
//         Provider.of<LocalizationProvider>(context, listen: false);
//     return Scaffold(
//       appBar: ResponsiveHelper.isDesktop(context)
//           ? const PreferredSize(
//               preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
//           : CustomAppBar(
//               pageIndex: splashProvider.pageIndex,
//               isDarkTheme: themeProvider.darkTheme,
//               onDrawerOpen: () {
//                 Scaffold.of(context).openDrawer();
//               },
//               onSearchTap: () {
//                 Navigator.pushNamed(context, RouteHelper.searchProduct);
//               },
//               onCartTap: () {
//                 splashProvider.setPageIndex(2);
//               },
//               cartCount: cartProvider.cartList.length,
//               appName: AppConstants.appName,
//               title: splashProvider.pageIndex == 0
//                   ? null
//                   : splashProvider.pageIndex < screenList.length
//                       ? screenList[splashProvider.pageIndex].title
//                       : 'الرئيسية',
//             ),
//
//       drawer: MenuWidget(drawerController: _drawerController),
//       body: _getSelectedPage(_currentIndex),
//       bottomNavigationBar: buildCustomBottomNavigationBar(context),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   backgroundColor: Colors.red,
//       //   currentIndex: _currentIndex,
//       //   onTap: _onItemTapped,
//       //   items: const [
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.home),
//       //       label: 'الرئيسية',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.notifications),
//       //       label: 'الإشعارات',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.favorite),
//       //       label: 'المفضلة',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.account_circle),
//       //       label: 'حسابي',
//       //     ),
//       //   ],
//       // ),
//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 13),
//           FloatingActionButton(
//             mini: true,
//             onPressed: () {
//               _onItemTapped(2);
//             },
//             backgroundColor: Colors.blue,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(100),
//             ),
//             child: const Icon(
//               Icons.add,
//               size: 30,
//             ),
//           ),
//           const SizedBox(height: 3),
//           const Text(
//             'اضف اعلان',
//             style: TextStyle(fontSize: 12),
//           ),
//         ],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       // body: MainScreen(
//       //     drawerController: _drawerController, isReload: widget.isReload),
//     );
//
//     // return CustomDrawerWidget(
//     //   controller: _drawerController,
//     //
//     //   menuScreen: MenuWidget(drawerController: _drawerController),
//     //   mainScreen: MainScreen(
//     //       drawerController: _drawerController, isReload: widget.isReload),
//     //   showShadow: false,
//     //   angle: 0.0,
//     //   borderRadius: 30,
//     //   slideWidth: MediaQuery.of(context).size.width *
//     //       (localizationProvider.isLtr ? 0.0 : 0.1),
//     //   // slideWidth: MediaQuery.of(context).size.width *
//     //   //     (localizationProvider.isLtr ? 0.6 : 0.1),
//     //
//     //   // slideWidth: MediaQuery.of(context).size.width * 0.1,
//     // );
//   }
//
//   int _currentIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   Widget _getSelectedPage(int index) {
//     switch (index) {
//       case 0:
//         return HomeScreen();
//       case 1:
//         return AllCategoriesScreen();
//       case 2:
//         return CartScreen();
//       case 3:
//         return Center(child: Text("المفضلة"));
//       case 4:
//         return SettingsScreen();
//       default:
//         return HomeScreen();
//     }
//     // if (index >= 0 && index < screenList.length) {
//     //   return screenList[index].screen;
//     // } else {
//     //   return screenList[0].screen;
//     // }
//   }
//
//   Widget buildNavItem({
//     required BuildContext context,
//     required int index,
//     required String icon,
//     required bool isActive,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _onItemTapped(_currentIndex);
//         });
//       },
//       child: SvgPicture.asset(
//         icon,
//         width: 24,
//         fit: BoxFit.cover,
//         color: isActive == true ? Colors.amber : Colors.red,
//       ),
//     );
//   }
//
//   Widget buildCustomBottomNavigationBar(BuildContext context) {
//     return Container(
//       height: 67,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           buildNavItem(
//             context: context,
//             index: 0,
//             icon: Assets.svgRefundPolicy,
//             isActive: _currentIndex == 0,
//           ),
//           buildNavItem(
//             context: context,
//             index: 1,
//             icon: Assets.svgRefundPolicy,
//             isActive: _currentIndex == 1,
//           ),
//           const SizedBox(width: 23),
//           buildNavItem(
//             context: context,
//             index: 3,
//             icon: Assets.svgRefundPolicy,
//             isActive: _currentIndex == 3,
//           ),
//           buildNavItem(
//             context: context,
//             index: 4,
//             icon: Assets.svgRefundPolicy,
//             isActive: _currentIndex == 4,
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<MainScreenModel> screenList = [
//     MainScreenModel(const HomeScreen(), 'home', Images.home),
//     MainScreenModel(const AllCategoriesScreen(), 'all_categories', Images.list),
//     MainScreenModel(const CartScreen(), 'shopping_bag', Images.orderBag),
//     MainScreenModel(const SettingsScreen(), 'settings', Images.settings),
//     MainScreenModel(const SettingsScreen(), 'settings', Images.settings),
//   ];
// }

class MenuWidget extends StatefulWidget {
  final CustomDrawerController? drawerController;

  const MenuWidget({Key? key, this.drawerController}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        if (!ResponsiveHelper.isDesktop(context) &&
            widget.drawerController?.isOpen()) {
          widget.drawerController?.toggle();
        }
      },
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ||
                ResponsiveHelper.isDesktop(context)
            ? Theme.of(context).hintColor.withOpacity(0.1)
            : Theme.of(context).primaryColor,
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
                preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
            : null,
        body: SafeArea(
          child: ResponsiveHelper.isDesktop(context)
              ? MenuListWebWidget(isLoggedIn: isLoggedIn)
              : SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webScreenWidth,
                      child: Consumer<SplashProvider>(
                        builder: (context, splash, child) {
                          return Column(children: [
                            !ResponsiveHelper.isDesktop(context)
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon: Icon(Icons.close,
                                          color: Provider.of<ThemeProvider>(
                                                      context)
                                                  .darkTheme
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color
                                                  ?.withOpacity(0.6)
                                              : ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? Theme.of(context)
                                                      .canvasColor
                                                  : Theme.of(context)
                                                      .canvasColor),
                                      onPressed: () {
                                        setState(() {
                                          Scaffold.of(context).closeEndDrawer();
                                          widget.drawerController!.toggle();
                                        });
                                        //
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, child) => Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            RouteHelper.profile,
                                            arguments: const ProfileScreen());
                                      },
                                      leading: ClipOval(
                                        child: isLoggedIn
                                            ? splashProvider.baseUrls != null
                                                ? CustomImageWidget(
                                                    placeholder: Images.profile,
                                                    image:
                                                        '${splashProvider.baseUrls?.customerImageUrl}/${profileProvider.userInfoModel?.image}',
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                  )
                                                : const SizedBox()
                                            : Image.asset(Images.profile,
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover),
                                      ),
                                      title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            isLoggedIn
                                                ? profileProvider
                                                            .userInfoModel !=
                                                        null
                                                    ? Text(
                                                        '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                                        style: poppinsRegular
                                                            .copyWith(
                                                          color: Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .darkTheme
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color
                                                                  ?.withOpacity(
                                                                      0.6)
                                                              : ResponsiveHelper.isDesktop(
                                                                      context)
                                                                  ? ColorResources
                                                                      .getDarkColor(
                                                                          context)
                                                                  : Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 10,
                                                        width: 150,
                                                        color:
                                                            ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? ColorResources
                                                                    .getDarkColor(
                                                                        context)
                                                                : Theme.of(
                                                                        context)
                                                                    .canvasColor)
                                                : Text(
                                                    getTranslated(
                                                        'guest', context),
                                                    style:
                                                        poppinsRegular.copyWith(
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .darkTheme
                                                          ? Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.color
                                                              ?.withOpacity(0.6)
                                                          : ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? ColorResources
                                                                  .getDarkColor(
                                                                      context)
                                                              : Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                    ),
                                                  ),
                                            if (isLoggedIn)
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                            if (isLoggedIn &&
                                                profileProvider.userInfoModel !=
                                                    null)
                                              Text(
                                                  profileProvider.userInfoModel!
                                                          .phone ??
                                                      '',
                                                  style:
                                                      poppinsRegular.copyWith(
                                                    color: Provider.of<
                                                                    ThemeProvider>(
                                                                context)
                                                            .darkTheme
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color
                                                            ?.withOpacity(0.6)
                                                        : ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? ColorResources
                                                                .getDarkColor(
                                                                    context)
                                                            : Theme.of(context)
                                                                .canvasColor,
                                                  )),
                                          ]),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.notifications,
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color
                                                    ?.withOpacity(0.6)
                                                : ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? ColorResources
                                                        .getDarkColor(context)
                                                    : Theme.of(context)
                                                        .canvasColor),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteHelper.notification,
                                          arguments:
                                              const NotificationScreen());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            if (!ResponsiveHelper.isDesktop(context))
                              Column(
                                  children: screenList
                                      .map((model) => ListTile(
                                            onTap: () {
                                              if (!ResponsiveHelper.isDesktop(
                                                  context)) {
                                                splash.setPageIndex(
                                                    screenList.indexOf(model));
                                              }
                                              widget.drawerController!.toggle();
                                            },
                                            selected: splash.pageIndex ==
                                                screenList.indexOf(model),
                                            selectedTileColor:
                                                Colors.black.withAlpha(30),
                                            leading: CustomAssetImageWidget(
                                              model.icon,
                                              color: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? ColorResources.getDarkColor(
                                                      context)
                                                  : Colors.white,
                                              width: 25,
                                              height: 25,
                                            ),
                                            title: Text(
                                                getTranslated(
                                                    model.title, context),
                                                style: poppinsRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .darkTheme
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color
                                                          ?.withOpacity(0.6)
                                                      : ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? ColorResources
                                                              .getDarkColor(
                                                                  context)
                                                          : Theme.of(context)
                                                              .canvasColor,
                                                )),
                                          ))
                                      .toList()),
                            ListTile(
                              onTap: () {
                                if (isLoggedIn) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          const SignOutDialogWidget());
                                } else {
                                  splashProvider.setPageIndex(0);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteHelper.getLoginRoute(),
                                      (route) => false);
                                }
                              },
                              leading: CustomAssetImageWidget(
                                isLoggedIn ? Images.logOut : Images.logIn,
                                width: 25,
                                height: 25,
                                color: Colors.white,
                              ),
                              title: Text(
                                getTranslated(
                                    isLoggedIn ? 'log_out' : 'login', context),
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Provider.of<ThemeProvider>(context)
                                          .darkTheme
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.withOpacity(0.6)
                                      : ResponsiveHelper.isDesktop(context)
                                          ? ColorResources.getDarkColor(context)
                                          : Theme.of(context).canvasColor,
                                ),
                              ),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int pageIndex;
  final bool isDarkTheme;
  final dynamic onDrawerOpen;
  final VoidCallback onSearchTap;
  final VoidCallback onCartTap;
  final String? appName;
  final String? title;
  final int cartCount;
  final bool isHome;

  const CustomAppBar({
    Key? key,
    required this.pageIndex,
    required this.isDarkTheme,
    required this.onDrawerOpen,
    required this.onSearchTap,
    required this.onCartTap,
    required this.isHome,
    required this.cartCount,
    this.appName,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).cardColor,
      leading: isHome
          ? StatefulBuilder(builder: (context, state) {
              return IconButton(
                icon: Image.asset(Images.moreIcon,
                    color: Theme.of(context).primaryColor,
                    height: 30,
                    width: 30),
                // onPressed: onDrawerOpen,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            })
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              onPressed: onDrawerOpen,
              // onPressed: () {
              //   Scaffold.of(context).openDrawer();
              // },
            ),
      title: pageIndex == 0
          ? Image.asset(
              Images.appLogo,
              width: 30,
            )
          // Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Image.asset(
          //             Images.appLogo,
          //             width: 25,
          //           ), // Replace with your logo
          //           // const SizedBox(width: 8),
          //           // Expanded(
          //           //   child: Text(
          //           //     appName ?? '',
          //           //     maxLines: 1,
          //           //     overflow: TextOverflow.ellipsis,
          //           //     style: TextStyle(
          //           //       color: Theme.of(context).primaryColor,
          //           //       fontWeight: FontWeight.bold,
          //           //     ),
          //           //   ),
          //           // ),
          //         ],
          //       )
          : Text(
              title ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
      actions: pageIndex == 0
          ? [
              IconButton(
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                onPressed: onSearchTap,
              ),
              IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.shopping_cart,
                        color: Theme.of(context)
                            .hintColor
                            .withOpacity(isDarkTheme ? 0.9 : 0.4),
                        size: 30),
                    if (cartCount > 0)
                      Positioned(
                        top: -7,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            '$cartCount',
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: onCartTap,
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class MenuButton {
  final String routeName;
  final String icon;
  final String title;
  final IconData? iconData;
  MenuButton(
      {required this.routeName,
      required this.icon,
      required this.title,
      this.iconData});
}
