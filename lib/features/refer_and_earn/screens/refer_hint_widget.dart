import 'package:flutter/material.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/images.dart';
import 'package:mazar/utill/styles.dart';

class ReferHintWidget extends StatelessWidget {
  final List<String?>? hintList;
  const ReferHintWidget({Key? key, this.hintList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.04),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            if (!ResponsiveHelper.isDesktop(context))
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: Dimensions.paddingSizeExtraSmall,
                width: 30,
              ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            Row(
              children: [
                Image.asset(
                  Images.iMark,
                  height: Dimensions.fontSizeExtraLarge,
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeSmall,
                ),
                Text(
                  getTranslated('how_it_works', context),
                  style: poppinsBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
            Column(
              children: hintList!
                  .map(
                    (hint) => Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: Text('${hintList!.indexOf(hint) + 1}',
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              )),
                        ),
                        const SizedBox(
                          width: Dimensions.paddingSizeDefault,
                        ),
                        Flexible(
                          child: Text(
                            hint!,
                            style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
