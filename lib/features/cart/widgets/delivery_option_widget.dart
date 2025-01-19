import 'package:flutter/material.dart';
import 'package:mazar/common/widgets/custom_directionality_widget.dart';
import 'package:mazar/features/order/providers/order_provider.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/price_converter_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryOptionWidget extends StatefulWidget {
  final String value;
  final String? title;
  final bool kmWiseFee;
  final bool freeDelivery;
  const DeliveryOptionWidget(
      {Key? key,
      required this.value,
      required this.title,
      required this.kmWiseFee,
      this.freeDelivery = false})
      : super(key: key);

  @override
  State<DeliveryOptionWidget> createState() => _DeliveryOptionWidgetState();
}

class _DeliveryOptionWidgetState extends State<DeliveryOptionWidget> {
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () {
            setState(() {
              order.setOrderType(widget.value);
            });
          },
          child: Row(
            children: [
              Radio(
                value: widget.value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String? value) {
                  setState(() {
                    order.setOrderType(value);
                  });
                },
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(widget.title!,
                  style: order.orderType == widget.value
                      ? poppinsSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall)
                      : poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(width: 5),
              widget.freeDelivery
                  ? CustomDirectionalityWidget(
                      child: Text('(${getTranslated('free', context)})',
                          style: poppinsMedium))
                  : widget.kmWiseFee
                      ? const SizedBox()
                      : Text(
                          '(${widget.value == 'delivery' && !widget.freeDelivery ? PriceConverterHelper.convertPrice(context, splashProvider.configModel?.deliveryCharge) : getTranslated('free', context)})',
                          style: poppinsMedium,
                        ),
            ],
          ),
        );
      },
    );
  }
}
