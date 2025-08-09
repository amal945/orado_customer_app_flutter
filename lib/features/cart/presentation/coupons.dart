import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:orado_customer/features/cart/models/coupons_response_model.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/styles.dart';
import '../../../utilities/common/loading_widget.dart';

class CouponScreen extends StatefulWidget {
  final String restaurantId;

  const CouponScreen({Key? key, required this.restaurantId}) : super(key: key);

  static String route = 'coupons';

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context
          .read<CartProvider>()
          .getAllCoupons(restaurantId: widget.restaurantId);
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
        if (provider.isCouponLoading) {
          return BuildLoadingWidget(
              withCenter: true, color: AppColors.baseColor);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _CodeEntryRow(provider: provider),
              const SizedBox(height: 8),
              if (provider.coupons.isNotEmpty) ...[
                Text(
                  '🏷️ Special Offers',
                  style: AppStyles.getBoldTextStyle(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  'Apply these codes at checkout to save money',
                  style: AppStyles.getMediumTextStyle(fontSize: 14),
                ),
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
                        if (coupon.code != null &&
                            coupon.code!.isNotEmpty &&
                            !provider.isApplyingCoupon) {
                          provider.setCouponCode(
                              code: coupon.code!, context: context);
                        }
                      },
                    );
                  },
                ),
              ] else ...[
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'No coupons available',
                    style: AppStyles.getRegularTextStyle(
                        fontSize: 16, color: Colors.grey[700]),
                  ),
                )
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

class _CodeEntryRow extends StatelessWidget {
  final CartProvider provider;

  const _CodeEntryRow({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              controller: provider.couponController,
              decoration: InputDecoration(
                hintText: 'Enter Coupon Code',
                hintStyle: AppStyles.getLightTextStyle(
                    fontSize: 14, color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
              style: AppStyles.getRegularTextStyle(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              if (!provider.isApplyingCoupon) {
                provider.setCouponCodeFromTextField(context: context);
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'APPLY',
              style: AppStyles.getBoldTextStyle(
                  fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
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
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, _) {
      final isSelected = provider.selectedCouponCode == coupons.code;
      final applying = provider.isApplyingCoupon;

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.baseColor.withOpacity(0.1),
                    border: Border.all(
                        color: AppColors.baseColor.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    coupons.code ?? '',
                    style: AppStyles.getSemiBoldTextStyle(
                        fontSize: 13, color: AppColors.baseColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              coupons.description ?? '',
              style: AppStyles.getSemiBoldTextStyle(
                  fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildDetailItem(
                        'Min Order',
                        (coupons.minOrderValue == null ||
                            coupons.minOrderValue == 0)
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
                        coupons.formattedDiscount,
                        coupons.discountIcon,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: isSelected
                            ? OutlinedButton(
                          onPressed: applying
                              ? null
                              : () {
                            provider.removeCouponCode();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.baseColor,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: AppColors.baseColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: applying
                              ? LoadingAnimationWidget.progressiveDots(
                            color: AppColors.baseColor,
                            size: 20,
                          )
                              : Text(
                            'Remove',
                            style: AppStyles.getBoldTextStyle(
                                fontSize: 14,
                                color: AppColors.baseColor),
                          ),
                        )
                            : ElevatedButton(
                          onPressed: (applying ||
                              (coupons.code == null ||
                                  coupons.code!.isEmpty))
                              ? null
                              : onApply,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.baseColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: applying
                              ? LoadingAnimationWidget.progressiveDots(
                            color: Colors.white,
                            size: 20,
                          )
                              : Text(
                            'APPLY',
                            style: AppStyles.getBoldTextStyle(
                                fontSize: 14, color: Colors.white),
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
    });
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
                style: AppStyles.getLightTextStyle(
                    fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppStyles.getSemiBoldTextStyle(
                    fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
