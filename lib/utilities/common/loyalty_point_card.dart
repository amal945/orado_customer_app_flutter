import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orado_customer/features/cart/provider/cart_provider.dart';

class LoyaltyPointsCard extends StatelessWidget {
  const LoyaltyPointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, _) {
      final rule = provider.rule;
      final subtotal =
          double.tryParse(provider.priceSummary?.data?.total ?? '0') ?? 0;

      if (rule == null) return const SizedBox();

      final minPoints = rule.minPointsForRedemption ?? 0;
      final maxPercent = rule.maxRedemptionPercent ?? 0;
      final valuePerPoint = rule.valuePerPoint ?? 1;
      final maxPointsByPercent =
          ((subtotal * maxPercent) / 100) ~/ valuePerPoint;
      final maxRedeemable = provider.balance < maxPointsByPercent
          ? provider.balance
          : maxPointsByPercent;

      final pointsPerAmount = rule.pointsPerAmount ?? 10;
      final earnablePoints = ((subtotal ~/ 100) * pointsPerAmount)
          .clamp(0, rule.maxEarningPoints ?? 999);

      int enteredPoints =
          int.tryParse(provider.loyaltyPointController.text) ?? 0;
      final isValidEntry =
          enteredPoints >= minPoints && enteredPoints <= maxRedeemable;
      final appliedPoints = isValidEntry
          ? enteredPoints
          : (enteredPoints > maxRedeemable ? maxRedeemable : 0);


        provider.loadPriceSummary(
            longitude: provider.selectedLongitude!,
            latitude: provider.selectedLatitude!,
            cartId: provider.cartData!.cartId!);


      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.shade100),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Loyalty Points',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Text(
                  '${provider.balance} pts available',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Checkbox toggle
            Row(
              children: [
                Checkbox(
                  value: provider.useLoyaltyPoint,
                  onChanged: (_) => provider.toggleLoyaltyPoint(),
                  activeColor: Colors.deepOrange,
                ),
                const Text(
                  'Redeem points',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Input
            Visibility(
              visible: provider.useLoyaltyPoint,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: provider.loyaltyPointController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Min $minPoints pts',
                    border: InputBorder.none,
                    suffixText: 'Max: $maxRedeemable pts',
                    suffixStyle:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  onChanged: (val) {
                    provider
                        .notifyListeners(); // to trigger rebuild and live update
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// Redeemed Info
            if (provider.useLoyaltyPoint && appliedPoints > 0)
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Redeemed $appliedPoints points (₹${appliedPoints * valuePerPoint} discount)',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ],
              ),

            /// Earn Info
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange[800], size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Earn $earnablePoints points after successful delivery ($pointsPerAmount pts per ₹100)',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Savings Preview
            if (provider.useLoyaltyPoint && appliedPoints > 0)
              Text(
                "You'll save ₹${(appliedPoints * valuePerPoint).toStringAsFixed(2)} with this redemption",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Earning Potential',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete this order to earn $earnablePoints points ($pointsPerAmount pts per ₹100)',
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    });
  }
}
