import 'package:flutter/material.dart';
import 'package:mazar/common/widgets/custom_loader_widget.dart';
import 'package:mazar/common/widgets/main_app_bar_widget.dart';
import 'package:mazar/common/widgets/no_data_widget.dart';
import 'package:mazar/features/category/domain/models/category_model.dart';
import 'package:mazar/features/category/providers/category_provider.dart';
import 'package:mazar/features/category/widgets/category_item_widget.dart';
import 'package:mazar/features/category/widgets/sub_category_shimmer_widget.dart';
import 'package:mazar/helper/responsive_helper.dart';
import 'package:mazar/helper/route_helper.dart';
import 'package:mazar/localization/language_constraints.dart';
import 'package:mazar/utill/dimensions.dart';
import 'package:mazar/utill/styles.dart';
import 'package:provider/provider.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    if (Provider.of<CategoryProvider>(context, listen: false).categoryList !=
            null &&
        Provider.of<CategoryProvider>(context, listen: false)
            .categoryList!
            .isNotEmpty) {
      _load();
    } else {
      Provider.of<CategoryProvider>(context, listen: false)
          .getCategoryList(context, true)
          .then((apiResponse) {
        if (apiResponse.response!.statusCode == 200 &&
            apiResponse.response!.data != null) {
          _load();
        }
      });
    }
  }

  _load() async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.onChangeCategoryIndex(0, notify: false);

    if (categoryProvider.categoryList?.isNotEmpty ?? false) {
      categoryProvider.getSubCategoryList(
          context, categoryProvider.categoryList![0].id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          ResponsiveHelper.isDesktop(context) ? const MainAppBarWidget() : null,
      body: Center(
          child: SizedBox(
        width: Dimensions.webScreenWidth,
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return categoryProvider.categoryList == null
                ? Center(
                    child: CustomLoaderWidget(
                        color: Theme.of(context).primaryColor),
                  )
                : categoryProvider.categoryList?.isNotEmpty ?? false
                    ? Row(children: [
                        Container(
                          width: 120,
                          margin: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeSmall),
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 3,
                                  blurRadius: 10)
                            ],
                          ),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: categoryProvider.categoryList!.length,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            itemBuilder: (context, index) {
                              CategoryModel category =
                                  categoryProvider.categoryList![index];
                              return InkWell(
                                onTap: () {
                                  categoryProvider.onChangeCategoryIndex(index);
                                  categoryProvider.getSubCategoryList(
                                      context, category.id.toString());
                                },
                                child: CategoryItemWidget(
                                  title: category.name,
                                  icon: category.image,
                                  isSelected:
                                      categoryProvider.categoryIndex == index,
                                ),
                              );
                            },
                          ),
                        ),
                        categoryProvider.subCategoryList != null
                            ? Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  itemCount:
                                      categoryProvider.subCategoryList!.length +
                                          1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return ListTile(
                                        onTap: () {
                                          categoryProvider
                                              .onChangeSelectIndex(-1);
                                          categoryProvider
                                              .initCategoryProductList(
                                            categoryProvider
                                                .categoryList![categoryProvider
                                                    .categoryIndex]
                                                .id
                                                .toString(),
                                          );
                                          Navigator.of(context).pushNamed(
                                            RouteHelper
                                                .getCategoryProductsRoute(
                                              categoryId:
                                                  '${categoryProvider.categoryList![categoryProvider.categoryIndex].id}',
                                            ),
                                          );
                                        },
                                        title:
                                            Text(getTranslated('all', context)),
                                        trailing: const Icon(
                                            Icons.keyboard_arrow_right),
                                      );
                                    }
                                    return ListTile(
                                      onTap: () {
                                        categoryProvider
                                            .onChangeSelectIndex(index - 1);
                                        if (ResponsiveHelper.isMobilePhone()) {}
                                        categoryProvider
                                            .initCategoryProductList(
                                          categoryProvider
                                              .subCategoryList![index - 1].id
                                              .toString(),
                                        );

                                        Navigator.of(context).pushNamed(
                                          RouteHelper.getCategoryProductsRoute(
                                            categoryId:
                                                '${categoryProvider.categoryList![categoryProvider.categoryIndex].id}',
                                            subCategory: categoryProvider
                                                .subCategoryList![index - 1]
                                                .name,
                                          ),
                                        );
                                      },
                                      title: Text(
                                        categoryProvider
                                            .subCategoryList![index - 1].name!,
                                        style: poppinsMedium.copyWith(
                                            fontSize: 13,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color
                                                ?.withOpacity(0.6)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: const Icon(
                                          Icons.keyboard_arrow_right),
                                    );
                                  },
                                ),
                              )
                            : const Expanded(
                                child: SubCategoriesShimmerWidget()),
                      ])
                    : NoDataWidget(
                        title: getTranslated('category_not_found', context),
                      );
          },
        ),
      )),
    );
  }
}
