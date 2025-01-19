import 'package:flutter/material.dart';
import 'package:mazar/common/widgets/custom_directionality_widget.dart';
import 'package:mazar/helper/price_converter_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/styles.dart';

class TotalAmountWidget extends StatelessWidget {
  const TotalAmountWidget({
    Key? key,
    required this.amount,
    required this.freeDelivery,
    required this.deliveryCharge,
  }) : super(key: key);

  final double amount;
  final bool freeDelivery;
  final double deliveryCharge;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(getTranslated('total_amount', context),
          style: poppinsMedium.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
            color: Theme.of(context).primaryColor,
          )),
      Flexible(
        child: CustomDirectionalityWidget(
            child: Text(
          PriceConverterHelper.convertPrice(
              context, amount + (freeDelivery ? 0 : deliveryCharge)),
          style: poppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).primaryColor),
        )),
      ),
    ]);
  }
}
