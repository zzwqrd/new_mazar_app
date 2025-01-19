import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mazar/common/widgets/custom_button_widget.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/main.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/styles.dart';

class PermissionDialogWidget extends StatelessWidget {
  const PermissionDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: SizedBox(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded,
                color: Theme.of(context).primaryColor, size: 100),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              getTranslated('you_denied_location_permission', context),
              textAlign: TextAlign.center,
              style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: const Size(1, 50),
                  ),
                  child: Text(getTranslated('no', context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                  child: CustomButtonWidget(
                      buttonText: getTranslated('yes', context),
                      onPressed: () async {
                        if (ResponsiveHelper.isMobilePhone()) {
                          await Geolocator.openAppSettings();
                        }
                        Navigator.pop(Get.context!);
                      })),
            ]),
          ]),
        ),
      ),
    );
  }
}
