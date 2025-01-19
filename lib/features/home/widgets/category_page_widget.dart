import 'package:flutter/material.dart';
import 'package:mazar/common/providers/theme_provider.dart';
import 'package:mazar/common/widgets/custom_image_widget.dart';
import 'package:mazar/common/widgets/custom_slider_list_widget.dart';
import 'package:mazar/common/widgets/on_hover_widget.dart';
import 'package:mazar/common/widgets/text_hover_widget.dart';
import 'package:mazar/features/category/providers/category_provider.dart';
import 'package:mazar/features/splash/providers/splash_provider.dart';
import 'package:mazar/helper/route_helper.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/styles.dart';
import 'package:provider/provider.dart';

//ff
class CategoryWebWidget extends StatelessWidget {
  final ScrollController scrollController;
  const CategoryWebWidget({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      return SizedBox(
          height: 210,
          child: CustomSliderListWidget(
            controller: scrollController,
            verticalPosition: 50,
            isShowForwardButton:
                (categoryProvider.categoryList?.length ?? 0) > 9,
            child: ListView.builder(
              controller: scrollController,
              itemCount: categoryProvider.categoryList?.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                      top: Dimensions.paddingSizeLarge,
                      right: Dimensions.paddingSizeDefault),
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          RouteHelper.getCategoryProductsRoute(
                              categoryId:
                                  '${categoryProvider.categoryList![index].id}'));
                    },
                    child: TextHoverWidget(builder: (hovered) {
                      return Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                Provider.of<ThemeProvider>(context).darkTheme
                                    ? 0.05
                                    : 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: OnHoverWidget(
                              child: CustomImageWidget(
                                image: Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .baseUrls !=
                                        null
                                    ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${categoryProvider.categoryList![index].image}'
                                    : '',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        SizedBox(
                          width: 110,
                          child: Text(
                            categoryProvider.categoryList![index].name!,
                            style: poppinsMedium.copyWith(
                                color: hovered
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                        ?.withOpacity(0.6)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]);
                    }),
                  ),
                );
              },
            ),
          ));
    });
  }
}
