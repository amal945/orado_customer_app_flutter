import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/location/models/address_response_model.dart';
import 'package:orado_customer/features/location/presentation/map_screen.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';
import 'package:orado_customer/utilities/placeholders.dart';
import 'package:provider/provider.dart';
import '../../../utilities/common/custom_button.dart';
import '../../../utilities/common/custom_dialog.dart';
import '../../../utilities/common/custom_ui.dart';
import '../../../utilities/common/text_formfield.dart';
import '../../../utilities/debouncer.dart';
import '../../../utilities/orado_icon_icons.dart';
import '../../../utilities/utilities.dart';
import 'package:orado_customer/services/order_service.dart';

import '../../home/presentation/home_screen.dart'; // Unused import, consider removing

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static String route = 'cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Debouncer deboucer = Debouncer(delay: const Duration(milliseconds: 700));
  int paymentMethod = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CartProvider>().getAllCart(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
      PopScope(
        onPopInvokedWithResult: (didPop, result) {
          final router = GoRouter.of(context);

          if (router.canPop()) {
            router.pop();
          } else {
            context.goNamed('home'); // or context.go('/home')
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                final router = GoRouter.of(context);

                if (router.canPop()) {
                  router.pop();
                } else {
                  context.goNamed('home'); // or context.go('/home')
                }
              },
              icon: const Icon(
                Icons.keyboard_arrow_left_outlined,
                size: 37,
              ),
            ),
            title: Text(
              "Cart",
              style: AppStyles.getSemiBoldTextStyle(
                  fontSize: 19, color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.baseColor,
          ),
          body: Consumer<CartProvider>(
            builder: (
              context,
              cartProvider,
              _,
            ) {
              if (cartProvider.isOrderPlacing) {
                return BuildLoadingWidget(
                    withCenter: true, color: AppColors.baseColor);
              }

              if (cartProvider.cartItems.isEmpty) {
                return Center(
                  child: Text(
                    "You haven't added any item",
                    style: AppStyles.getSemiBoldTextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              final summary = cartProvider.priceSummary?.data;
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
                                if (paymentMethod == 0) {
                                  cartProvider.placeRazorpayOrder(
                                      context: context, amount: grandTotal);
                                } else {
                                  cartProvider.placeCashOnDeliveryOrder(
                                      context: context);
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
                                                style: AppStyles
                                                    .getMediumTextStyle(
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
                        item.name ?? "",
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
                              image: CachedNetworkImageProvider(
                                (item.images != null && item.images!.isNotEmpty)
                                    ? item.images!.first
                                    : PlaceHolders.productImage,
                              ),
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
                              onTap: ()async {
                                final newQuantity = item.quantity! - 1;

                                if (newQuantity >= 0) {
                                  cartProvider.addToCart(
                                      restaurantId:
                                          cartProvider.cartData!.restaurantId!,
                                      productId: item.productId!,
                                      quantity: newQuantity,
                                      context: context);


                                }
                                // If quantity < 1, do nothing — prevent from going below 1
                                context
                                    .read<CartProvider>()
                                    .loadInitialPriceSummary(context);
                              },
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.quantity.toString(),
                              style: AppStyles.getMediumTextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                final newQuantity = item.quantity! + 1;

                                cartProvider.addToCart(
                                    restaurantId:
                                        cartProvider.cartData!.restaurantId!,
                                    productId: item.productId!,
                                    quantity: newQuantity,
                                    context: context);

                                context
                                    .read<CartProvider>()
                                    .loadInitialPriceSummary(context);
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
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
                      onPressed: () =>
                          onTapCookingInstructios(context, cartProvider),
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
                                'Delivery ${15} mins',
                                style:
                                    AppStyles.getMediumTextStyle(fontSize: 12),
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
                              cartProvider.addresses
                                      .firstWhere(
                                        (address) =>
                                            address.addressId ==
                                            cartProvider.selectedAddressId,
                                        orElse: () => Addresses(),
                                      )
                                      .addressString ??
                                  context
                                      .read<LocationProvider>()
                                      .currentLocationAddress ??
                                  "Failed fetch Location",
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
                              onPressed: () => onTapdeliveryInstructios(
                                  context, cartProvider),
                              label: Text(
                                'Add instructions for delivery partner',
                                style:
                                    AppStyles.getMediumTextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            onTap: () =>
                                onTapRecieverDetails(context, cartProvider),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              size: 25,
                              color: AppColors.baseColor,
                            ),
                            leading: const Icon(OradoIcon.phone, size: 15),
                            title: Text(
                              '${cartProvider.receiverName} ${cartProvider.receiverPhone}',
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
          ),
        ),
      ),
    );
  }

  void onTapTotalBill(BuildContext context, CartProvider provider) async {
    final orderController = Provider.of<CartProvider>(context, listen: false);

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

  void onTapRecieverDetails(BuildContext context, CartProvider provider) {
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
            controller: provider.receiverNameController,
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
            controller: provider.phoneNumberController,
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
        CustomButton().showColouredButton(
            label: 'SUBMIT',
            onPressed: () {
              provider.updateReceiver(context);
            }),
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
    // Fetch addresses when dialog opens
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
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
        Consumer<CartProvider>(
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
                String lat = address.location!.latitude.toString();
                String long = address.location!.longitude.toString();

                return Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: RadioListTile<String>(
                      value: id,
                      groupValue: cartProvider.selectedAddressId,
                      onChanged: (String? value) {
                        if (value != null) {
                          provider.changeAddress(
                              newAddressId: value,
                              latitude: lat,
                              longitude: long);
                        }

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
