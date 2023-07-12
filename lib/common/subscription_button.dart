import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:routemaster/routemaster.dart';

import '../models/payment_model.dart';
import '../theme/pallete.dart';

class PremiumButton extends StatefulWidget {
  const PremiumButton({Key? key}) : super(key: key);

  @override
  _PremiumButtonState createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  Map<String, dynamic>? paymentIntentData;

  StripePaymentModel? paymentData;

  bool confirmed = false;

  Future<void> payment() async {
    try {
      Map<String, dynamic> body = {
        'amount': '1000',
        'currency': 'INR',
        'payment_method_types[]': 'card'
      };

      var result = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          // 'Authorization': dotenv.env['STRIPE_SECRET_KEY']!,
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']!}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      paymentIntentData = json.decode(result.body);
    } catch (e) {
      print(e.toString());
    }

    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                merchantDisplayName: 'Sufyan'))
        .then((value) => {
              paymentData = StripePaymentModel(
                paymentId: paymentIntentData!['id'],
                amount: double.parse(paymentIntentData!['amount'].toString()),
                currency: paymentIntentData!['currency'],
                status: paymentIntentData!['status'],
              )
            });

    try {
      await Stripe.instance.presentPaymentSheet().then((value) => {
            print('payment intent${paymentIntentData!['id']}'),
            print('payment intent${paymentIntentData!['client_secret']}'),
            if (kDebugMode)
              {
                print('payment intent${paymentIntentData!['amount']}'),
              },
            print('payment intent$paymentIntentData'),
            confirmed = true,
            showSuccess()
          });
    } catch (e) {
      print(e.toString());
    }
  }

  showSuccess() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Success'),
        content: const Text('Payment done successfully'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              confirmed == true ? pushToHome() : showError();
            },
          ),
        ],
      ),
    );
  }

  showError() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Failed'),
        content: const Text('Payment failed!'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void pushToHome() {
    Routemaster.of(context).push('/');
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => payment(),
        icon: const FaIcon(FontAwesomeIcons.buyNLarge),
        label: const Text(
          'Continue with Payment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
