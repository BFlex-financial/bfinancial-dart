<img align="right" src="https://imgur.com/EtCvGVc.png" height="85"> 
🎯 Library to assist with large and small scale payments 

# BFlex Dart SDK 

> [!TIP] 
> Needs support with something from the SDK? You can try interacting in [our Discord community](https://discord.gg/cdEnEtwehC)

Summary
==========================================

  <!--Table of indexes-->
  * [Features](#features)
  * [Installation](#installation)
    * [Requirements](#requirements)
  * [ Let's get started](#let's-get-started)
  * [Code Examples](#examples)

## Features

**Ease of SDK Implementation**: All of our SDKs are designed to maintain a consistent structure of identifiers and usage patterns across different programming languages. This provides an extremely intuitive integration: even if you do not have in-depth knowledge of the specific language, you will be able to implement the SDK with ease.

**Checkout User Interface**: If your project does not require the user to stay on a specific platform and allows redirects, you can simplify the server-side implementation by simply redirecting the user to an official checkout page URL. from BFlex, ensuring practical and efficient integration.

**Ease of Obtaining Results**: Unlike other payment platforms, with BFlex you can create a payment using your preferred method with just a few lines of code. And the best: all this in a secure way, without the need to manage direct communication with the consumer.

## Installation

### Requirements

* Dart SDK 3.5 (or higher)

### Package installation

To start, add the library from BFlex to your project. In the `pubspec.yaml` file, insert the following dependency:

```yaml
dependencies:
  bfinancial: ^0.0.1
```

Then, use the **[🎯 Dart](https://dart.dev/) SDK** to download the library. This can be done with the command:

```sh-session
$ dart pub get
```

## Let's get started

### 1. Initial setup

Use the **Client** class from the SDK to log in with your **API key**. After logging in, you will have access to the pre-configured instance of the Payments class, which is automatically returned by the **Client** class.

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;
}
```

### 2. Make your first payment!

Try the integration by making a test payment of 1 **BRL**. The amount will be credited to your **BFlex** account via a ** Pix** generated automatically by the SDK!

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  final (response, err) = await payments.create(PixCreate(
    payerEmail: 'test@gmail.com',
    payerCpf: '1245678910',
    amount: 1.00
  ));

  if( err ) {
    print("Error returned when generating payment: $err");
    return;
  }

  print(response.access<Pix>()); 
}
```

### 3. Documentation

You can see the [📚 **Documentation** by clicking here](https://bflex.tech/docs/dart-sdk).

## Examples

### Generating payments with PIX 
```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  final (response, err) = await payments.create(PixCreate(
    payerEmail : 'test@gmail.com',
    payerCpf: '12345678909',
    amount: 1000.00,
  ));

  if( err ) {
    print("Error returned when generating payment: $err");
    return; 
  } 
  
  print(response.access<Pix>());
} 
``` 

### Generating Card Payments 

```dart 
import 'package:bfinancial';

void main() { 
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  final (response, err) = await payments.create(CardCreate(
    expirationMonth: 11,
    expirationYear: 2025,
    payerEmail: 'test@gmail.com',
    payerName: 'test user',
    payerCpf: '12345678909',
    number: '5031433215406351',
    amount: 1000.00,
    cvv: '123'
  ));

  if( err ) { 
    print("Error returned when generating payment: $err");
    return;
  } 
  
  print(response.access<Card>());
} 
```