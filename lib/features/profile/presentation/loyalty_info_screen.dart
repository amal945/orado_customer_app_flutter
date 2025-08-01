import 'package:flutter/material.dart';
import 'package:orado_customer/features/profile/provider/loyalty_provider.dart';
import 'package:provider/provider.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/common/loading_widget.dart';
import '../../../utilities/styles.dart';

class LoyaltyInfoScreen extends StatefulWidget {
  const LoyaltyInfoScreen({super.key});

  static const String route = 'royalty_points_screen';

  @override
  State<LoyaltyInfoScreen> createState() => _LoyaltyInfoScreenState();
}

class _LoyaltyInfoScreenState extends State<LoyaltyInfoScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context.read<LoyaltyProvider>().getRules();
        context.read<LoyaltyProvider>().fetchBalance();
      }
    });
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Loyalty Program',
          style: AppStyles.getBoldTextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: AppColors.baseColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Consumer<LoyaltyProvider>(
        builder: (context, provider, _) {
          final rules = provider.data;

          if (rules == null || provider.isLoading) {
            return BuildLoadingWidget(
                withCenter: true, color: AppColors.baseColor);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildLoyaltySummaryRow(provider.balance),
                const SizedBox(height: 24),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Loyalty Program Terms",
                        style: AppStyles.getBoldTextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      _LoyaltyTermTile(
                        icon: Icons.info,
                        title: 'Earning Points',
                        description:
                            'You will earn ${rules.pointsPerAmount} point for every ₹100 spent.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.shopping_cart_checkout,
                        title: 'Minimum Order to Earn',
                        description:
                            'Minimum order value to earn loyalty points is ₹${rules.minOrderAmountForEarning}.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.attach_money,
                        title: 'Point Value',
                        description:
                            'Each loyalty point is worth ₹${rules.valuePerPoint}.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.shopping_cart,
                        title: 'Minimum Order to Redeem',
                        description:
                            'Minimum order amount required for redeeming points is ₹${rules.minOrderAmountForRedemption}.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.access_time,
                        title: 'Point Crediting',
                        description:
                            'Points are credited 24 hours after successful delivery.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.hourglass_bottom,
                        title: 'Validity',
                        description:
                            'Loyalty points are valid for ${rules.expiryDurationDays} days from credit.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.stacked_line_chart,
                        title: 'Max Points Per Order',
                        description:
                            'You can earn a maximum of ${rules.maxEarningPoints} points per order.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.percent,
                        title: 'Redemption Limit',
                        description:
                            'You can redeem points up to ${rules.maxRedemptionPercent}% of the order total.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.local_offer,
                        title: 'Usage with Offers',
                        description:
                            'Loyalty points can be used along with other discounts and offers.',
                      ),
                      _LoyaltyTermTile(
                        icon: Icons.info_outline,
                        title: 'Disclaimer',
                        description:
                            'All terms and conditions are subject to change without prior notice.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoyaltySummaryRow(int balance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _responsiveSummaryCard(
              value: "$balance",
              label: 'Available Points',
              icon: Icons.card_giftcard,
              gradient: [Colors.orange, Colors.deepOrange],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _responsiveSummaryCard(
              value: 'Get 1 point',
              label: 'Per ₹100 spent',
              icon: Icons.trending_up,
              gradient: [Colors.purple, Colors.blue],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _responsiveSummaryCard(
              value: '₹1',
              label: 'Per point value',
              icon: Icons.attach_money,
              gradient: [Colors.amber, Colors.orange],
            ),
          ),
        ],
      ),
    );
  }

  Widget _responsiveSummaryCard({
    required String value,
    required String label,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Value with flexible sizing
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppStyles.getBoldTextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppStyles.getRegularTextStyle(
                  fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradient),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard({
    required String value,
    required String label,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: AppStyles.getBoldTextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.getRegularTextStyle(
                fontSize: 13, color: Colors.black87),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: gradient),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}

class _LoyaltyTermTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _LoyaltyTermTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: AppColors.baseColor),
      ),
      title: Text(
        title,
        style: AppStyles.getSemiBoldTextStyle(fontSize: 16),
      ),
      subtitle: Text(
        description,
        style: AppStyles.getRegularTextStyle(fontSize: 14),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
