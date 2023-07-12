import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/pallete.dart';

class PremiumButton extends StatefulWidget {
  const PremiumButton({Key? key}) : super(key: key);

  @override
  _PremiumButtonState createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  Map<String, dynamic>? paymentIntentData;

  Future<void> buyPremium(BuildContext context) async {
    try {
      paymentIntentData = await createPaymentIntentData('20', 'USD');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
        ),
      );

      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntentData(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
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
      return jsonDecode(result.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  displayPaymentSheet() async {
    try {
      // await Stripe.instance
      //     .presentPaymentSheet(
      //   parameters: PresentPaymentSheetParameters(
      //     clientSecret: paymentIntentData!['client_secret'],
      //     confirmPayment: true,
      //   ),
      // )
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
        ),
      )
          .then((newValue) {
        print('payment intent${paymentIntentData!['id']}');
        print('payment intent${paymentIntentData!['client_secret']}');
        if (kDebugMode) {
          print('payment intent${paymentIntentData!['amount']}');
        }
        print('payment intent$paymentIntentData');
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => buyPremium(context),
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
