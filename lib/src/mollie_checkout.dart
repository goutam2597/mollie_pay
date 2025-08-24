import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'checkout_webview.dart';
import 'mollie_models.dart';

class MollieCheckout {
  static Future<MolliePaymentResult> startPayment({
    required BuildContext context,
    required String apiKey,
    required String amount,
    required String currency,
    required String description,
    required String returnDeepLink,
    Map<String, dynamic>? metadata,
  }) async {
    // Create payment
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

    // Open checkout WebView
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

    // Fetch final status
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
