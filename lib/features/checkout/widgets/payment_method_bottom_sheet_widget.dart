import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mazar/common/models/config_model.dart';
import 'package:mazar/common/widgets/custom_button_widget.dart';
import 'package:mazar/common/widgets/no_data_widget.dart';
import 'package:mazar/features/auth/providers/auth_provider.dart';
import 'package:mazar/features/checkout/widgets/offline_payment_widget.dart';
import 'package:mazar/features/checkout/widgets/payment_button_widget.dart';
import 'package:mazar/features/order/providers/order_provider.dart';
import 'package:mazar/features/profile/providers/profile_provider.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/checkout_helper.dart';
import 'package:mazar/helper/custom_snackbar_helper.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/images.dart';
import 'package:mazar/utill/styles.dart';
import 'package:provider/provider.dart';

import 'partial_pay_dialog_widget.dart';
import 'payment_method_widget.dart';

class PaymentMethodBottomSheetWidget extends StatefulWidget {
  const PaymentMethodBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<PaymentMethodBottomSheetWidget> createState() =>
      _PaymentMethodBottomSheetWidgetState();
}

class _PaymentMethodBottomSheetWidgetState
    extends State<PaymentMethodBottomSheetWidget> {
  bool canSelectWallet = false;
  bool notHideCod = true;
  bool notHideDigital = true;
  bool notHideOffline = true;
  List<PaymentMethod> paymentList = [];

  @override
  void initState() {
    super.initState();

    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    double? walletBalance = Provider.of<ProfileProvider>(context, listen: false)
        .userInfoModel
        ?.walletBalance;
    final ConfigModel configModel = splashProvider.configModel!;

    orderProvider.setPaymentIndex(null, isUpdate: false);
    orderProvider.changePaymentMethod(isClear: true, isUpdate: false);
    orderProvider.setOfflineSelectedValue(null, isUpdate: false);

    if (authProvider.isLoggedIn() &&
        walletBalance != null &&
        walletBalance >= (orderProvider.getCheckOutData?.amount ?? 0)) {
      canSelectWallet = true;
    }

    if (orderProvider.partialAmount != null) {
      if (configModel.partialPaymentCombineWith!.toLowerCase() == 'cod') {
        notHideCod = true;
        notHideDigital = false;
        notHideOffline = false;
      } else if (configModel.partialPaymentCombineWith!.toLowerCase() ==
          'digital') {
        notHideCod = false;
        notHideDigital = true;
        notHideOffline = false;
      } else if (configModel.partialPaymentCombineWith!.toLowerCase() ==
          'offline') {
        notHideCod = false;
        notHideDigital = false;
        notHideOffline = true;
      } else if (configModel.partialPaymentCombineWith!.toLowerCase() ==
          'all') {
        notHideCod = true;
        notHideDigital = true;
        notHideOffline = true;
      }

      if (splashProvider.offlinePaymentModelList == null ||
          (splashProvider.offlinePaymentModelList != null &&
              splashProvider.offlinePaymentModelList!.isEmpty)) {
        notHideOffline = false;
      }
    }

    if (notHideDigital) {
      paymentList.addAll(configModel.activePaymentMethodList ?? []);
    }

    if (configModel.isOfflinePayment! && notHideOffline) {
      paymentList.add(PaymentMethod(
        getWay: 'offline',
        getWayTitle: getTranslated('offline', context),
        type: 'offline',
        getWayImage: Images.offlinePayment,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    final bool isCODActive = configModel.cashOnDelivery! && notHideCod;

    final bool isWalletActive = CheckOutHelper.isWalletPayment(
      configModel: configModel,
      isLogin: authProvider.isLoggedIn(),
      partialAmount: orderProvider.partialAmount,
      isPartialPayment: CheckOutHelper.isPartialPayment(
        configModel: configModel,
        isLogin: authProvider.isLoggedIn(),
        userInfoModel: profileProvider.userInfoModel,
      ),
    );

    final bool isDisableAllPayment =
        !isCODActive && !isWalletActive && paymentList.isEmpty;

    return SingleChildScrollView(
      child: Center(
          child: SizedBox(
              width: 550,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (ResponsiveHelper.isDesktop(context))
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                if (ResponsiveHelper.isDesktop(context))
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.8),
                  width: 550,
                  margin: const EdgeInsets.only(top: kIsWeb ? 0 : 30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: ResponsiveHelper.isMobile()
                        ? const BorderRadius.vertical(
                            top: Radius.circular(Dimensions.radiusSizeLarge))
                        : const BorderRadius.all(
                            Radius.circular(Dimensions.radiusSizeDefault)),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge,
                      vertical: Dimensions.paddingSizeLarge),
                  child: isDisableAllPayment
                      ? NoDataWidget(
                          isShowButton: false,
                          title: getTranslated(
                              'no_payment_methods_are_available', context),
                        )
                      : Consumer<OrderProvider>(
                          builder: (ctx, orderProvider, _) {
                          double orderAmount =
                              orderProvider.getCheckOutData?.amount ?? 0;

                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                !ResponsiveHelper.isDesktop(context)
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 4,
                                          width: 35,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                    height: Dimensions.paddingSizeDefault),
                                Row(children: [
                                  notHideCod
                                      ? Text(
                                          getTranslated(
                                              'choose_payment_method', context),
                                          style: poppinsBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault))
                                      : const SizedBox(),
                                  SizedBox(
                                      width: notHideCod
                                          ? Dimensions.paddingSizeExtraSmall
                                          : 0),
                                ]),
                                SizedBox(
                                    height: notHideCod
                                        ? Dimensions.paddingSizeLarge
                                        : 0),
                                Row(children: [
                                  if (isCODActive)
                                    Expanded(
                                      child: PaymentButtonWidget(
                                        icon: Images.cartIcon,
                                        title: getTranslated(
                                            'cash_on_delivery', context),
                                        isSelected:
                                            orderProvider.paymentMethodIndex ==
                                                0,
                                        onTap: () {
                                          orderProvider.setPaymentIndex(0);
                                        },
                                      ),
                                    ),
                                  if (isCODActive)
                                    const SizedBox(
                                        width: Dimensions.paddingSizeLarge),
                                  if (isWalletActive)
                                    Expanded(
                                        child: PaymentButtonWidget(
                                      icon: Images.walletPayment,
                                      title: getTranslated(
                                          'pay_via_wallet', context),
                                      isSelected:
                                          orderProvider.paymentMethodIndex == 1,
                                      onTap: () {
                                        if (isWalletActive && canSelectWallet) {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  PartialPayDialogWidget(
                                                    isPartialPay: profileProvider
                                                            .userInfoModel!
                                                            .walletBalance! <
                                                        orderAmount,
                                                    totalPrice: orderAmount,
                                                  ));
                                          // orderProvider.setPaymentIndex(1);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBarHelper(getTranslated(
                                              'your_wallet_have_not_sufficient_balance',
                                              context));
                                        }
                                      },
                                    )),
                                ]),
                                if (isWalletActive)
                                  const SizedBox(
                                      height: Dimensions.paddingSizeLarge),
                                if (paymentList.isNotEmpty)
                                  Row(children: [
                                    Text(
                                        getTranslated(
                                            'pay_via_online', context),
                                        style: poppinsBold.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault)),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Flexible(
                                        child: Text(
                                            '(${getTranslated('faster_and_secure_way_to_pay_bill', context)})',
                                            style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ))),
                                  ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                if (paymentList.isNotEmpty)
                                  Expanded(
                                      child: PaymentMethodWidget(
                                          paymentList: paymentList,
                                          onTap: (index) {
                                            if (notHideOffline &&
                                                paymentList[index].type ==
                                                    'offline') {
                                              orderProvider.changePaymentMethod(
                                                  digitalMethod:
                                                      paymentList[index]);
                                            } else if (!notHideDigital) {
                                              showCustomSnackBarHelper(
                                                  '${getTranslated('you_can_not_use', context)} ${getTranslated('digital_payment', context)} ${getTranslated('in_partial_payment', context)}');
                                            } else {
                                              orderProvider.changePaymentMethod(
                                                  digitalMethod:
                                                      paymentList[index]);
                                            }
                                          })),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                SafeArea(
                                    child: CustomButtonWidget(
                                  buttonText: getTranslated('select', context),
                                  onPressed: orderProvider.paymentMethodIndex ==
                                                  null &&
                                              orderProvider.paymentMethod ==
                                                  null ||
                                          (orderProvider.paymentMethod !=
                                                  null &&
                                              orderProvider
                                                      .paymentMethod?.type ==
                                                  'offline' &&
                                              orderProvider
                                                      .selectedOfflineMethod ==
                                                  null)
                                      ? null
                                      : () {
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();

                                          Navigator.pop(context);

                                          if (orderProvider
                                                  .paymentMethod?.type ==
                                              'offline') {
                                            if (orderProvider
                                                    .selectedOfflineValue !=
                                                null) {
                                              orderProvider
                                                  .setOfflineSelect(true);
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      const OfflinePaymentWidget());
                                            }
                                          } else {
                                            orderProvider.savePaymentMethod(
                                                index: orderProvider
                                                    .paymentMethodIndex,
                                                method: orderProvider
                                                    .paymentMethod);
                                          }
                                        },
                                )),
                              ]);
                        }),
                ),
              ]))),
    );
  }
}
