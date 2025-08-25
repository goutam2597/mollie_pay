/// Result of a Mollie payment flow.
class MolliePaymentResult {
  /// The Mollie payment ID (e.g., `tr_xxxxx`).
  final String paymentId;

  /// Current payment status from Mollie (e.g., `paid`, `open`, `failed`).
  final String status;

  /// Raw response data returned by Mollie.
  final Map<String, dynamic> raw;

  /// Creates an immutable [MolliePaymentResult].
  const MolliePaymentResult({
    required this.paymentId,
    required this.status,
    required this.raw,
  });

  /// Convenience flag: true if [status] equals `"paid"`.
  bool get isPaid => status == 'paid';
}

/// Exception thrown when something goes wrong during Mollie checkout.
class MollieCheckoutException implements Exception {
  /// Error message describing the problem.
  final String message;

  /// Optional underlying cause (e.g., network error).
  final Object? cause;

  /// Creates a [MollieCheckoutException].
  MollieCheckoutException(this.message, [this.cause]);

  @override
  String toString() => 'MollieCheckoutException: $message';
}
