import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/cart/models/cart_model.dart' hide Productstablerelation1;
import 'package:orado_customer/features/cart/presentation/cart_screen.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/merchants/models/product_model.dart';
import 'package:orado_customer/features/merchants/provider/merchant_provider.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common/custom_container.dart';
import '../../../utilities/common/food_listing_card.dart';
import '../../../utilities/utilities.dart';

class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({super.key, this.id, this.searchQuery});
  static String route = 'merchant-details';
  final String? id;
  final String? searchQuery;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

ValueNotifier<bool> scrollNotifier = ValueNotifier<bool>(true);

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  ScrollController scrollController = ScrollController();
  List<String> filteringOptions = <String>['Veg', 'Non-Veg'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MerchantProvider>();
      final locProvider = context.read<LocationProvider>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.baseColor,
        actions: <Widget>[
          InkWell(onTap: () {}, child: const Icon(Icons.search)),
          const SizedBox(width: 10),
          InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
          const SizedBox(width: 10),
          InkWell(onTap: () {}, child: const Icon(Icons.share)),
          const SizedBox(width: 10),
          InkWell(onTap: () {}, child: const Icon(Icons.more_vert_sharp)),
        ],
      ),
      body: CustomScrollView(
        controller: scrollController,
        shrinkWrap: true,
        slivers: <Widget>[
          Consumer<MerchantProvider>(builder: (context, provider, _) {
            if (provider.isLoading) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (provider.merchantProducts[widget.id] == null) {
              return SliverFillRemaining(
                child: Center(
                  child: Text("Error"),
                ),
              );
            }

            final allProducts = provider.merchantProducts[widget.id]!;
            final filteredProducts = (widget.searchQuery != null && widget.searchQuery!.isNotEmpty)
                ? allProducts.where((product) {
                    final nameMatch = (product.product?.productName ?? '')
                        .toLowerCase()
                        .contains(widget.searchQuery!.toLowerCase());
                    // Replace 'foodType' with the correct property or remove this filter if not needed.
                    // Example: If you want to filter only by product name, remove cuisineMatch.
                    return nameMatch;
                  }).toList()
                : allProducts;

            final Productstablerelation1? merchant = filteredProducts.isNotEmpty
                ? filteredProducts.first.product!.productstablerelation1
                : allProducts.first.product!.productstablerelation1;
            // final Productstablerelation1? merchant = provider.merchantProducts[widget.id]!.first.product!.productstablerelation1;
            return SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 2.5,
                        width: MediaQuery.sizeOf(context).width,
                        child: CachedNetworkImage(
                          imageUrl: merchant?.merchantImage?.imageName ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(Icons.image),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: MediaQuery.sizeOf(context).height / 3.5),
                          Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 40),
                                  ClipPath(
                                    clipper: CustomContainer(),
                                    child: Container(
                                      // height: MediaQuery.sizeOf(context).height,
                                      width: MediaQuery.sizeOf(context).width,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 30),
                                          Center(
                                            child: Text(
                                              merchant?.shopName ?? '',
                                              style: AppStyles.getBoldTextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Center(
                                            child: Text(
                                              merchant?.address ?? '',
                                              style: AppStyles.getMediumTextStyle(fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Align(
                                            child: InkWell(
                                                onTap: () {
                                                  //! context.pushNamed(AppPaths.reviewScreen);
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '3.33',
                                                      style: AppStyles.getBoldTextStyle(
                                                        color: Colors.green.shade600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Icon(
                                                      Icons.star,
                                                      size: 12,
                                                      color: Colors.green.shade600,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text('81 ratings', style: AppStyles.getRegularTextStyle(fontSize: 12)),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              const Icon(Icons.timer_outlined, size: 14),
                                              const SizedBox(width: 5),
                                              Text(
                                                '22 mins . ${provider.merchantProducts[widget.id]!.first.distance!.toStringAsFixed(2)} | ${merchant?.displayAddress}',
                                                style: AppStyles.getMediumTextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            height: 60,
                                            width: MediaQuery.sizeOf(context).width,
                                            decoration: const BoxDecoration(),
                                            child: ListView.builder(
                                                itemCount: filteringOptions.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (BuildContext c, int i) {
                                                  return InkWell(
                                                    onTap: () {},
                                                    radius: 50,
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3),
                                                        child: Material(
                                                          elevation: 5,
                                                          color: Colors.white,
                                                          surfaceTintColor: Colors.white,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
                                                            child: Row(
                                                              children: <Widget>[
                                                                if (i == 0) const Icon(Icons.settings, size: 14),
                                                                const SizedBox(width: 10),
                                                                Text(
                                                                  filteringOptions[i],
                                                                  style: AppStyles.getBoldTextStyle(
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                          const SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Text(
                                              'Recommended',
                                              style: AppStyles.getSemiBoldTextStyle(
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          // FoodsListingCard(products: provider.merchantProducts[widget.id]!, merchantId: widget.id!),
                                          // --- Show filtered products if searchQuery is present ---
                                          FoodsListingCard(
                                            products: filteredProducts,
                                            merchantId: widget.id!,
                                          ),
                                          const SizedBox(height: 30),
                                          // Align(
                                          //   alignment: Alignment.centerLeft,
                                          //   child: Text(
                                          //     'Try  these similar restaurants',
                                          //     style: AppStyles.getSemiBoldTextStyle(fontSize: 22),
                                          //   ),
                                          // ),
                                          // const SizedBox(height: 20),
                                          // SizedBox(
                                          //   height: 300,
                                          //   child: ListView.builder(
                                          //     shrinkWrap: true,
                                          //     itemCount: 10,
                                          //     physics: const AlwaysScrollableScrollPhysics(),
                                          //     scrollDirection: Axis.horizontal,
                                          //     itemBuilder: (BuildContext context, int index) {
                                          //       return const FoodTileCardSmall();
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 160),
                                ],
                              ),
                              // const Center(
                              //   child: CircleAvatar(radius: 40),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, provider, _) {
          if (provider.cart.cartItems != null &&
              provider.cart.cartItems!.isNotEmpty &&
              provider.cart.cartItems!.firstWhere((e) => e.merchantId.toString() == widget.id, orElse: () => CartItemModel(cartId: -1)).cartId != -1) {
            return GestureDetector(
              onTap: () {
                context.pushNamed(CartScreen.route);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                color: AppColors.baseColor,
                height: 80,
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${provider.cart.cartItems!.length} Item added >',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 15, color: Colors.white),
                    ),
                    // const SizedBox(height: 5),
                    // Text(
                    //   'Add items worth ${AppStrings.inrSymbol}1000 more to get free delivery',
                    //   style: AppStyles.getMediumTextStyle(fontSize: 16, color: Colors.white),
                    // ),
                  ],
                ),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}