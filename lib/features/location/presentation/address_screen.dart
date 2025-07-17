import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/common/custom_delete_snackbar.dart';
import '../../../utilities/common/shimmer_address_listtile.dart';
import '../../../utilities/styles.dart';
import '../../../utilities/utilities.dart';
import '../../location/provider/location_provider.dart';
import '../models/address_response_model.dart';
import '../provider/address_provider.dart';
import 'map_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  static const String route = 'address';

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController controller = TextEditingController();
  final Map<String, IconData> addressIcons = {
    "home": Icons.home_outlined,
    "work": Icons.work_outline,
    "other": Icons.location_pin
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final addressProvider = context.read<AddressProvider>();
      final locationProvider = context.read<LocationProvider>();

      await addressProvider.getAllAddress();

      if (locationProvider.currentLocationLatLng == null &&
          locationProvider.currentLocationAddress == null) {
        await locationProvider.getCurrentLocation(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final locationProvider = context.watch<LocationProvider>();

    final scaffold = Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          "Enter your area or apartment name",
          style: AppStyles.getBoldTextStyle(fontSize: 15),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),

                /// Google Places Search
                GooglePlaceAutoCompleteTextField(
                  textEditingController: controller,
                  googleAPIKey: googleMapApiKey,
                  itemClick: (prediction) {
                    FocusScope.of(context).unfocus();
                    controller.text = prediction.description ?? "";
                  },
                  getPlaceDetailWithLatLng: (placeDetail) async {
                    final lat = placeDetail.lat;
                    final lng = placeDetail.lng;

                    if (lat != null && lng != null) {
                      await locationProvider.setLatLongAndAddress(
                        latitude: double.parse(lat),
                        longitude: double.parse(lng),
                        address: placeDetail.description ?? "",
                      );
                    }

                    context.pop();
                  },
                  formSubmitCallback: () => FocusScope.of(context).unfocus(),
                  clearData: () => controller.clear(),
                  containerHorizontalPadding: 20,
                  boxDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  inputDecoration: InputDecoration(
                    hintText: "Search Places",
                    hintStyle: AppStyles.getSemiBoldTextStyle(fontSize: 15),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),

                const SizedBox(height: 16),

                /// Use current location
                ListTile(
                  leading: Icon(Icons.my_location, color: AppColors.baseColor),
                  title: Text("Use my current location",
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 15)),
                  onTap: () async {
                    addressProvider.toggleLoading();
                    await context
                        .read<LocationProvider>()
                        .getCurrentLocation(context);
                    addressProvider.toggleLoading();
                    context.pop();
                  },
                ),

                /// Add new address
                ListTile(
                  leading: Icon(Icons.add, color: AppColors.baseColor),
                  title: Text("Add new address",
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 15)),
                  onTap: () async {
                    addressProvider.toggleLoading();
                    await context
                        .read<LocationProvider>()
                        .getCurrentLocation(context);
                    addressProvider.toggleLoading();
                    context.pushNamed(MapScreen.route);
                  },
                ),

                const Divider(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: Text("SAVED ADDRESSES",
                      style: AppStyles.getBoldTextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 8),

                /// Saved addresses
                Expanded(child:
                    Consumer<AddressProvider>(builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return ListView.builder(
                      itemCount: 3,
                      itemBuilder: (_, __) => const ShimmerAddressTile(),
                    );
                  } else if (provider.addresses.isEmpty) {
                    return Center(
                      child: Text(
                        "You haven't added any address",
                        style: AppStyles.getSemiBoldTextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.addresses.length,
                    itemBuilder: (_, index) {
                      final data = addressProvider.addresses[index];
                      final latlng = LatLng(
                          data.location!.latitude!, data.location!.longitude!);
                      return GestureDetector(
                        onTap: () {
                          addressProvider.setLatLongAddress(
                              context: context,
                              latlng: latlng,
                              address: data.addressString!,
                              addressId: data.addressId!);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            addressIcons[data.type?.toLowerCase() ?? "other"],
                            color: Colors.grey[800],
                          ),
                          title: Text(
                            data.displayName ?? "",
                            style: AppStyles.getBoldTextStyle(fontSize: 15),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "${data.street}, ${data.city}, ${data.state}",
                              style: AppStyles.getSemiBoldTextStyle(
                                  fontSize: 15, color: Colors.grey),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              showAddressBottomSheet(context, data, latlng);
                            },
                          ),
                        ),
                      );
                    },
                  );
                })),
              ],
            ),
          ),
        ],
      ),
    );

    return Stack(
      children: [
        scaffold,
        if (addressProvider.isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: BuildLoadingWidget(
                color: AppColors.baseColor,
                withCenter: true,
              ),
            ),
          ),
      ],
    );
  }

  void showAddressBottomSheet(
      BuildContext context, Addresses data, LatLng latlng) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  text: "${data.displayName} ",
                  style: AppStyles.getBoldTextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: "| ${data.street}, ${data.city}, ${data.state}",
                      style: AppStyles.getBoldTextStyle(
                          fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(
                        MapScreen.route,
                        extra: {
                          'lat': latlng.latitude.toString(),
                          'long': latlng.longitude.toString(),
                          'address': 'Bangalore, India',
                          'currentAddress': data,
                          // <- Your `Addresses` instance
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit, size: 22),
                          const SizedBox(width: 12),
                          Text('Edit',
                              style:
                                  AppStyles.getSemiBoldTextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      showDeleteConfirmationDialog(context, onDelete: () async {
                        await context.read<AddressProvider>().deleteAddress(
                            context: context, restaurantId: data.addressId!);
                        Navigator.pop(context);
                      },
                          message:
                              "Are you sure you want to delete this address");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete, size: 22, color: Colors.red),
                          const SizedBox(width: 12),
                          Text('Delete',
                              style: AppStyles.getSemiBoldTextStyle(
                                  fontSize: 18, color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
