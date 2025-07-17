import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  final double amount; // in rupees
  final String email;
  final String phone;
  final String orderId;
  final String keyId;

  const RazorpayPaymentScreen({
    super.key,
    required this.amount,
    required this.email,
    required this.phone,
    required this.orderId,
    required this.keyId,
  });

  @override
  State<RazorpayPaymentScreen> createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _initiatePayment(); // initiate payment as soon as the screen loads
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pop(context, {
      'success': true,
      'paymentId': response.paymentId,
      'orderId': response.orderId,
      'signature': response.signature,
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context, {
      'success': false,
      'message': response.message,
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _initiatePayment() {
    final int amountInPaise = (widget.amount * 100).round();

    var options = {
      'key': widget.keyId, // ✅ Use dynamic keyId
      'amount': amountInPaise,
      'order_id': widget.orderId, // ✅ Include order_id
      'name': 'Acme Corp.',
      'description': 'Test Payment',
      'prefill': {
        'contact': widget.phone,
        'email': widget.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay checkout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initiating payment: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
