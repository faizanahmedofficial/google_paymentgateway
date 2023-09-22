import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goole_paymentgatemway/payment_config.dart';
import 'package:pay/pay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String os = Platform.operatingSystem;

  // Define a variable to hold the selected subscription amount.
  // String? selectedSubscriptionAmount; // Initially set to null

  // Define a variable to hold the selected subscription option.
  String? selectedSubscriptionOption;

  // Define variables for subscription options and their prices.
  final Map<String, String> subscriptionOptions = {
    'Weekly': '1.00',
    'Monthly': '5.00',
    'Yearly': '10.00',
  };

  late var applePayButton;
  late var googlePayButton;

  @override
  void initState() {
    super.initState();

    // Initialize the payment buttons here where you can access instance variables.
    applePayButton = ApplePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
      paymentItems: [
        PaymentItem(
          label: 'Subscription',
          amount: selectedSubscriptionOption ?? '0.00', // Set to '0.00' if null
          status: PaymentItemStatus.final_price,
        ),
      ],
      style: ApplePayButtonStyle.black,
      width: double.infinity,
      height: 50,
      type: ApplePayButtonType.buy,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) => debugPrint('Payment Result $result'),
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    googlePayButton = GooglePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: [
        PaymentItem(
          label: 'Subscription',
          amount: selectedSubscriptionOption ?? '0.00', // Set to '0.00' if null
          status: PaymentItemStatus.final_price,
        ),
      ],
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) => debugPrint('Payment Result $result'),
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Create a function to handle the selection of a subscription option.
  void onSubscriptionOptionSelected(String option) {
    setState(() {
      selectedSubscriptionOption = subscriptionOptions[option];
      selectedSubscriptionOption = option; // Update the selected option.
    });

    // Print the selected price to the console
    print('Selected Subscription Price: \$$selectedSubscriptionOption');

    // Show a toast message for the selected subscription
    Fluttertoast.showToast(
      msg: 'Selected Subscription: \$$selectedSubscriptionOption',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final option in subscriptionOptions.keys)
              GestureDetector(
                onTap: () => onSubscriptionOptionSelected(option),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: option == selectedSubscriptionOption ? Colors.red : Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: option == selectedSubscriptionOption ? Colors.red.withOpacity(0.2) : Colors.transparent,
                  ),
                  child: Text('$option Subscription - \$${subscriptionOptions[option]}'),
                ),
              ),
            if (selectedSubscriptionOption != null)
              Platform.isIOS ? applePayButton : googlePayButton,
            if (selectedSubscriptionOption == null)
              Text(
                'Please select a subscription to enable the payment button.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
