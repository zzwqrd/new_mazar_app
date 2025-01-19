import 'package:flutter/material.dart';
import 'package:mazar/features/address/domain/models/prediction_model.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';

class SearchItemWidget extends StatelessWidget {
  final PredictionModel? suggestion;
  const SearchItemWidget({
    Key? key,
    this.suggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(children: [
        const Icon(Icons.location_on),
        Expanded(
            child: Text(
          suggestion?.description ?? getTranslated('no_address_found', context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: Dimensions.fontSizeLarge,
              ),
        )),
      ]),
    );
  }
}
