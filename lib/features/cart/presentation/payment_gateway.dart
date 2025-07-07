import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  const RazorpayPaymentScreen({super.key});

  @override
  State<RazorpayPaymentScreen> createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  final TextEditingController _amountController =
      TextEditingController(text: '500.00');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late Razorpay _razorpay; // Declare Razorpay instance

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clears all listeners
    _amountController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Successful: ${response.paymentId}'),
        duration: const Duration(seconds: 5),
      ),
    );
    debugPrint('Payment Success: ${response.paymentId}');
  }

  // Function to handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.code} - ${response.message}'),
        duration: const Duration(seconds: 5),
      ),
    );
    debugPrint('Payment Error: ${response.code} - ${response.message}');
  }

  // Function to handle external wallet selection
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        duration: const Duration(seconds: 5),
      ),
    );
    debugPrint('External Wallet: ${response.walletName}');
  }

  // Function to initiate payment
  void _initiatePayment() {
    final String amountString = _amountController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;

    // Validate inputs
    if (email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and phone number.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Convert amount to smallest currency unit (paise for INR)
    // Assuming amount is in rupees, multiply by 100
    final double amountInRupees = double.tryParse(amountString) ?? 0.0;
    final int amountInPaise = (amountInRupees * 100).round();

    // Razorpay options
    var options = {
      'key': 'YOUR_RAZORPAY_KEY_ID', // Replace with your actual Razorpay Key ID
      'amount': amountInPaise, // Amount in smallest currency unit
      'name': 'Acme Corp.',
      'description': 'Test Payment',
      'prefill': {
        'contact': phone,
        'email': email,
      },
      'external': {
        'wallets': ['paytm'] // Optional: Specify preferred wallets
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Light gray background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(40.0), // Equivalent to p-10
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 10),
                  blurRadius: 15,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Razorpay-like Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Complete your payment',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151), // text-gray-800
                      ),
                    ),
                    // Placeholder for Razorpay logo
                    Container(
                      width: 120,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1), // indigo-500
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Razorpay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0), // mb-8

                // Payment Details Form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount Field
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B5563), // text-gray-700
                      ),
                    ),
                    const SizedBox(height: 8.0), // mb-2
                    TextFormField(
                      controller: _amountController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280), // text-gray-500
                            ),
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        hintText: '500.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xFFD1D5DB)), // border-gray-300
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF6366F1),
                              width: 2.0), // indigo-500
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(
                          color: Color(0xFF374151)), // text-gray-700
                    ),
                    const SizedBox(height: 24.0), // space-y-6 equivalent

                    // Email Field
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'name@example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF6366F1), width: 2.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(color: Color(0xFF374151)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),

                    // Phone Number Field
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '9876543210',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF6366F1), width: 2.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(color: Color(0xFF374151)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Please enter a 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32.0),

                    // Pay Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _initiatePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF6366F1), // indigo-600
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 24.0), // py-3.5 px-6
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 4, // shadow-md
                          shadowColor: Colors.black.withOpacity(0.1),
                        ),
                        child: const Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600, // font-semibold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Footer / Powered by
                const SizedBox(height: 32.0), // mt-8
                const Text(
                  'Powered by Razorpay',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF6B7280), // text-gray-500
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
