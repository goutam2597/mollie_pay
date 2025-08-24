class MolliePaymentResult {
  final String paymentId;
  final String status;
  final Map<String, dynamic> raw;

  const MolliePaymentResult({
    required this.paymentId,
    required this.status,
    required this.raw,
  });

  bool get isPaid => status == 'paid';
}

class MollieCheckoutException implements Exception {
  final String message;
  final Object? cause;
  MollieCheckoutException(this.message, [this.cause]);
  @override
  String toString() => 'MollieCheckoutException: $message';
}
