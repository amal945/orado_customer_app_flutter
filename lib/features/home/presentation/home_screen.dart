import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/auth/presentation/get_started_screen.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/home/provider/home_provider.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/merchants/presentation/merchant_detail_screen.dart';
import 'package:orado_customer/utilities/common/scaffold_builder.dart';
import 'package:provider/provider.dart';
import '../../../utilities/common/categories_section.dart';
import '../../../utilities/common/custom_sliver_app_bar.dart';
import '../../../utilities/common/food_tile_card_large.dart';
import '../../../utilities/common/food_tile_card_small.dart';
import '../../../utilities/common/loading_widget.dart';
import '../../../utilities/common/search_field.dart';
import '../../../utilities/utilities.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String route = 'home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int categoryIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      await context.read<HomeProvider>().getHome(context);
      // showOrderStatusBottomSheet(context);
      // simulateSocketStatusUpdates(); // mock live updates
    });
  }

  void simulateSocketStatusUpdates() async {
    for (int i = 0; i < orderStatuses.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _statusIndex = i;
        _bottomSheetSetState?.call(() {}); // trigger UI update
      }
    }
  }

  late HomeProvider homeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeProvider = Provider.of<HomeProvider>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<String> orderStatuses = [
    "Order Placed",
    "Order Confirmed",
    "Order Prepared",
    "Waiting for Pickup",
    "Delivery Partner Assigned",
    "Order Picked Up",
    "On the Way",
    "On Time",
    "Delayed",
    "Nearby",
    "Reaching Your Doorstep"
  ];

  int _statusIndex = 0;
  void Function(VoidCallback)? _bottomSheetSetState;

  void showOrderStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 0.4,
          builder: (_, controller) {
            return StatefulBuilder(
              builder: (context, setState) {
                _bottomSheetSetState = setState;
                final currentStatus = orderStatuses[_statusIndex];

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Live Order Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            color: Colors.blue,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              currentStatus,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String address = 'Fetching...';

  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      route: Home.route,
      body: Consumer<HomeProvider>(builder: (context, provider, _) {
        if (provider.isLoading == true) {
          return BuildLoadingWidget(
              withCenter: true, color: AppColors.baseColor);
        } else {
          return RefreshIndicator.adaptive(
            onRefresh: () async => provider.getHome(context),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                CustomSliverAppBar().showSliverAppBar(context,
                    address: context.watch<LocationProvider>().isloading
                        ? 'Fetching...'
                        : context
                            .watch<LocationProvider>()
                            .currentLocationAddress),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SearchField(
                              isHomePage: true,
                              hintText: 'Find your food',
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                                Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .searchRestaurants(value);
                              },
                            ),
                            if (_searchQuery.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              Align(
                                child: Text(
                                  '${provider.filteredRestaurantList.length} restaurants found',
                                  style: AppStyles.getRegularTextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade700),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    provider.filteredRestaurantList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final data =
                                      provider.filteredRestaurantList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      log('Navigating to MerchantDetailScreen from All Restaurants with Merchant ID: ${data.merchantId}');
                                      context.pushNamed(
                                        MerchantDetailScreen.route,
                                        queryParameters: {
                                          'id': data.merchantId,
                                          // 'query': sea,
                                        },
                                      );
                                    },
                                    child: FoodTileCardLarge(
                                      merchantId: data.merchantId,
                                      name: data.shopName,
                                      distance: data.distance,
                                      image: data.image?.imageName,
                                      productName: data.availableFoods
                                          ?.map((food) => food.name)
                                          .join(', '),
                                    ),
                                  );
                                },
                              ),
                            ] else ...[
                              Card(
                                color: Colors.grey.shade100,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage('assets/images/image.png'),
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Free Delivery For \nNext 3 month',
                                            style: AppStyles.getBoldTextStyle(
                                                fontSize: 17),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Order Now',
                                                style: AppStyles
                                                    .getSemiBoldTextStyle(
                                                        color:
                                                            AppColors.baseColor,
                                                        fontSize: 12),
                                              ),
                                              Icon(
                                                Icons.arrow_right_alt,
                                                color: AppColors.baseColor,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),
                              provider.categoriesData.isNotEmpty &&
                                      provider.categoriesData.first.data
                                              ?.isNotEmpty ==
                                          true
                                  ? CategoriesSection(
                                      categories:
                                          provider.categoriesData.first.data!,
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 20),

                              // const SizedBox(height: 40),
                              // Text(
                              //   'Explore',
                              //   style: AppStyles.getMediumTextStyle(fontSize: 17),
                              // ),
                              // const SizedBox(height: 10),
                              // Card(
                              //   color: Colors.white,
                              //   child: Stack(
                              //     children: <Widget>[
                              //       Align(
                              //         child: Image.asset(
                              //           'assets/images/Mask group.png',
                              //           fit: BoxFit.cover,
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.all(18.0),
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: <Widget>[
                              //             Text(
                              //               'Offers',
                              //               style: AppStyles.getBoldTextStyle(
                              //                   fontSize: 17),
                              //             ),
                              //             const SizedBox(height: 20),
                              //             Row(
                              //               children: <Widget>[
                              //                 Text(
                              //                   'Order Now',
                              //                   style: AppStyles
                              //                       .getSemiBoldTextStyle(
                              //                           color:
                              //                               AppColors.baseColor,
                              //                           fontSize: 16),
                              //                 ),
                              //                 Icon(
                              //                   Icons.arrow_right_alt,
                              //                   color: AppColors.baseColor,
                              //                 )
                              //               ],
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(height: 20),
                              Text(
                                'All Restaurants',
                                style: AppStyles.getBoldTextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Align(
                                child: Text(
                                  '${provider.restaurantList.length} restaurants delivering to you',
                                  style: AppStyles.getRegularTextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade700),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    // provider.homeModel?.topRestaurants?.length ?? 0,

                                    provider.restaurantList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final data = provider.restaurantList[index];
                                  return FoodTileCardLarge(
                                    merchantId: data.merchantId,
                                    name: data.shopName,
                                    distance: data.distance,
                                    image: data.image!.imageName,
                                  );
                                },
                              ),

                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Recommended for you',
                                    style: AppStyles.getBoldTextStyle(
                                      fontSize: 20,
                                    )),
                              ),
                              const SizedBox(height: 20),
                              Visibility(
                                visible: provider.isRecommendedAvailable,
                                child: SizedBox(
                                  height: 266,
                                  child: ListView.builder(
                                    itemCount:
                                        provider.recommendedRestaurants.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext c, int i) {
                                      final data =
                                          provider.recommendedRestaurants[i];
                                      return GestureDetector(
                                        onTap: () {
                                          // context.pushNamed(AppPaths.singleRestaurentScreen);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                          child: FoodTileCardSmall(
                                            image: data.image!.imageName,
                                            name: data.shopName,
                                            distance: data.distance,
                                            time: data.deliveryTime,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
