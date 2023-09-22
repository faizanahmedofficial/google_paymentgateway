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
  String selectedSubscriptionAmount = '1.00'; // Default to $1.00

  // List of available subscription amounts.
  List<String> subscriptionAmounts = ['1.00', '5.00', '10.00'];

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
          amount: selectedSubscriptionAmount,
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
          amount: selectedSubscriptionAmount,
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

  // Create a function to handle the selection of a subscription amount.
  void onSubscriptionAmountSelected(String? amount) {
    if (amount != null) {
      setState(() {
        selectedSubscriptionAmount = amount;
      });

      // Print the selected price to the console
      print('Selected Subscription Price: \$$amount');

      // Show a toast message for the selected subscription
      Fluttertoast.showToast(
        msg: 'Selected Subscription: \$$amount',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } else {
      // Show a toast message when the default "Please select subscription" is displayed
      Fluttertoast.showToast(
        msg: 'Please select a subscription',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedSubscriptionAmount,
              onChanged: onSubscriptionAmountSelected,
              items: subscriptionAmounts.map((amount) {
                return DropdownMenuItem<String>(
                  value: amount,
                  child: Text('\$$amount Subscription'),
                );
              }).toList(),
            ),
            Platform.isIOS ? applePayButton : googlePayButton,
          ],
        ),
      ),
    );
  }
}
