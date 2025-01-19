import 'package:flutter/material.dart';
import 'package:mazar/features/order/domain/models/order_details_model.dart';
import 'package:mazar/helper/order_helper.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/styles.dart';

class OrderedProductVariationWidget extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;
  const OrderedProductVariationWidget(
      {Key? key, required this.orderDetailsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('======formated===${orderDetailsModel.formattedVariation}');
    return OrderHelper.getVariationValue(orderDetailsModel.formattedVariation)
            .isNotEmpty
        ? Row(children: [
            Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                )),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              OrderHelper.getVariationValue(
                  orderDetailsModel.formattedVariation),
              style:
                  poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          ])
        : const SizedBox();
  }
}
