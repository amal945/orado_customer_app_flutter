import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:orado_customer/features/cart/models/coupons_response_model.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/styles.dart';
import 'package:provider/provider.dart';
import '../../../utilities/common/loading_widget.dart';

class CouponScreen extends StatefulWidget {
  final String restaurantId;

  const CouponScreen({Key? key, required this.restaurantId}) : super(key: key);

  static String route = 'coupons';

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  void _applyPromoCode(String code) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Promo code "$code" applied successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context
            .read<CartProvider>()
            .getAllCoupons(restaurantId: widget.restaurantId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final router = GoRouter.of(context);
                if (router.canPop()) {
                  router.pop();
                } else {
                  context.goNamed('home');
                }
              });
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              size: 37,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Coupons',
            style: AppStyles.getBoldTextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          backgroundColor: AppColors.baseColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: Consumer<CartProvider>(builder: (context, provider, _) {
          if (provider.isLoading) {
            return BuildLoadingWidget(
                withCenter: true, color: AppColors.baseColor);
          } else if (provider.coupons.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Coupon Code',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'APPLY',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter Coupon Code',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle apply action
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'APPLY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '🏷️ Special Offers',
                  style: AppStyles.getBoldTextStyle(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text('Apply these codes at checkout to save money',
                    style: AppStyles.getMediumTextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.coupons.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final coupon = provider.coupons[index];
                    return PromoCodeCard(
                      coupons: coupon,
                      onApply: () {
                        provider.setCouponCode(code: coupon.code!);
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }));
  }
}

class PromoCodeCard extends StatelessWidget {
  final Coupons coupons;
  final VoidCallback onApply;

  const PromoCodeCard({
    Key? key,
    required this.coupons,
    required this.onApply,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final provider = context.read<CartProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.baseColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.baseColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.local_offer,
                  size: 18,
                  color: AppColors.baseColor,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.baseColor.withOpacity(0.1),
                  border:
                      Border.all(color: AppColors.baseColor.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  coupons.code ?? '',
                  style: TextStyle(
                    color: AppColors.baseColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            coupons.description ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildDetailItem(
                      'Min Order',
                      coupons.minOrderValue == 0
                          ? 'No minimum'
                          : '₹${coupons.minOrderValue}',
                      Icons.shopping_cart_outlined,
                    ),
                    const SizedBox(height: 10),
                    _buildDetailItem(
                      'Expires',
                      coupons.validTill ?? '',
                      Icons.schedule_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildDetailItem(
                      'Discount',
                      '${coupons.discountValue}',
                      Icons.percent,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: provider.selectedCouponCode == coupons.code
                          ? OutlinedButton(
                              onPressed: provider.removeCouponCode,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.baseColor,
                                side: BorderSide(color: AppColors.baseColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Remove',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: onApply,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.baseColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'APPLY',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
