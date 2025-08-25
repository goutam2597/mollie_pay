import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'checkout_webview.dart';
import 'mollie_models.dart';

/// Mollie checkout helper.
///
/// Typical flow:
/// 1. Create a payment via Mollie REST API.
/// 2. Get `checkout.href` link.
/// 3. Open it in [CheckoutWebView].
/// 4. Intercept redirect back to your app ([returnDeepLink]).
/// 5. Fetch the final status from Mollie.
class MollieCheckout {
  /// Creates a Mollie payment, opens checkout, and returns the final result.
  ///
  /// - [apiKey] must be your **test_...** or **live_...** API key.
  /// - [amount] string with 2 decimals (e.g., `'100.00'`).
  /// - [currency] ISO currency code (`USD`, `EUR`, ...).
  /// - [description] text shown in Mollie dashboard/checkout.
  /// - [returnDeepLink] custom scheme URL to intercept after checkout.
  /// - [metadata] optional extra data stored with the payment.
  ///
  /// Returns a [MolliePaymentResult] with status and raw payload.
  static Future<MolliePaymentResult> startPayment({
    required BuildContext context,
    required String apiKey,
    required String amount,
    required String currency,
    required String description,
    required String returnDeepLink,
    Map<String, dynamic>? metadata,
  }) async {
    // 1. Create payment
    final createRes = await http.post(
      Uri.parse('https://api.mollie.com/v2/payments'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'amount': {'currency': currency, 'value': amount},
        'description': description,
        'redirectUrl': returnDeepLink,
        'metadata': metadata ?? {},
      }),
    );

    if (createRes.statusCode != 201) {
      throw MollieCheckoutException(
        'Payment creation failed: ${createRes.statusCode} ${createRes.body}',
      );
    }

    final payload = jsonDecode(createRes.body) as Map<String, dynamic>;
    final id = payload['id'] as String?;
    final checkoutUrl = (payload['_links']?['checkout']?['href']) as String?;

    if (id == null || checkoutUrl == null) {
      throw MollieCheckoutException('Invalid create response');
    }

    // 2. Open checkout WebView
    if (context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CheckoutWebView(
            checkoutUrl: checkoutUrl,
            returnDeepLink: returnDeepLink,
            onReturn: () {},
          ),
        ),
      );
    }

    // 3. Fetch final status
    final res = await http.get(
      Uri.parse('https://api.mollie.com/v2/payments/$id'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw MollieCheckoutException('Status check failed: ${res.body}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return MolliePaymentResult(
      paymentId: id,
      status: body['status'],
      raw: body,
    );
  }
}
