import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:orado_customer/services/cart_services.dart'; // Ensure this path is correct
import 'package:orado_customer/services/order_service.dart';
import 'package:orado_customer/services/profile_services.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/address_services.dart';
import '../../../services/order_summary.dart';
import '../../../services/price_summary_service.dart';
import '../../../utilities/debouncer.dart';
import '../../home/presentation/home_screen.dart';
import '../../location/models/address_response_model.dart';
import '../../location/provider/location_provider.dart';
import '../models/cart_model.dart';
import '../models/order_detail_summary_model.dart';
import '../models/order_summary_model.dart' hide Data;
import '../presentation/payment_gateway.dart';

class CartProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Products> _cartItems = [];

  List<Products> get cartItems => _cartItems;

  final TextEditingController cookingInstruction = TextEditingController();
  final TextEditingController deliveryInstruction = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? selectedAddressId;
  String? selectedLatitude;
  String? selectedLongitude;
  String receiverName = "";
  String receiverPhone = "";

  Data? _cartData;

  Data? get cartData => _cartData;

  final _debouncers = <String, Debouncer>{};

  List<Addresses> addresses = [];
  final OrderPriceSummaryService _service = OrderPriceSummaryService();

  OrderPriceSummaryModel? priceSummary;

  Future<void> fetchUserData() async {
    final response = await ProfileServices.fetchProfile();

    if (response?.data != null && response != null) {
      receiverName = response.data?.name ?? "";
      receiverNameController.text = response.data?.name ?? "";
      receiverPhone = response.data?.phone ?? "";
      phoneNumberController.text = response.data?.phone ?? "";
      notifyListeners();
    }
  }

  void updateReceiver(BuildContext context) {
    final name = receiverNameController.text.trim();
    final phone = phoneNumberController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      showSnackBar(context,
          message: "Fields can't be empty", backgroundColor: Colors.red);
      return;
    }

    // Name validation: only alphabets and space, minimum 2 characters
    final nameRegex = RegExp(r"^[a-zA-Z ]{2,}$");
    if (!nameRegex.hasMatch(name)) {
      showSnackBar(context,
          message: "Enter a valid name (only letters, min 2 characters)",
          backgroundColor: Colors.red);
      return;
    }

    // Phone validation: 10 digit number
    final phoneRegex = RegExp(r"^[0-9]{10}$");
    if (!phoneRegex.hasMatch(phone)) {
      showSnackBar(context,
          message: "Enter a valid 10-digit phone number",
          backgroundColor: Colors.red);
      return;
    }

    // Passed validations
    receiverName = name;
    receiverPhone = phone;
    notifyListeners();
    context.pop();
  }

  Future<void> getAllAddress() async {
    toggleLoading();
    try {
      final response = await AddressServices.getAllAddresses();

      if (response != null &&
          response.messageType != null &&
          response.messageType == "success") {
        addresses.clear();
        addresses.addAll(response.addresses ?? []);
      }
    } catch (e) {}

    notifyListeners();

    toggleLoading();
  }

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void changeAddress(
      {required String newAddressId,
      required String latitude,
      required String longitude}) {
    selectedAddressId = newAddressId;
    notifyListeners();
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> getAllCart(BuildContext context) async {
    putLoading(true);
    try {
      var response = await CartServices.getAllCart();
      putLoading(false);

      final products = response.data?.products;

      if (response.messageType == "success" &&
          response.data != null &&
          products != null &&
          products.isNotEmpty) {
        _cartItems.clear();
        _cartItems.addAll(products);
        _cartData = response.data;
        loadInitialPriceSummary(context);
        getAllAddress();
        fetchUserData();
        notifyListeners();
        log("Cart loaded successfully with ${products.length} items.");
      } else if (products == null || products.isEmpty) {
        // Cart is valid but empty
        _cartItems.clear();
        _cartData = response.data; // can still hold other info like totals = 0
        notifyListeners();
        log("Cart is empty");
      } else {
        // Unexpected failure or unknown response
        _cartItems.clear();
        _cartData = null;
        notifyListeners();
        log("Failed to load cart: ${response.message}");
      }
    } catch (e) {
      putLoading(false);
      _cartItems.clear();
      _cartData = null;
      notifyListeners();
      log("Error fetching cart: $e");
    }
  }

  Future<void> loadInitialPriceSummary(BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    final locationProvider = context.read<LocationProvider>();

    if (context.read<LocationProvider>().selectedAddressId != null) {
      selectedAddressId = context.read<LocationProvider>().selectedAddressId;
    }

    if (cartProvider.cartData?.cartId == null) {
      log('Cart ID is null, cannot load price summary.');
      return;
    }

    if (selectedLatitude == null && selectedLongitude == null) {
      final location = await locationProvider.currentLocationLatLng;
      if (location != null) {
        selectedLatitude = location.latitude.toString();
        selectedLongitude = location.longitude.toString();
      } else {
        log("Unable to fetch current location for price summary.");
        showSnackBar(context,
            message: "Unable to fetch current location for price summary",
            backgroundColor: Colors.red);
        return;
      }
    }

    await cartProvider.loadPriceSummary(
      longitude: selectedLongitude!,
      latitude: selectedLatitude!,
      cartId: cartProvider.cartData!.cartId!,
    );
    notifyListeners();
  }

  void addToCart(
      {required String restaurantId,
      required String productId,
      required int quantity,
      required BuildContext context}) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.productId == productId);

    if (!_debouncers.containsKey(productId)) {
      _debouncers[productId] =
          Debouncer(delay: const Duration(milliseconds: 900));
    }

    // Immediately update the UI for responsiveness
    if (quantity <= 0) {
      if (existingIndex != -1) _cartItems.removeAt(existingIndex);
    } else if (existingIndex != -1) {
      final current = _cartItems[existingIndex];
      _cartItems[existingIndex] = current.copyWith(quantity: quantity);
    } else {
      _cartItems.add(Products(
        productId: productId,
        quantity: quantity,
      ));
    }
    notifyListeners();

    _debouncers[productId]!.debounce(() async {
      log("Debounced API call for product $productId with quantity $quantity initiated.");
      log("  Restaurant ID: $restaurantId");
      log("  Product ID: $productId");
      log("  Quantity: $quantity");

      try {
        final response = await CartServices.addToCart(requestBody: {
          "restaurantId": restaurantId,
          "products": [
            {"productId": productId, "quantity": quantity}
          ]
        });
        log("Add to cart API response: ${response.message}");
      } catch (e) {
        log("Error in addToCart service: $e");
      }

      await getAllCart(context);
      notifyListeners();
      loadInitialPriceSummary(context);
      log("Debounced API call for product $productId with quantity $quantity completed (and cart refreshed).");
    });
  }

  Future<void> loadPriceSummary({
    required String longitude,
    required String latitude,
    required String cartId,
  }) async {
    putLoading(true);

    notifyListeners();

    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ensure key matches saved token

    if (token == null) {
      log("Token not found in SharedPreferences");
      putLoading(false);
      notifyListeners();
      return;
    }

    final result = await _service.fetchPriceSummary(
      token: token,
      longitude: longitude,
      latitude: latitude,
      cartId: cartId,
    );

    if (result != null) {
      priceSummary = result;
    }

    putLoading(false);
    notifyListeners();
  }

  Future<void> placeCashOnDeliveryOrder({
    required BuildContext context,
  }) async {
    try {
      if (cartData == null || cartData!.cartId == null) {
        showSnackBar(context,
            message: "Cart is empty or invalid.", backgroundColor: Colors.red);
        return;
      }

      if (selectedAddressId == null) {
        showSnackBar(context,
            message: "Please select a delivery address.",
            backgroundColor: Colors.red);
        return;
      }

      final response = await OrderService.placeOrder(
        cartId: cartData!.cartId!,
        addressId: selectedAddressId!,
        paymentMethod: "cash",
      );

      if (response != null &&
          response.message != null &&
          response.orderId != null) {
        showSnackBar(context,
            message: response.message ?? "", backgroundColor: Colors.green);
        context.goNamed(Home.route);
      }
    } catch (e) {
      showSnackBar(context,
          message: "$e", backgroundColor: AppColors.baseColor);
    }
  }

  Future<void> placeRazorpayOrder({
    required BuildContext context,
    required double amount,
  }) async {
    try {
      if (cartData == null || cartData!.cartId == null) {
        showSnackBar(context,
            message: "Cart is empty or invalid.", backgroundColor: Colors.red);
        return;
      }

      if (selectedAddressId == null) {
        showSnackBar(context,
            message: "Please select a delivery address.",
            backgroundColor: Colors.red);
        return;
      }

      final profileModel = await ProfileServices.fetchProfile();

      // Place order
      final response = await OrderService.placeOrder(
        cartId: cartData!.cartId!,
        addressId: selectedAddressId!,
        paymentMethod: "online",
      );

      if (response == null || response.orderId == null) {
        showSnackBar(context,
            message: "Failed to Place Order", backgroundColor: Colors.red);
        return;
      }

      // Show Razorpay UI
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RazorpayPaymentScreen(
            amount: amount,
            email: profileModel!.data!.email!,
            phone: profileModel.data!.phone!,
            orderId: response!.razorpayOrderId!,
            keyId: response.keyId!,
          ),
        ),
      );

      if (result == null || result['success'] != true) {
        showSnackBar(
          context,
          message: result?['message'] ?? "Payment was not completed.",
          backgroundColor: Colors.red,
        );
        return;
      }

      String? razorpayPaymentId = result['paymentId'].toString();
      String? razorpayOrderId = result['orderId'].toString();
      String? razorpaySignature = result['signature'].toString();

      // Verify payment
      if (response?.orderId != null) {
        final paymentResponse = await OrderService.verifyPayment(
          razorpayPaymentId: razorpayPaymentId,
          razorpayOrderId: razorpayOrderId,
          signature: razorpaySignature,
          orderId: response.orderId!,
        );

        if (paymentResponse != null &&
            paymentResponse.messageType == "success") {
          showSnackBar(context,
              message: response.message ?? "", backgroundColor: Colors.green);

          context.goNamed(Home.route);
        }
      }
    } catch (e) {
      showSnackBar(context,
          message: "$e", backgroundColor: AppColors.baseColor);
    }
  }
}
