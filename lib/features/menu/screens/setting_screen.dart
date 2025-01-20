import 'package:flutter/material.dart';
import 'package:mazar/common/providers/theme_provider.dart';
import 'package:mazar/common/widgets/app_bar_base_widget.dart';
import 'package:mazar/common/widgets/main_app_bar_widget.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/dialog_helper.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_asset_image_widget.dart';
import '../../../common/widgets/custom_image_widget.dart';
import '../../../helper/route_helper.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/images.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/screens/profile_screen.dart';
import '../widgets/acount_delete_dialog_widget.dart';
import '../widgets/menu_list_web_widget.dart';
import '../widgets/sign_out_dialog_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).setFromSetting(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? null
          : (ResponsiveHelper.isDesktop(context)
              ? const MainAppBarWidget()
              : const AppBarBaseWidget()) as PreferredSizeWidget?,
      body: Center(
        child: SizedBox(
          // width: 1170,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall),
            children: [
              const SizedBox(height: 50),
              // SwitchListTile(
              //   activeColor: Theme.of(context).primaryColor,
              //   value: Provider.of<ThemeProvider>(context).darkTheme,
              //   onChanged: (bool isActive) =>
              //       Provider.of<ThemeProvider>(context, listen: false)
              //           .toggleTheme(),
              //   title: Text(getTranslated('dark_theme', context),
              //       style: poppinsRegular.copyWith(
              //           fontSize: Dimensions.fontSizeLarge)),
              // ),
              // _TitleButton(
              //   icon: Icons.language,
              //   title: getTranslated('choose_language', context),
              //   onTap: () =>
              //       showDialogHelper(context, const CurrencyDialogWidget()),
              // ),
              ResponsiveHelper.isDesktop(context)
                  ? MenuListWebWidget(isLoggedIn: isLoggedIn)
                  : SingleChildScrollView(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webScreenWidth,
                          child: Consumer<SplashProvider>(
                            builder: (context, splash, child) {
                              return Column(children: [
                                Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, child) =>
                                      Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                RouteHelper.profile,
                                                arguments:
                                                    const ProfileScreen());
                                          },
                                          leading: ClipOval(
                                            child: isLoggedIn
                                                ? splashProvider.baseUrls !=
                                                        null
                                                    ? CustomImageWidget(
                                                        placeholder:
                                                            Images.profile,
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
                                                            style:
                                                                poppinsRegular
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
                                                                  : ResponsiveHelper
                                                                          .isDesktop(
                                                                              context)
                                                                      ? ColorResources
                                                                          .getDarkColor(
                                                                              context)
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 10,
                                                            width: 150,
                                                            color: ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? ColorResources
                                                                    .getDarkColor(
                                                                        context)
                                                                : Theme.of(
                                                                        context)
                                                                    .primaryColor)
                                                    : Text(
                                                        getTranslated(
                                                            'guest', context),
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
                                                                      .primaryColor,
                                                        ),
                                                      ),
                                                if (isLoggedIn)
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                if (isLoggedIn &&
                                                    profileProvider
                                                            .userInfoModel !=
                                                        null)
                                                  Text(
                                                      profileProvider
                                                              .userInfoModel!
                                                              .phone ??
                                                          '',
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
                                                            : ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? ColorResources
                                                                    .getDarkColor(
                                                                        context)
                                                                : Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                      )),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 50),
                                if (!ResponsiveHelper.isDesktop(context))
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
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      getTranslated(
                                          isLoggedIn ? 'log_out' : 'login',
                                          context),
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Colors.red,
                                        // color: Provider.of<ThemeProvider>(
                                        //             context)
                                        //         .darkTheme
                                        //     ? Theme.of(context)
                                        //         .textTheme
                                        //         .bodyLarge
                                        //         ?.color
                                        //         ?.withOpacity(0.6)
                                        //     : ResponsiveHelper.isDesktop(
                                        //             context)
                                        //         ? ColorResources.getDarkColor(
                                        //             context)
                                        //         : Theme.of(context).canvasColor,
                                      ),
                                    ),
                                  ),
                              ]);
                            },
                          ),
                        ),
                      ),
                    ),

              authProvider.isLoggedIn()
                  ? ListTile(
                      onTap: () {
                        showDialogHelper(
                            context,
                            AccountDeleteDialogWidget(
                              icon: Icons.question_mark_sharp,
                              title: getTranslated(
                                  'are_you_sure_to_delete_account', context),
                              description: getTranslated(
                                  'it_will_remove_your_all_information',
                                  context),
                              onTapFalseText: getTranslated('no', context),
                              onTapTrueText: getTranslated('yes', context),
                              isFailed: true,
                              onTapFalse: () => Navigator.of(context).pop(),
                              onTapTrue: () => authProvider.deleteUser(context),
                            ),
                            dismissible: false,
                            isFlip: true);
                      },
                      leading: Icon(Icons.delete,
                          size: 25, color: Theme.of(context).colorScheme.error),
                      title: Text(
                        getTranslated('delete_account', context),
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleButton extends StatelessWidget {
  final IconData icon;
  final String? title;
  final Function onTap;
  const _TitleButton(
      {Key? key, required this.icon, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title!,
          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      onTap: onTap as void Function()?,
    );
  }
}
