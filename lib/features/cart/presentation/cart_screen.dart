import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/cart/presentation/order_status_screen.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/user/provider/user_provider.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../utilities/common/custom_button.dart';
import '../../../utilities/common/custom_dialog.dart';
import '../../../utilities/common/custom_ui.dart';
import '../../../utilities/common/scaffold_builder.dart';
import '../../../utilities/common/text_formfield.dart';
import '../../../utilities/debouncer.dart';
import '../../../utilities/orado_icon_icons.dart';
import '../../../utilities/utilities.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static String route = 'cart';
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Debouncer deboucer = Debouncer(delay: const Duration(milliseconds: 700));
  int paymentMethod = 1;
  final TextEditingController cookingInstruction = TextEditingController();
  final TextEditingController deliveryInstruction = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    cookingInstruction.dispose();
    deliveryInstruction.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<CartProvider>().getCart(context));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, _) {
      return CustomUi(
        gap: 0,
        // whitContainerHeight: 688,
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
                          Text(paymentMethod == 0 ? 'Razorpay' : 'Cash on Delivery'),
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
                        var locationProvider = context.read<LocationProvider>();
                        var userProvider = context.read<UserProvider>();
                        var body = {
                          "cartId": [provider.cart.cartItems?.first.cartId],
                          "merchantId": provider.cart.cartItems?.first.merchantId.toString(),
                          "paymentMethod": "cash",
                          "tipAmount": 0,
                          "deliveryMode": 0,
                          "merchantInstruction": cookingInstruction.text,
                          "deliveryInstruction": deliveryInstruction.text,
                          "couponCode": "",
                          "longitude": locationProvider.currentLocationLatLng?.longitude.toString(),
                          "latitude": locationProvider.currentLocationLatLng?.latitude.toString(),
                          "address": locationProvider.currentLocationAddress,
                        };
                        var success = await provider.buyFromCart(context, data: body);
                        if (success) {
                          context.pushNamed(OrderStatusScreen.route);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: provider.isLoading
                            ? BuildLoadingWidget()
                            : Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('${AppStrings.inrSymbol}${provider.cart.totalCost}'),
                                      const Text('Total'),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
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
          ...provider.cart.cartItems!.map(
            (item) => ListTile(
              tileColor: AppColors.baseColor.withValues(alpha: 0.3),
              style: ListTileStyle.list,
              title: Text(
                item.cartproductrelation!.productName!,
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
                      image: CachedNetworkImageProvider(item.cartproductrelation!.productstablerelation8!.first.imageRelation2!.imageName!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              subtitle: Text('${AppStrings.inrSymbol}${item.cartproductrelation!.price}', style: AppStyles.getBoldTextStyle(fontSize: 14)),
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
                            provider.deleteFromCart(context, itemId: item.cartId.toString());
                          } else {
                            provider.updateItemInCart(context, itemId: item.cartId.toString(), quantity: item.quantity!);
                          }
                        });
                      },
                      child: const Icon(size: 16, Icons.remove, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.quantity.toString(),
                      style: AppStyles.getMediumTextStyle(fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => item.quantity = item.quantity! + 1);
                        deboucer.debounce(() {
                          provider.updateItemInCart(context, itemId: item.cartId.toString(), quantity: item.quantity!);
                        });
                      },
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
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
              onPressed: () => onTapCookingInstructios(context),
              label: Text(
                'Add cooking requests',
                style: AppStyles.getMediumTextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            // height: 50,
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
                        provider.cart.alldata?.error ?? 'Delivery in ${provider.cart.alldata?.duration?.ceil()} mins',
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
                      context.read<LocationProvider>().currentLocationAddress ?? '',
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
                      onPressed: () => onTapdeliveryInstructios(context),
                      label: Text(
                        'Add instructions for delivery partner',
                        style: AppStyles.getMediumTextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  // const SizedBox(height: 5),
                  ListTile(
                    dense: true,
                    onTap: () => onTapRecieverDetails(context),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 25,
                      color: AppColors.baseColor,
                    ),
                    visualDensity: VisualDensity.compact,
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
                    onTap: () => onTapTotalBill(context, provider),
                    leading: const Icon(OradoIcon.orders),
                    title: Text('Total Bill ${AppStrings.inrSymbol}${provider.cart.totalCost}'),
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
    });
  }

  void onTapTotalBill(BuildContext context, CartProvider provider) {
    double itemTotal = 0;
    for (var i in provider.cart.cartItems!) {
      itemTotal += i.cartproductrelation!.price! * i.quantity!;
    }
    print(itemTotal);
    CustomDialogue().showCustomDialogue(
      context: context,
      content: <Widget>[
        Text(
          'Bill Summary',
          style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
        ),
        const SizedBox(
          height: 14,
        ),
        Card(
            color: Colors.grey.shade50,
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(children: <Widget>[
                buidItems(title: 'Item total', amt: itemTotal.toStringAsFixed(2)),
                ...provider.cart.alldata!.taxes!.map(
                  (e) => buidItems(title: e.tax!.first.taxName!, amt: e.tax!.first.taxAmount!.toStringAsFixed(2)),
                ),
                buidItems(title: 'Delivery partner fee', amt: provider.cart.alldata!.deliveryCharge!.toStringAsFixed(2), subtitle: 'goes to them for their time and effort'),
                const Divider(),
                ListTile(
                  dense: true,
                  horizontalTitleGap: 2,
                  title: Text('Grand Total', style: AppStyles.getSemiBoldTextStyle(fontSize: 13)),
                  trailing: Text(
                    '${AppStrings.inrSymbol}${provider.cart.totalCost!.toStringAsFixed(2)}',
                    style: AppStyles.getMediumTextStyle(fontSize: 13),
                  ),
                )
              ]),
            ))
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        CustomButton().showColouredButton(label: 'SUBMIT', onPressed: () {}),
      ],
    );
  }

  void onTapCookingInstructios(BuildContext context) {
    CustomDialogue().showCustomDialogue(context: context, content: <Widget>[
      Text(
        'Cooking instructions for restuarant',
        style: AppStyles.getRegularTextStyle(fontSize: 17),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: BuildTextFormField(
          controller: cookingInstruction,
          hint: 'Write here',
          maxLines: 5,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(
        height: 25,
      ),
      CustomButton().showColouredButton(label: 'Save', onPressed: () {}),
    ]);
  }

  void onTapdeliveryInstructios(BuildContext context) {
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
            controller: deliveryInstruction,
            hint: 'Write here',
            maxLines: 5,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        CustomButton().showColouredButton(label: 'Save', onPressed: () {}),
      ],
    );
  }

  Widget buidItems({required String title, required String amt, String? subtitle}) {
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
            style: AppStyles.getMediumTextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  onTapDeliveryAddress(BuildContext context) {
    CustomDialogue().showCustomDialogue(context: context, content: <Widget>[
      Text(
        'Select an address',
        style: AppStyles.getSemiBoldTextStyle(fontSize: 17),
      ),
      const SizedBox(height: 15),
      InkWell(
        //! onTap: () => context.pushNamed(AppPaths.confirmDeliveryLocation),
        child: Card(
          color: Colors.grey.shade50,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.add, color: AppColors.baseColor),
                const SizedBox(width: 8),
                Text(
                  'Add Address',
                  style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
                ),
                const Spacer(),
                Icon(Icons.keyboard_arrow_right_outlined, color: AppColors.baseColor),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 14),
      Text(
        'Saved Address',
        style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
      ),
      const SizedBox(height: 10),
      Card(
        elevation: 0,
        color: Colors.grey.shade50,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: ListTile(
            dense: true,
            isThreeLine: true,
            title: Text(
              'HOME',
              style: AppStyles.getSemiBoldTextStyle(fontSize: 13),
            ),
            leading: const Icon(
              OradoIcon.home_outlined,
              size: 18,
            ),
            subtitle: Text(
              'Lorem ipsum dolor sit amet, consect adipis consectetur',
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
      ),
    ]);
  }
}
