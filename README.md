# bfinancial-dart
🎯 Library to assist with large and small scale payments

<div align="center">
  <h1>Exemplos de código</h1>
</div>


### Pix
```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("admin");
  final payments = client.payments;

  final (response, err) = await payments.create(PixCreate(
    payerEmail: 'test@gmail.com',
    payerCpf:   '12345678909',
    amount:      1000.00,
  ));

  if( err != null ) {
    print("Error returned when generating payment: $err");
    return;
  }

  print(response.access<Pix>());
}
```

### Cartão
```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("admin");
  final payments = client.payments;

  final (response, err) = await payments.create(CardCreate(
    expirationMonth: 11,
    expirationYear:  2025,
    payerEmail:     'test@gmail.com',
    PayerName:      'test user',
    payerCpf:       '12345678909',
    number:         '5031433215406351',
    amount:          1000.00,
    cvv:            '123'
  ));

  if( err != null ) {
    print("Error returned when generating payment: $err");
    return;
  }

  print(response.access<Card>());
}
```