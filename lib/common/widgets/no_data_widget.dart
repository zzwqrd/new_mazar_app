import 'package:flutter/material.dart';
import 'package:mazar/common/enums/footer_type_enum.dart';
import 'package:mazar/common/widgets/custom_button_widget.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/helper/route_helper.dart';
import 'package:mazar/localization/app_localization.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/images.dart';
import 'package:mazar/utill/styles.dart';
import 'package:provider/provider.dart';

import 'footer_web_widget.dart';

class NoDataWidget extends StatelessWidget {
  final bool isShowButton;
  final bool isFooter;
  final String? title;
  final String? subTitle;
  final String? image;
  const NoDataWidget(
      {Key? key,
      this.isShowButton = true,
      required this.title,
      this.image,
      this.subTitle,
      this.isFooter = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ResponsiveHelper.isDesktop(context)
        ? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: height * 0.7,
                    width: double.infinity,
                    child: NoDataView(
                      image: image,
                      title: title,
                      subTitle: subTitle,
                      isShowButton: isShowButton,
                    )),
                isFooter
                    ? const FooterWebWidget(footerType: FooterType.nonSliver)
                    : const SizedBox(),
              ],
            ),
          )
        : NoDataView(
            image: image,
            title: title,
            subTitle: subTitle,
            isShowButton: isShowButton);
  }
}

class NoDataView extends StatelessWidget {
  const NoDataView({
    Key? key,
    this.image,
    this.title,
    this.subTitle,
    this.isShowButton = true,
  }) : super(key: key);

  final String? image;
  final String? title;
  final String? subTitle;
  final bool isShowButton;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            image ?? Images.notFound,
            // isOrder ? Images.box : isCart ? Images.shoppingCart : Images.notFound,
            width: height * 0.17, height: height * 0.17,
            color: Theme.of(context).hintColor.withOpacity(0.5),
          ),
          SizedBox(height: height * 0.03),
          Text(
            title ?? getTranslated('no_result_found', context),
            style: poppinsMedium.copyWith(
                color: Theme.of(context).hintColor.withOpacity(0.5),
                fontSize: height * 0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.01),
          if (subTitle != null)
            Text(
              subTitle!,
              style: poppinsRegular.copyWith(fontSize: height * 0.02),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: height * 0.02),
          if (isShowButton)
            SizedBox(
                height: 40,
                width: 150,
                child: CustomButtonWidget(
                  buttonText: 'lets_shop'.tr,
                  onPressed: () {
                    Provider.of<SplashProvider>(context, listen: false)
                        .setPageIndex(0);
                    Navigator.pushNamed(context, RouteHelper.getMainRoute());
                  },
                )),
        ]),
      ),
    );
  }
}
