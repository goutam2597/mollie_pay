import 'package:flutter/material.dart';
import 'package:mollie_pay/mollie_pay.dart';

const String mollieTestKey = String.fromEnvironment(
  'MOLLIE_TEST_KEY',
  defaultValue: 'test_example_for_dev_only',
);
const String returnDeepLink = 'myapp://payment-return';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mollie Checkout Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const PayScreen(),
    );
  }
}

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String _status = 'idle';
  bool _busy = false;

  Future<void> _pay() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _status = 'Starting...';
    });

    try {
      final result = await MollieCheckout.startPayment(
        context: context,
        apiKey: mollieTestKey,
        amount: '100.00',
        currency: 'USD',
        description: 'Demo \$100 payment',
        returnDeepLink: returnDeepLink,
      );
      setState(() => _status = 'status: ${result.status}');
    } catch (e) {
      setState(() => _status = 'error: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mollie Checkout (Demo)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _busy ? null : _pay,
              child: const Text('Pay \$100.00'),
            ),
            const SizedBox(height: 16),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
