class StripePaymentModel {
  final String paymentId;
  final double amount;
  final String currency;
  final String status;

  StripePaymentModel({
    required this.paymentId,
    required this.amount,
    required this.currency,
    required this.status,
  });

  factory StripePaymentModel.fromJson(Map<String, dynamic> json) {
    return StripePaymentModel(
      paymentId: json['paymentId'],
      amount: json['amount'],
      currency: json['currency'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'amount': amount,
      'currency': currency,
      'status': status,
    };
  }
}
