import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/merchants/models/menu_data_model.dart';
import 'package:orado_customer/utilities/debouncer.dart';
import 'package:provider/provider.dart';

import '../../features/cart/models/cart_model.dart';
import '../../features/merchants/models/product_model.dart';
import '../utilities.dart';

class FoodsListingCard extends StatefulWidget {
  const FoodsListingCard({
    super.key,
    required this.products,
    required this.merchantId,
  });

  final List<MenuItem> products;
  final String merchantId;

  @override
  State<FoodsListingCard> createState() => _FoodsListingCardState();
}

class _FoodsListingCardState extends State<FoodsListingCard> {
  late List<int?> quantities =
      List<int?>.generate(widget.products.length, (int index) => null);
  Debouncer deboucer = Debouncer(delay: const Duration(milliseconds: 700));

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => context.read<CartBloc>().add(CartInitialEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, _) {
      return Card(
        surfaceTintColor: Colors.transparent,
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.separated(
            itemCount: widget.products.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final product = widget.products[index];
              bool isInCart = false;
              CartItemModel? cartItem;
              // try {
              //   cartItem = provider.cart.cartItems!.firstWhere(
              //     (CartItemModel e) => e.productId == product!.productId,
              //   );
              //   isInCart = provider.cart.cartItems!.any(
              //     (CartItemModel e) => e.productId == product!.productId,
              //   );
              // } catch (e) {}
              return SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.name!,
                              style: AppStyles.getBoldTextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star,
                                    size: 16, color: Colors.green.shade800),
                                Icon(Icons.star,
                                    size: 16, color: Colors.green.shade800),
                                Icon(Icons.star,
                                    size: 16, color: Colors.green.shade800),
                                Icon(Icons.star,
                                    size: 16, color: Colors.green.shade800),
                                Icon(Icons.star,
                                    size: 16, color: Colors.green.shade800),
                                const SizedBox(width: 4),
                                Text(
                                  '83 ratings',
                                  style: AppStyles.getMediumTextStyle(
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${AppStrings.inrSymbol}${product.price}',
                              style:
                                  AppStyles.getRegularTextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 18),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.greycolor),
                            child: product.images.isEmpty
                                ? null
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: product.images.first,
                                  ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.baseColor,
                              ),
                              child: isInCart
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            if (cartItem!.quantity! > 1) {
                                              setState(() =>
                                                  cartItem!.quantity =
                                                      cartItem.quantity! - 1);
                                            }
                                            deboucer.debounce(() {
                                              if (cartItem!.quantity! < 1) {
                                                provider.deleteFromCart(context,
                                                    itemId: cartItem.cartId
                                                        .toString());
                                              } else {
                                                provider.updateItemInCart(
                                                    context,
                                                    itemId: cartItem.cartId
                                                        .toString(),
                                                    quantity:
                                                        cartItem.quantity!);
                                              }
                                            });
                                          },
                                          child: const Icon(
                                              size: 19,
                                              Icons.remove,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          cartItem!.quantity.toString(),
                                          style: AppStyles.getSemiBoldTextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() =>
                                                  cartItem!.quantity =
                                                      cartItem.quantity! + 1);
                                              deboucer.debounce(() {
                                                provider.updateItemInCart(
                                                    context,
                                                    itemId: cartItem!.cartId
                                                        .toString(),
                                                    quantity:
                                                        cartItem.quantity!);
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 19,
                                            )),
                                        const SizedBox(width: 5),
                                      ],
                                    )
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.baseColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      onPressed: () {},
                                      icon: const Icon(Icons.add,
                                          color: Colors.white),
                                      label: const Text('Add'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      );
    });
  }
}
