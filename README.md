# bfinancial-dart

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
    payerCpf: '12345678909',
    amount: 1000.0,
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
    payerEmail:     'lucasdwbfff@gmail.com',
    PayerName:      'test user',
    payerCpf:       '1245678910',
    number:         '5031433215406351',
    amount:          1000.0,
    cvv:            '123'
  ));

  if( err != null ) {
    print("Error returned when generating payment: $err");
    return;
  }

  print(response.access<Card>());
}
```