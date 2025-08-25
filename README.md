# Mollie Pay (Flutter)

A minimal Flutter helper demo for taking payments with **Mollie** via an in-app WebView-style flow (package: `mollie_pay`).  
The example shows how to start a checkout, handle the return deep link, and display the resulting status.

> This package/example is not an official Mollie SDK. Use **test keys** for development and never ship your **secret keys** in the client.

---

## Features

- Start a Mollie checkout from Flutter
- Redirect back to your app via a **return deep link**
- Simple success/pending/failed status handling
- Example app included under `example/`

---

## Getting started

### Installation

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  mollie_pay: ^2.0.0
```

Then run:

```bash
flutter pub get
```

### Provide your API key

**Recommended**: inject via `--dart-define` so you don't hardcode keys:

```bash
flutter run --dart-define=MOLLIE_TEST_KEY=test_xxx
```

Access it in code:

```dart
const mollieTestKey = String.fromEnvironment(
  'MOLLIE_TEST_KEY',
  defaultValue: 'test_example_for_dev_only',
);
```

> For production, use live keys securely and verify payments server-side using Mollie webhooks.

---

## Usage

```dart
final result = await MollieCheckout.startPayment(
  context: context,
  apiKey: mollieTestKey,
  amount: '100.00',
  currency: 'USD',
  description: 'Demo payment',
  returnDeepLink: 'myapp://payment-return',
);

// result.status -> "success" | "failed" | "pending"
```

---

## Example app

See the full example in `example/lib/main.dart`.

```dart
FilledButton(
  onPressed: _busy ? null : _pay,
  child: const Text('Pay \$100.00'),
);
```

---

## Deep links

You must configure OS deep links / app links so that `returnDeepLink` (e.g., `myapp://payment-return`) opens your app.  
In this demo, the WebView intercepts navigation to the `returnDeepLink` and closes automatically when reached.

---

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE).
