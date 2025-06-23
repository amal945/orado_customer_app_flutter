import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/common/loading_widget.dart';
import '../../../utilities/styles.dart';
import '../../location/provider/location_provider.dart';
import '../provider/map_provider.dart';

class MapScreen extends StatefulWidget {
  final String? lat;
  final String? long;
  final String? address;

  const MapScreen({super.key, this.lat, this.long, this.address});

  static const String route = 'map-screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.lat == null && widget.long == null && widget.address == null) {
        context.read<LocationProvider>().getCurrentLocation(context);
      } else {
        context.read<LocationProvider>().setLatLongAndAddress(
              latitude: double.parse(widget.lat!),
              longitude: double.parse(widget.long!),
              address: null,
            );
      }

      _onLocationChanged(
          context.read<LocationProvider>().currentLocationLatLng!);
    });
    super.initState();
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
    return "Address not found";
  }

  void _onLocationChanged(LatLng newLatLng) async {
    setState(() {
      _selectedLatLng = newLatLng;
    });
    String address = await _getAddressFromLatLng(newLatLng);
    _showLocationBottomSheet(address);
  }

  void _showLocationBottomSheet(String address) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showAddressFormSheet(address);
                },
                child: Text('CONFIRM LOCATION',
                    style: AppStyles.getBoldTextStyle(
                        fontSize: 14, color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddressFormSheet(String address) {
    // final houseController = TextEditingController();
    // final areaController = TextEditingController();
    // final directionController = TextEditingController();
    // final receiverPhoneController = TextEditingController();
    // final receiverNameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 16,
          ),
          child: Consumer<MapScreenProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "A detailed address will help our Delivery Partner reach your doorstep easily",
                      style: TextStyle(color: Colors.orange, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: provider.houseController,
                      decoration: const InputDecoration(
                        labelText: "House / Flat / Floor No.",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: provider.areaController,
                      decoration: const InputDecoration(
                        labelText: "Apartment / Road / Area",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: provider.directionController,
                      decoration: const InputDecoration(
                        hintText: "e.g. Ring the bell on the red gate",
                        labelText: "Directions to reach (Optional)",
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 200,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: provider.tags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(tag),
                              selected: provider.selectedTag == tag,
                              onSelected: (_) {
                                provider.selectTag(tag);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (provider.selectedTag == 'Home') ...[
                      TextField(
                        controller: provider.receiverPhoneController,
                        decoration: const InputDecoration(
                          labelText: "Optional phone number",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                    ] else if (provider.selectedTag != null) ...[
                      TextField(
                        controller: provider.receiverNameController,
                        decoration: const InputDecoration(
                          labelText: "Receiver name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: provider.receiverPhoneController,
                        decoration: const InputDecoration(
                          labelText: "Receiver phone number",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {},
                        child: Text("SAVE ADDRESS",
                            style: AppStyles.getBoldTextStyle(
                                fontSize: 14, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Select delivery location",
            style: AppStyles.getBoldTextStyle(fontSize: 15)),
        centerTitle: true,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, provider, _) {
          if (provider.isloading || provider.currentLocationLatLng == null) {
            return BuildLoadingWidget(
              withCenter: true,
              color: AppColors.baseColor,
            );
          }

          _selectedLatLng ??= provider.currentLocationLatLng;

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLatLng!,
                  zoom: 15,
                ),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: {
                  Marker(
                    markerId: const MarkerId("selectedLocation"),
                    position: _selectedLatLng!,
                    draggable: true,
                    onDragEnd: _onLocationChanged,
                  ),
                },
                onTap: _onLocationChanged,
                onMapCreated: (controller) => _mapController = controller,
              ),
              Positioned(
                left: 20,
                right: 20,
                top: 20,
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: controller,
                  googleAPIKey: googleMapApiKey,
                  itemClick: (prediction) {
                    FocusScope.of(context).unfocus();
                    controller.text = prediction.description ?? "";
                  },
                  getPlaceDetailWithLatLng: (placeDetail) {
                    final lat = placeDetail.lat;
                    final lng = placeDetail.lng;

                    if (lat != null && lng != null) {
                      final newLatLng =
                          LatLng(double.parse(lat), double.parse(lng));
                      _onLocationChanged(newLatLng);

                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: newLatLng,
                            zoom: 15,
                          ),
                        ),
                      );
                    }
                  },
                  formSubmitCallback: () {
                    FocusScope.of(context).unfocus();
                  },
                  clearData: () async {
                    controller.clear();
                    await provider.getCurrentLocation(context);
                  },
                  containerHorizontalPadding: 0,
                  boxDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  inputDecoration: const InputDecoration(
                    hintText: "Search for a building, street name or area",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
