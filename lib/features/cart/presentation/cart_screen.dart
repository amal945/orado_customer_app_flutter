import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/cart/presentation/order_status_screen.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/cart/provider/order_price_summary_controller.dart';
import 'package:orado_customer/features/cart/provider/order_provider.dart';
import 'package:orado_customer/features/location/presentation/address_screen.dart'; // Unused import, consider removing
import 'package:orado_customer/features/location/presentation/map_screen.dart';
import 'package:orado_customer/features/location/provider/address_provider.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart'; // Unused import, consider removing
import 'package:orado_customer/utilities/common/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common/custom_button.dart';
import '../../../utilities/common/custom_dialog.dart';
import '../../../utilities/common/custom_ui.dart';
import '../../../utilities/common/scaffold_builder.dart'; // Unused import, consider removing
import '../../../utilities/common/text_formfield.dart';
import '../../../utilities/debouncer.dart';
import '../../../utilities/orado_icon_icons.dart';
import '../../../utilities/utilities.dart';
import 'package:orado_customer/services/order_service.dart'; // Unused import, consider removing

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static String route = 'cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Debouncer deboucer = Debouncer(delay: const Duration(milliseconds: 700));
  int paymentMethod = 1; // 0 for Razorpay, 1 for Cash on Delivery

  // Added to keep track of the selected address ID
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().getAllCart();
      context.read<CartProvider>().loadInitialPriceSummary(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, OrderPriceSummaryController>(
      builder: (context, cartProvider, orderPriceSummaryController, _) {
        final summary = orderPriceSummaryController.priceSummary?.data;
        double grandTotal = double.tryParse(summary?.total ?? '0') ?? 0;

        return CustomUi(
          gap: 0,
          actions: <Widget>[
            Transform.flip(
              flipX: true,
              child: const Icon(Icons.reply_sharp),
            ),
            const SizedBox(width: 10),
          ],
          title: 'Cart',
          bottomNavigationBar: Card(
            elevation: 18,
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => onTapPaymentMethod(
                          (int? value) {
                            paymentMethod = value!;
                            setState(() {});
                            context.pop();
                          },
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Row(
                              children: <Widget>[
                                Text('Pay using'),
                                Icon(Icons.keyboard_arrow_up_outlined),
                              ],
                            ),
                            Text(paymentMethod == 0
                                ? 'Razorpay'
                                : 'Cash on Delivery'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: AppColors.baseColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (cartProvider.cartData == null ||
                              cartProvider.cartData!.cartId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Cart is empty or invalid.")),
                            );
                            return;
                          }

                          if (_selectedAddressId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please select a delivery address.")),
                            );
                            return;
                          }

                          // Call placeOrder and await the orderId
                          final String? orderId =
                              await PlaceOrderController.placeOrder(
                            context: context,
                            cartId: cartProvider.cartData!.cartId!,
                            addressId: _selectedAddressId!,
                            paymentMethod:
                                paymentMethod == 0 ? "razorpay" : "cash",
                            couponCode: "",
                            // You can add logic for coupon code
                            instructions: cartProvider.cookingInstruction.text +
                                " " +
                                cartProvider.deliveryInstruction.text,
                            tipAmount: 0, // You can add logic for tip amount
                          );

                          // Only navigate if an orderId was successfully returned
                          if (orderId != null) {
                            if (paymentMethod == 1) {
                              // Cash on Delivery - navigate to order status with the orderId
                              context.pushNamed(
                                OrderStatusScreen.route,
                                extra: orderId, // <--- Pass the orderId here
                              );
                            } else {
                              // Razorpay - navigate to online payment screen with the orderId
                              // You'll likely need to pass the orderId to the payment screen as well
                              // context.pushNamed(OnlinePaymentScreen.route, extra: orderId);
                            }
                          } else {
                            // Handle cases where order placement failed and orderId is null
                            log('Order placement failed: orderId is null');
                            // PlaceOrderController.placeOrder already shows an error dialog,
                            // but you can add more specific handling here if needed.
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: cartProvider
                                  .isLoading // Consider if this loading applies to order placement only
                              ? BuildLoadingWidget()
                              : Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        const Text("total cost"),
                                        Text(
                                          '${AppStrings.inrSymbol}${grandTotal.toStringAsFixed(2)}',
                                          style: AppStyles.getMediumTextStyle(
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    const Text('Place order'),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          children: <Widget>[
            ...cartProvider.cartItems!.map(
              (item) => ListTile(
                tileColor: AppColors.baseColor.withValues(alpha: 0.3),
                style: ListTileStyle.list,
                title: Text(
                  item.name!,
                  style: AppStyles.getMediumTextStyle(
                    fontSize: 14,
                  ),
                ),
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(item.images!.first!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                subtitle: Text('${AppStrings.inrSymbol}${item.price}',
                    style: AppStyles.getBoldTextStyle(fontSize: 14)),
                trailing: Container(
                  height: 35,
                  width: 85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.baseColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          if (item.quantity! > 1) {
                            setState(() => item.quantity = item.quantity! - 1);
                          }
                          deboucer.debounce(() {
                            if (item.quantity! < 1) {
                              // cartProvider.deleteFromCart(context, itemId: item.cartId.toString());
                            } else {
                              // cartProvider.updateItemInCart(context, itemId: item.cartId.toString(), quantity: item.quantity!);
                            }
                            context.read<CartProvider>().loadInitialPriceSummary(
                                context); // Recalculate summary after cart update
                          });
                        },
                        child: const Icon(
                            size: 16, Icons.remove, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.quantity.toString(),
                        style: AppStyles.getMediumTextStyle(
                            fontSize: 13, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() => item.quantity = item.quantity! + 1);
                          deboucer.debounce(() {
                            // cartProvider.updateItemInCart(context, itemId: item.cartId.toString(), quantity: item.quantity!);
                            context.read<CartProvider>().loadInitialPriceSummary(
                                context); // Recalculate summary after cart update
                          });
                        },
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.topLeft,
              child: ActionChip(
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey),
                ),
                labelPadding: EdgeInsets.zero,
                onPressed: () => onTapCookingInstructios(context, cartProvider),
                label: Text(
                  'Add cooking requests',
                  style: AppStyles.getMediumTextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/offer.png', height: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Restaurant coupon available',
                      style: AppStyles.getMediumTextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.alarm, size: 17),
                        const SizedBox(width: 10),
                        Text(
                          'Delivery in  mins',
                          style: AppStyles.getMediumTextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    ListTile(
                      dense: true,
                      onTap: () => onTapDeliveryAddress(context),
                      visualDensity: VisualDensity.comfortable,
                      leading: const Icon(
                        OradoIcon.home_outlined,
                        size: 18,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: 25,
                        color: AppColors.baseColor,
                      ),
                      title: Text(
                        'Delivery',
                        style: AppStyles.getMediumTextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        context
                                .watch<LocationProvider>()
                                .currentLocationAddress ??
                            '',
                        style: AppStyles.getMediumTextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      child: ActionChip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: AppColors.greycolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        labelPadding: EdgeInsets.zero,
                        onPressed: () =>
                            onTapdeliveryInstructios(context, cartProvider),
                        label: Text(
                          'Add instructions for delivery partner',
                          style: AppStyles.getMediumTextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      onTap: () => onTapRecieverDetails(context),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: 25,
                        color: AppColors.baseColor,
                      ),
                      leading: const Icon(OradoIcon.phone, size: 15),
                      title: Text(
                        'Ragendhu rajan +917885412486',
                        style: AppStyles.getMediumTextStyle(fontSize: 13),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      onTap: () => onTapTotalBill(context, cartProvider),
                      leading: const Icon(OradoIcon.orders),
                      title: Text(
                          'Total Bill ${AppStrings.inrSymbol}${grandTotal.toStringAsFixed(2)}'),
                      subtitle: const Text('Including All Taxes'),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: 25,
                        color: AppColors.baseColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void onTapTotalBill(BuildContext context, CartProvider provider) async {
    final orderController =
        Provider.of<OrderPriceSummaryController>(context, listen: false);

    final location =
        await context.read<LocationProvider>().currentLocationLatLng;

    if (location == null ||
        location.latitude == null ||
        location.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to fetch current location")),
      );
      return;
    }

    final latitude = location.latitude.toString();
    final longitude = location.longitude.toString();

    // Ensure cartData and cartId are not null before calling loadPriceSummary
    if (provider.cartData == null || provider.cartData!.cartId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cart data is not available.")),
      );
      return;
    }

    await orderController.loadPriceSummary(
      longitude: longitude,
      latitude: latitude,
      cartId: provider.cartData!.cartId!,
    );

    final summary = orderController.priceSummary?.data;

    if (summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load bill summary")),
      );
      return;
    }

    double itemTotal = double.tryParse(summary.subtotal ?? '0') ?? 0;
    double deliveryFee = double.tryParse(summary.deliveryFee ?? '0') ?? 0;
    double grandTotal = double.tryParse(summary.total ?? '0') ?? 0;

    CustomDialogue().showCustomDialogue(
      context: context,
      content: <Widget>[
        Text(
          'Bill Summary',
          style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
        ),
        const SizedBox(height: 14),
        Card(
          color: Colors.grey.shade50,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                buidItems(
                    title: 'Item total', amt: itemTotal.toStringAsFixed(2)),
                ...?summary.taxes?.map(
                  (e) => buidItems(
                    title: e.name ?? '',
                    amt: e.amount ?? '0.00',
                  ),
                ),
                buidItems(
                  title: 'Delivery partner fee',
                  amt: deliveryFee.toStringAsFixed(2),
                  subtitle: 'goes to them for their time and effort',
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  horizontalTitleGap: 2,
                  title: Text('Grand Total',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 13)),
                  trailing: Text(
                    '${AppStrings.inrSymbol}${grandTotal.toStringAsFixed(2)}',
                    style: AppStyles.getMediumTextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void onTapPaymentMethod(ValueChanged<int?>? onChanged) {
    CustomDialogue().showCustomDialogue(
      context: context,
      content: [
        Text(
          'Select a payment method',
          style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
        ),
        const SizedBox(
          height: 14,
        ),
        RadioListTile<int>.adaptive(
          value: 0,
          groupValue: paymentMethod,
          onChanged: onChanged,
          title: const Text('RazorPay'),
        ),
        RadioListTile<int>.adaptive(
          value: 1,
          groupValue: paymentMethod,
          onChanged: onChanged,
          title: const Text('Cash On Delivery'),
        ),
      ],
    );
  }

  void onTapRecieverDetails(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    CustomDialogue().showCustomDialogue(
      context: context,
      content: <Widget>[
        Text(
          'Update Reciever Details',
          style: AppStyles.getRegularTextStyle(fontSize: 17),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BuildTextFormField(
            controller: nameController,
            hint: 'Name',
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BuildTextFormField(
            controller: nameController,
            hint: 'Contact',
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        CustomButton().showColouredButton(label: 'SUBMIT', onPressed: () {}),
      ],
    );
  }

  void onTapCookingInstructios(
      BuildContext context, CartProvider cartProvider) {
    CustomDialogue().showCustomDialogue(context: context, content: <Widget>[
      Text(
        'Cooking instructions for restaurant',
        style: AppStyles.getRegularTextStyle(fontSize: 17),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: BuildTextFormField(
          controller: cartProvider.cookingInstruction,
          hint: 'Write here',
          maxLines: 5,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(
        height: 25,
      ),
      CustomButton().showColouredButton(
          label: 'Save',
          onPressed: () {
            context.pop(); // Close the dialog after saving
          }),
    ]);
  }

  void onTapdeliveryInstructios(
      BuildContext context, CartProvider cartProvider) {
    CustomDialogue().showCustomDialogue(
      context: context,
      content: <Widget>[
        Text(
          'Instructions for delivery Partner',
          style: AppStyles.getRegularTextStyle(fontSize: 17),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BuildTextFormField(
            controller: cartProvider.deliveryInstruction,
            hint: 'Write here',
            maxLines: 5,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        CustomButton().showColouredButton(
            label: 'Save',
            onPressed: () {
              context.pop(); // Close the dialog after saving
            }),
      ],
    );
  }

  Widget buidItems(
      {required String title, required String amt, String? subtitle}) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: AppStyles.getMediumTextStyle(fontSize: 13),
            ),
            Text(
              '${AppStrings.inrSymbol}$amt',
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: AppStyles.getMediumTextStyle(fontSize: 13),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            subtitle ?? '',
            style: AppStyles.getMediumTextStyle(
                fontSize: 11, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  void onTapDeliveryAddress(BuildContext context) {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    addressProvider.getAllAddress(); // Fetch addresses when dialog opens

    CustomDialogue().showCustomDialogue(
      context: context,
      content: [
        Text(
          'Select an address',
          style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () => context.pushNamed(MapScreen.route),
          child: Card(
            color: Colors.grey.shade50,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Icon(Icons.add, color: AppColors.baseColor),
                  const SizedBox(width: 8),
                  Text('Add Address',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 14)),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_right_outlined,
                      color: AppColors.baseColor),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text('Saved Address',
            style: AppStyles.getSemiBoldTextStyle(fontSize: 14)),
        const SizedBox(height: 10),
        Consumer<AddressProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.addresses.isEmpty) {
              return const Text('No addresses found.');
            }

            return Column(
              children: provider.addresses.map((address) {
                final id = address.addressId ?? '';

                return Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: RadioListTile<String>(
                      value: id,
                      groupValue: _selectedAddressId,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedAddressId = value;
                        });
                        log('Selected Address ID: $_selectedAddressId');
                        context.pop(); // Close the dialog after selection
                        context.read<CartProvider>().loadInitialPriceSummary(
                            context); // Recalculate summary after address selection
                      },
                      title: Text(
                        address.displayName?.toUpperCase() ?? 'NO TITLE',
                        style: AppStyles.getSemiBoldTextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        address.addressString ?? '',
                        style: AppStyles.getMediumTextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
