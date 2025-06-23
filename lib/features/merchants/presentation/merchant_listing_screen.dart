import 'package:flutter/material.dart';
import 'package:orado_customer/features/merchants/provider/merchant_provider.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common/custom_ui.dart';
import '../../../utilities/common/search_field.dart';
import '../../../utilities/utilities.dart';

class MerchantListingScreen extends StatefulWidget {
  const MerchantListingScreen({super.key, this.searchQuery, this.categoryId, this.subCategoryId, this.merchantId});
  static String route = 'merchant-listing';
  final String? searchQuery;
  final String? categoryId;
  final String? subCategoryId;
  final String? merchantId;
  @override
  State<MerchantListingScreen> createState() => _MerchantListingScreenState();
}

class _MerchantListingScreenState extends State<MerchantListingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<MerchantProvider>().viewAllProducts(
          context,
          long: 12,
          lat: 10,
          limit: 10,
          page: 1,
          searchQuery: widget.searchQuery,
          categoryId: widget.categoryId,
          subCategoryId: widget.subCategoryId,
          merchantId: widget.merchantId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomUi(
      title: 'Search',
      children: <Widget>[
        SearchField(isInPage: true, hintText: 'Find dishes', searchQuery: widget.searchQuery ?? ''),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Restaurants',
            style: AppStyles.getBoldTextStyle(fontSize: 17),
          ),
        ),
        // const SizedBox(height: 10),
        // Container(
        //   height: 60,
        //   // clipBehavior: Clip.hardEdge,
        //   width: MediaQuery.sizeOf(context).width,
        //   decoration: const BoxDecoration(),
        //   child: ListView.builder(
        //     itemCount: filteringOptions.length,
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (BuildContext c, int i) {
        //       return Center(
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3),
        //           child: Material(
        //             elevation: 5,
        //             color: Colors.white,
        //             surfaceTintColor: Colors.white,
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
        //               child: Row(
        //                 children: <Widget>[
        //                   if (i == 0) const Icon(Icons.settings, size: 14),
        //                   const SizedBox(width: 10),
        //                   Text(
        //                     filteringOptions[i],
        //                     style: AppStyles.getBoldTextStyle(
        //                       fontSize: 15,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        const SizedBox(height: 10),
        // Text(
        //   'All restaurants delivering ${widget.searchQuery}',
        //   style: AppStyles.getMediumTextStyle(fontSize: 14),
        // ),
        // const SizedBox(height: 10),
        // FoodTileCardLarge(data: TopRestaurants()),
        // FoodTileCardLarge(data: TopRestaurants()),
        // FoodTileCardLarge(data: TopRestaurants()),
        // BlocConsumer<MerchantBloc, MerchantState>(
        //   bloc: context.read<MerchantBloc>(),
        //   listener: (BuildContext context, MerchantState state) {},
        //   builder: (BuildContext context, MerchantState state) {
        //     if (state is MerchantLoadingState) {
        //       return CircularProgressIndicator(color: AppColors.baseColor);
        //     }
        //     if (state is MerchantLoadedState) {
        //       return ListView.separated(
        //         shrinkWrap: true,
        //         physics: const NeverScrollableScrollPhysics(),
        //         itemCount: state.products.length,
        //         separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
        //         itemBuilder: (BuildContext context, int index) => FoodTileCardLarge(
        //           merchantId: state.products[index].product!.merchantId.toString(),
        //           name: state.products[index].product!.productstablerelation1!.shopName,
        //           distance: state.products[index].distance,
        //           image: state.products[index].product!.productstablerelation1?.merchantImage?.imageName,
        //         ),
        //       );
        //     }
        //     return const SizedBox();
        //   },
        // )
      ],
    );
  }
}
