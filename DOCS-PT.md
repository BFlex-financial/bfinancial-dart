<img align="right" src="https://imgur.com/EtCvGVc.png" height="85">

🎯 Library to assist with large and small scale payments

# BFlex Dart SDK

> [!TIP]
> Precisa de suporte com algo da SDK? Você pode tentar interagir em [nossa comunidade do Discord](https://discord.gg/cdEnEtwehC)

Sumário
=========================================

  <!--Tabela de indices-->
  * [Funcionalidades](#funcionalides)
  * [Instalação](#instalação)
    * [Requisitos](#requisitos)
  * [Vamos começar](#vamos-começar)
  * [Exemplos de código](#exemplos)

## Funcionalidades

**Facilidade de Implementação das SDKs**: Todas as nossas SDKs são projetadas para manter uma estrutura consistente de identificadores e modos de uso em diferentes linguagens de programação. Isso proporciona uma integração extremamente intuitiva: mesmo que você não tenha um conhecimento profundo da linguagem específica, será capaz de implementar a SDK com facilidade.

**Interface de Usuário para Checkout**: Caso o seu projeto não exija que o usuário permaneça em uma plataforma específica e permita redirecionamentos, você pode simplificar a implementação no lado do servidor. Basta redirecionar o usuário para uma URL oficial da página de checkout da BFlex, garantindo uma integração prática e eficiente.

**Facilidade na Obtenção de Resultados**: Diferentemente de outras plataformas de pagamento, na BFlex você pode, com apenas algumas linhas de código, criar um pagamento utilizando o método de sua preferência. E o melhor: tudo isso de forma segura, sem a necessidade de gerenciar a comunicação direta com o consumidor.

## Instalação

### Requisitos

  * Dart SDK 3.5 (ou superior)

### Instalação do pacote

Para começar, adicione a biblioteca da BFlex ao seu projeto. No arquivo `pubspec.yaml`, insira a seguinte dependência:

```yaml
dependencies:
  bfinancial: ^0.0.1
```

Depois, utilize a SDK do **[🎯 Dart](https://dart.dev/)** para baixar a biblioteca. Isso pode ser feito com o comando:

```sh-session
$ dart pub get
```

## Vamos começar


### 1. Configuração incial

Utilize a classe **Client** da SDK para realizar o login com sua **chave de API**. Após o login, você terá acesso à instância pré-configurada da classe Payments, que é retornada automaticamente pela classe **Client**.

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;
}
```

### 2. Realize seu primeiro pagamento!

Experimente a integração realizando um pagamento de teste no valor de 1 **BRL**. O montante será creditado em sua conta **BFlex** por meio de um **Pix** gerado automaticamente pela SDK!

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

### 3. Documentação

Você pode ver a [📚 **Documentação** apertando aqui](https://bflex.tech/docs/dart-sdk). 

## Exemplos

### Gerando pagamentos com PIX

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  final (response, err) = await payments.create(PixCreate(
    payerEmail: 'test@gmail.com',
    payerCpf:   '12345678909',
    amount:      1000.00,
  ));

  if( err ) {
    print("Error returned when generating payment: $err");
    return;
  }

  print(response.access<Pix>());
}
```

### Gerando pagamentos com Cartão

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  final (response, err) = await payments.create(CardCreate(
    expirationMonth: 11,
    expirationYear:  2025,
    payerEmail:     'test@gmail.com',
    payerName:      'test user',
    payerCpf:       '12345678909',
    number:         '5031433215406351',
    amount:          1000.00,
    cvv:            '123'
  ));

  if( err ) {
    print("Error returned when generating payment: $err");
    return;
  }

  print(response.access<Card>());
}
```

### Coletando dados do pagamento

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  var (response, err) = await payments.create(PixCreate(
    payerEmail: 'test@gmail.com',
    payerCpf:   '12345678909',
    amount:      1000.00,
  ));

  if( err ) {
    print("Error returned when generating payment: $err");
    return;
  }

  String paymentId = response.access<Pix>().paymentId;
  (response, err) = await payments.obtain(paymentId);

  if( err ) {
    print("Error returned when generating payment: $err");
    return;
  }

  print(response.access<Pix>().paymentId);
}
```

Ou, caso você não saiba o tipo exato de pagamento com que está lidando, você pode usar:

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  final (response, err) = await payments.obtain("PAYMENT_ID");

  if( err ) {
    print("Error returned when generating payment: $err");
    return;
  }

  // Para evitar casting para um tipo no qual o pagamento não corresponde
  if( response is Pix ) {
    // ...
    print(response.access<Pix>());
  } else if( response is Card ) {
    // ...
    print(response.access<Card>()); 
  }

}
```

### Validação de Status em tempo real

Com isto, você pode aguardar o recebimento de um Status, e saber se foi recebido ele, ou outro.

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;

  final (approved, status) = await response.access<Pix>().check((client, "approved"));
  
  if( approved ) {
    print("Payment approved");
  } else {
    switch(status) {
      case 'cancelled':
        print("Payment cancelled");
        break;
      // ...
    }
  }
}
```

