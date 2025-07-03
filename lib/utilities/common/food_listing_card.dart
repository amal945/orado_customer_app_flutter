import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/features/merchants/provider/merchant_provider.dart';
import 'package:provider/provider.dart';

import '../../features/merchants/models/menu_data_model.dart';

class FoodsListingCard extends StatelessWidget {
  List<MenuItem> items;
  String restaurantId;

  FoodsListingCard(
      {super.key, required this.items, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, _) {
      return Card(
        surfaceTintColor: Colors.transparent,
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.separated(
            itemCount: items.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final product = items[index];
              final bool isInCart = provider.cartItems
                  .any((data) => data.productId == product.id);

              var quantity = 0;

              if (isInCart) {
                // Find the cart item matching the product and get its quantity
                final cartItem = provider.cartItems.firstWhere(
                  (data) => data.productId == product.id,
                );

                if (cartItem != null) {
                  quantity = cartItem.quantity ??
                      0; // assuming quantity can be nullable
                }
              }

              return SizedBox(
                height: 200,
                child: ClipRect(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 28,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  for (int i = 0; i < 5; i++)
                                    Icon(Icons.star,
                                        size: 16, color: Colors.green.shade800),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating} ratings',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '₹${product.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 6),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: product.images.isNotEmpty
                                    ? product.images.first
                                    : 'https://via.placeholder.com/150',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 35,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.orange.shade700,
                                ),
                                child: Builder(builder: (context) {
                                  return isInCart
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: provider.isLoading
                                                  ? null
                                                  : () {
                                                      provider.addToCart(
                                                          restaurantId:
                                                              restaurantId,
                                                          productId: product.id,
                                                          quantity:
                                                              quantity - 1);
                                                      quantity--;
                                                    },
                                              child: const Icon(Icons.remove,
                                                  size: 19,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: provider.isLoading
                                                  ? null
                                                  : () {
                                                      log('Adding item: ${product.name}, ID: ${product.id}, Qty: ${quantity + 1}');
                                                      provider.addToCart(
                                                          restaurantId:
                                                              restaurantId,
                                                          productId: product.id,
                                                          quantity:
                                                              quantity + 1);
                                                      quantity++;
                                                    },
                                              child: const Icon(Icons.add,
                                                  size: 19,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                        )
                                      : ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orange.shade700,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: provider.isLoading
                                              ? null
                                              : () {
                                                  provider.addToCart(
                                                      restaurantId:
                                                          restaurantId,
                                                      productId: product.id,
                                                      quantity: 1);
                                                },
                                          icon: const Icon(Icons.add,
                                              color: Colors.white),
                                          label: const Text('Add'),
                                        );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      );
    });
  }
}
