import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/cart/models/cart_model.dart'
    hide Productstablerelation1;
import 'package:orado_customer/features/cart/presentation/cart_screen.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/merchants/models/product_model.dart';
import 'package:orado_customer/features/merchants/provider/merchant_provider.dart';
import 'package:orado_customer/utilities/placeholders.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common/custom_container.dart';
import '../../../utilities/common/food_listing_card.dart';
import '../../../utilities/common/loading_widget.dart';
import '../../../utilities/utilities.dart';
import '../../user/model/favourite_model.dart';
import '../../user/provider/user_provider.dart';

class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({super.key, this.id, this.query});

  static String route = 'merchant-details';
  final String? id;
  final String? query;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

ValueNotifier<bool> scrollNotifier = ValueNotifier<bool>(true);

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  ScrollController scrollController = ScrollController();
  List<String> filteringOptions = <String>['veg', 'Non-Veg'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final merchantProvider = context.read<MerchantProvider>();
      await merchantProvider.getMerchantDetails(
        restaurantId: widget.id!,
        context: context,
      );
      await merchantProvider.getMenu(restaurantId: widget.id!);
      if (widget.query != null && widget.query!.isNotEmpty) {
        Future.microtask(() {
          if (mounted) {
            merchantProvider.filterMenuItems(widget.query!);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<MerchantProvider>(
          builder: (context, provider, _) {
            return provider.isSearching
                ? AppBar(
                    elevation: 0,
                    backgroundColor: AppColors.baseColor,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_outlined,
                          color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    title: TextField(
                      controller: provider.searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Search food...",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      onChanged: provider.filterMenuItems,
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          provider.searchController.clear();
                          provider.filterMenuItems('');
                        },
                      ),
                    ],
                  )
                : AppBar(
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                    backgroundColor: AppColors.baseColor,
                    title: Text(
                      'Merchant Details',
                      style: AppStyles.getBoldTextStyle(
                          color: Colors.white, fontSize: 14),
                    ),
                    centerTitle: true,
                    actions: <Widget>[
                      InkWell(
                        onTap: () {
                          provider.isSearching = true;
                        },
                        child: const Icon(Icons.search),
                      ),
                      const SizedBox(width: 10),
                      Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                          return userProvider.favourites
                                  .any((fav) => fav.id == widget.id)
                              ? IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    final favItem = FavouriteItem(
                                        id: widget.id!,
                                        name: provider.merchantDetails.first
                                                .data?.name ??
                                            "");

                                    await userProvider.removeFavourite(
                                        widget.id!, context);
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.favorite_outline,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    final favItem = FavouriteItem(
                                        id: widget.id!,
                                        name: provider.merchantDetails.first
                                                .data?.name ??
                                            "");

                                    await userProvider.addFavourite(
                                        favItem, context);
                                  },
                                );
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                  );
          },
        ),
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

            if (provider.merchantDetails.isEmpty &&
                provider.menuItems.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final data = provider.merchantDetails.first;
            return SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 2.5,
                        width: MediaQuery.sizeOf(context).width,
                        child: CachedNetworkImage(
                          imageUrl:
                              data.data?.image ?? PlaceHolders.restaurantImage,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height / 3.5),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 30),
                                          Center(
                                            child: Text(
                                              data.data?.name ?? '',
                                              style: AppStyles.getBoldTextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Center(
                                            child: Text(
                                              data.data?.address?.street ?? '',
                                              style:
                                                  AppStyles.getMediumTextStyle(
                                                      fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Align(
                                            child: InkWell(
                                                onTap: () {
                                                  //! context.pushNamed(AppPaths.reviewScreen);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      data.data?.rating
                                                              .toString() ??
                                                          "",
                                                      style: AppStyles
                                                          .getBoldTextStyle(
                                                        color: Colors
                                                            .green.shade600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Icon(
                                                      Icons.star,
                                                      size: 12,
                                                      color:
                                                          Colors.green.shade600,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text('81 ratings',
                                                        style: AppStyles
                                                            .getRegularTextStyle(
                                                                fontSize: 12)),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              const Icon(Icons.timer_outlined,
                                                  size: 14),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${data.data?.estimatedDeliveryTime} mins . ${data.data?.distanceKm}',
                                                style: AppStyles
                                                    .getMediumTextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            height: 60,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            decoration: const BoxDecoration(),
                                            child: ListView.builder(
                                              itemCount:
                                                  filteringOptions.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder:
                                                  (BuildContext c, int i) {
                                                final option =
                                                    filteringOptions[i];
                                                final isActive =
                                                    provider.activeFilter ==
                                                        option;

                                                return InkWell(
                                                  onTap: () => provider
                                                      .toggleFoodTypeFilter(
                                                          option),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 7.0,
                                                          vertical: 3),
                                                      child: Material(
                                                        elevation: 5,
                                                        color: isActive
                                                            ? Colors
                                                                .green.shade100
                                                            : Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          side: BorderSide(
                                                            color: isActive
                                                                ? Colors.green
                                                                : Colors.grey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12.0,
                                                                  vertical: 7),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                option == 'Veg'
                                                                    ? Icons.eco
                                                                    : Icons
                                                                        .set_meal,
                                                                size: 14,
                                                                color: option ==
                                                                        'Veg'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                option,
                                                                style: AppStyles
                                                                    .getBoldTextStyle(
                                                                  fontSize: 15,
                                                                  color: isActive
                                                                      ? (option ==
                                                                              'Veg'
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red)
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              'Recommended',
                                              style: AppStyles
                                                  .getSemiBoldTextStyle(
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          // Replace the FoodsListingCard section with this:
                                          if (provider.menuItems.isEmpty)
                                            // Show empty state when no items match the filter
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 40.0),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons.fastfood_outlined,
                                                        size: 50,
                                                        color: Colors.grey),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'No items found',
                                                      style: AppStyles
                                                          .getMediumTextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          else
                                            FoodsListingCard(
                                              items: provider.menuItems,
                                              restaurantId: widget.id!,
                                            ),

                                          const SizedBox(height: 30),
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
        builder: (context, cartProvider, child) {
          final int totalItems = cartProvider.cartItems.fold(
            0,
            (sum, item) => sum + (item.quantity ?? 0),
          );

          final bool isSameRestaurant = cartProvider.restaurantId == widget.id;

          // Hide the bar if no items OR restaurant doesn't match
          if (totalItems == 0 || !isSameRestaurant) {
            return const SizedBox.shrink();
          }

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
                    '$totalItems Items added >',
                    style: AppStyles.getSemiBoldTextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
