import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/services/cart_services.dart'; // Ensure this path is correct
import 'package:orado_customer/services/order_service.dart';
import 'package:orado_customer/services/profile_services.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/address_services.dart';
import '../../../services/coupon_services.dart';
import '../../../services/loyalty_services.dart';
import '../../../services/price_summary_service.dart';
import '../../../utilities/debouncer.dart';
import '../../home/presentation/home_screen.dart';
import '../../location/models/address_response_model.dart';
import '../../location/provider/location_provider.dart';
import '../../profile/model/loyalty_rules_model.dart';
import '../models/cart_model.dart';
import '../models/coupons_response_model.dart';
import '../models/order_summary_model.dart' hide Data;
import '../presentation/payment_gateway.dart';

class CartProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool _heavyLoading = false;

  bool _isCouponLoading = false;

  bool _isApplyingCoupon = false;

  List<Products> _cartItems = [];
  Data? _cartData;
  OrderPriceSummaryModel? priceSummary;

  bool isDeliverable = true;

  String deliveryErrorMessage = "";

  String selectedCouponCode = "";

  bool useLoyaltyPoint = false;

  int loyaltyPointsToRedeem = 0;

  final TextEditingController cookingInstruction = TextEditingController();
  final TextEditingController deliveryInstruction = TextEditingController();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController loyaltyPointController = TextEditingController();
  final TextEditingController couponController = TextEditingController();

  final _debouncers = <String, Debouncer>{};
  final _priceService = OrderPriceSummaryService();

  String? selectedAddressId, selectedLatitude, selectedLongitude;
  String receiverName = "", receiverPhone = "", restaurantId = "";
  List<Addresses> addresses = [];

  bool get isLoading => _isLoading;

  bool get heavyLoading => _heavyLoading;

  bool get isCouponLoading => _isCouponLoading;

  bool get isApplyingCoupon => _isApplyingCoupon;

  List<Products> get cartItems => _cartItems;

  Data? get cartData => _cartData;

  List<Coupons> coupons = [];

  Rules? rule;

  int balance = 0;

  void putApplyingCoupon(bool value) {
    _isApplyingCoupon = value;
    notifyListeners();
  }

  void putCouponLoading(bool value) {
    _isCouponLoading = value;
    notifyListeners();
  }

  Future<void> getRules() async {
    putLoading(true);
    try {
      final response = await LoyaltyServices.getLoyaltyPointsRules();

      if (response != null) {
        rule = response.data;
      }
    } catch (e) {
      log("$e");
    }
    putLoading(false);
  }

  Future<void> fetchBalance() async {
    putLoading(true);
    try {
      balance = await LoyaltyServices.getLoyaltyPointsBalance();
    } catch (e) {
      log("$e");
    }
    putLoading(false);
  }

  void toggleLoyaltyPoint() {
    useLoyaltyPoint = !useLoyaltyPoint;
    if (!useLoyaltyPoint) {
      // reset if disabling
      loyaltyPointsToRedeem = 0;
      loyaltyPointController.clear();
      applyLoyaltyPoints();
    }
    notifyListeners();
  }

  Future<void> applyLoyaltyPoints() async {
    final ruleLocal = rule;
    if (ruleLocal == null) return;

    final subtotal = double.tryParse(priceSummary?.data?.total ?? '0') ?? 0;
    final minPoints = ruleLocal.minPointsForRedemption ?? 0;
    final maxPercent = ruleLocal.maxRedemptionPercent ?? 0;
    final valuePerPoint = ruleLocal.valuePerPoint ?? 1;

    final maxPointsByPercent =
        ((subtotal * maxPercent) / 100) ~/ valuePerPoint; // integer division
    final maxRedeemable =
        balance < maxPointsByPercent ? balance : maxPointsByPercent;

    int enteredPoints = int.tryParse(loyaltyPointController.text.trim()) ?? 0;

    final isValidEntry =
        enteredPoints >= minPoints && enteredPoints <= maxRedeemable;
    final appliedPoints = isValidEntry
        ? enteredPoints
        : (enteredPoints > maxRedeemable ? maxRedeemable : 0);

    loyaltyPointsToRedeem = appliedPoints;

    // if nothing to redeem, clear the field to avoid sending stale data
    if (loyaltyPointsToRedeem == 0) {
      loyaltyPointController.text = '';
    } else {
      // keep the controller in sync
      loyaltyPointController.text = loyaltyPointsToRedeem.toString();
    }

    notifyListeners();

    // reload price summary only if prerequisites are present
    if (selectedLatitude != null &&
        selectedLongitude != null &&
        cartData?.cartId != null) {
      await loadPriceSummary(
        longitude: selectedLongitude!,
        latitude: selectedLatitude!,
        cartId: cartData!.cartId!,
      );
    }
  }

  Future<void> setCouponCode(
      {required String code, required BuildContext context}) async {
    putApplyingCoupon(true);
    selectedCouponCode = code;
    final response = await loadPriceSummary(
        longitude: selectedLongitude!,
        latitude: selectedLatitude!,
        cartId: _cartData!.cartId!);
    putApplyingCoupon(false);

    if (response) {
      showSnackBar(context,
          message: "Coupon Applied Successfully",
          backgroundColor: Colors.green);
      selectedCouponCode = code;
    } else {
      selectedCouponCode = "";
      showSnackBar(context,
          message: "Failed to Apply Coupon", backgroundColor: Colors.red);
    }
  }

  Future<void> setCouponCodeFromTextField(
      {required BuildContext context}) async {
    if (couponController.text.isEmpty) {
      showSnackBar(context,
          message: "Please enter a coupon code", backgroundColor: Colors.red);
      return;
    }
    final code = couponController.text.trim();
    setCouponCode(code: code, context: context);
  }

  void removeCouponCode() async {
    putApplyingCoupon(true);
    selectedCouponCode = "";
    await loadPriceSummary(
        longitude: selectedLongitude!,
        latitude: selectedLatitude!,
        cartId: _cartData!.cartId!);
    putApplyingCoupon(false);
  }

  Future<void> getAllCoupons({required String restaurantId}) async {
    putCouponLoading(true);
    final response =
        await CouponServices.getAllCoupons(restaurantId: restaurantId);

    if (response != null && response.coupon != null) {
      coupons.clear();
      coupons.addAll(response.coupon ?? []);
      print(coupons);
    }

    putCouponLoading(false);
  }

  /// ---- Receiver Info ----
  Future<void> fetchUserData() async {
    final response = await ProfileServices.fetchProfile();
    final user = response?.data;
    if (user != null) {
      receiverName = user.name ?? "";
      receiverPhone = user.phone ?? "";
      receiverNameController.text = receiverName;
      phoneNumberController.text = receiverPhone;
      notifyListeners();
    }
  }

  void updateReceiver(BuildContext context) {
    final name = receiverNameController.text.trim();
    final phone = phoneNumberController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      return showSnackBar(context,
          message: "Fields can't be empty", backgroundColor: Colors.red);
    }

    if (!RegExp(r"^[a-zA-Z ]{2,}$").hasMatch(name)) {
      return showSnackBar(context,
          message: "Enter a valid name (only letters, min 2 characters)",
          backgroundColor: Colors.red);
    }

    if (!RegExp(r"^[0-9]{10}$").hasMatch(phone)) {
      return showSnackBar(context,
          message: "Enter a valid 10-digit phone number",
          backgroundColor: Colors.red);
    }

    receiverName = name;
    receiverPhone = phone;
    notifyListeners();
    context.pop();
  }

  /// ---- Address Handling ----
  Future<void> getAllAddress() async {
    toggleLoading();
    try {
      final response = await AddressServices.getAllAddresses();
      if (response?.messageType == "success") {
        addresses = response!.addresses ?? [];
      }
    } finally {
      toggleLoading();
    }
  }

  void changeAddress({
    required String newAddressId,
    required String latitude,
    required String longitude,
  }) {
    selectedAddressId = newAddressId;
    selectedLatitude = latitude;
    selectedLongitude = longitude;
    notifyListeners();
  }

  /// ---- Loading State ----
  void toggleLoading() => putLoading(!_isLoading);

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void putHeavyLoading(bool value) {
    _heavyLoading = value;
    notifyListeners();
  }

  /// ---- Cart Handling ----
  Future<void> getAllCart(BuildContext context) async {
    putHeavyLoading(true);
    try {
      await fetchBalance();
      await getRules();

      final response = await CartServices.getAllCart();
      final products = response.data?.products;

      _cartItems.clear();
      _cartData = response.data;

      if (response.messageType == "success" &&
          products != null &&
          products.isNotEmpty) {
        _cartItems.addAll(products);
        restaurantId = _cartData?.restaurantId ?? "";
        await loadInitialPriceSummary(context);
        await Future.wait([getAllAddress(), fetchUserData()]);
        log("Cart loaded with ${products.length} items.");
      } else {
        log("Cart is empty or invalid.");
      }
    } catch (e) {
      log("Error fetching cart: $e");
    } finally {
      putHeavyLoading(false);
    }
  }

  Future<void> loadInitialPriceSummary(BuildContext context) async {
    final locationProvider = context.read<LocationProvider>();
    selectedAddressId ??= locationProvider.selectedAddressId;

    if (cartData?.cartId == null) {
      log('Cart ID is null, cannot load price summary.');
      return;
    }

    if (selectedLatitude == null || selectedLongitude == null) {
      final location = await locationProvider.currentLocationLatLng;
      if (location != null) {
        selectedLatitude = location.latitude.toString();
        selectedLongitude = location.longitude.toString();
      } else {
        return showSnackBar(context,
            message: "Unable to fetch current location",
            backgroundColor: Colors.red);
      }
    }

    await loadPriceSummary(
      latitude: selectedLatitude!,
      longitude: selectedLongitude!,
      cartId: cartData!.cartId!,
    );
  }

  Future<bool> loadPriceSummary({
    required String longitude,
    required String latitude,
    required String cartId,
  }) async {
    log("Load Price Summary Called");

    putLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return false;

      final result = await _priceService.fetchPriceSummary(
          token: token,
          longitude: longitude,
          latitude: latitude,
          cartId: cartId,
          couponCode: selectedCouponCode.isNotEmpty ? selectedCouponCode : null,
          loyaltyPoints: loyaltyPointController.text.trim().isNotEmpty
              ? loyaltyPointController.text.trim()
              : null);

      if (result != null && result.messageType == "success") {
        priceSummary = result;
        isDeliverable = true;
        deliveryErrorMessage = "";
        return true;
      } else {
        isDeliverable = false;
        deliveryErrorMessage = result?.message ?? "Error can't deliver!";
        return false;
      }
    } finally {
      putLoading(false);
    }
  }

  /// ---- Add to Cart with Debounce ----
  void addToCart({
    required String restaurantId,
    required String productId,
    required int quantity,
    required BuildContext context,
  }) {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    _setupDebouncerIfAbsent(productId);

    if (quantity <= 0 && index != -1) {
      _cartItems.removeAt(index);
    } else if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
    } else {
      this.restaurantId = restaurantId;
      _cartItems.add(Products(
        productId: productId,
        quantity: quantity,
        restaurantId: restaurantId,
      ));
    }
    notifyListeners();

    _debouncers[productId]!.debounce(() async {
      try {
        final response = await CartServices.addToCart(requestBody: {
          "restaurantId": restaurantId,
          "products": [
            {"productId": productId, "quantity": quantity}
          ],
        });
        log("Add to cart response: ${response.message}");
        await loadInitialPriceSummary(context);
      } catch (e) {
        log("Error in addToCart: $e");
      }
    });
  }

  void _setupDebouncerIfAbsent(String productId) {
    _debouncers[productId] ??=
        Debouncer(delay: const Duration(milliseconds: 900));
  }

  /// ---- Order Placement ----
  Future<void> placeCashOnDeliveryOrder({required BuildContext context}) async {
    putLoading(true);
    if (!_validateBeforePlacingOrder(context)) return;

    try {
      final response = await OrderService.placeOrder(
        cartId: cartData!.cartId!,
        addressId: selectedAddressId!,
        paymentMethod: "cash",
      );

      if (response?.orderId != null) {
        showSnackBar(context,
            message: response!.message ?? "", backgroundColor: Colors.green);
        getAllCart(context);
        context.goNamed(Home.route);
      }
    } catch (e) {
      showSnackBar(context,
          message: "Failed to Order", backgroundColor: AppColors.baseColor);
    }
    putLoading(false);
    getAllCart(context);
  }

  Future<void> placeRazorpayOrder({
    required BuildContext context,
  }) async {
    final summary = priceSummary?.data;
    double grandTotal = double.tryParse(summary?.total ?? '0') ?? 0;

    putLoading(true);

    debugPrint('1. Starting placeRazorpayOrder');
    if (!_validateBeforePlacingOrder(context)) {
      debugPrint('2. Validation failed');
      return;
    }

    debugPrint('3. Loading started');

    try {
      debugPrint('4. Fetching profile');
      final profile = await ProfileServices.fetchProfile();
      debugPrint('5. Profile fetched: ${profile != null}');

      debugPrint('6. Placing order');
      final response = await OrderService.placeOrder(
        cartId: cartData!.cartId!,
        addressId: selectedAddressId!,
        paymentMethod: "online",
      );
      debugPrint('7. Order placed: ${response != null}');

      if (response?.orderId == null) {
        putLoading(false);
        debugPrint('8. Order ID is null');

        if (context.mounted) {
          showSnackBar(context,
              message: "Failed to Place Order", backgroundColor: Colors.red);
        }
        return;
      }

      debugPrint('9. Before navigation to Razorpay');
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RazorpayPaymentScreen(
            amount: grandTotal,
            email: profile!.data!.email!,
            phone: profile.data!.phone!,
            orderId: response!.razorpayOrderId!,
            keyId: response.keyId!,
          ),
        ),
      );
      debugPrint('10. Returned from Razorpay: $result');

      if (result == null || result['success'] != true) {
        if (context.mounted) {
          showSnackBar(context,
              message: "Payment was not completed",
              backgroundColor: Colors.red);
        }
        return;
      }

      final verifyResponse = await OrderService.verifyPayment(
        razorpayPaymentId: result['paymentId'],
        razorpayOrderId: result['orderId'],
        signature: result['signature'],
        orderId: response!.orderId!,
      );

      if (verifyResponse?.messageType == "success" && context.mounted) {
        showSnackBar(context,
            message: verifyResponse!.message ?? "",
            backgroundColor: Colors.green);

        getAllCart(context);
        context.goNamed(Home.route);
      }
    } catch (e) {
      debugPrint('ERROR in placeRazorpayOrder: $e');
      if (context.mounted) {
        showSnackBar(context,
            message: "An error occurred during payment",
            backgroundColor: Colors.red);
      }
    } finally {
      putLoading(false);
    }
    putLoading(false);
  }

  bool _validateBeforePlacingOrder(BuildContext context) {
    if (cartData?.cartId == null) {
      showSnackBar(context,
          message: "Cart is empty or invalid", backgroundColor: Colors.red);
      return false;
    }
    if (selectedAddressId == null) {
      showSnackBar(context,
          message: "Please select a delivery address",
          backgroundColor: Colors.red);
      return false;
    }
    return true;
  }
}
