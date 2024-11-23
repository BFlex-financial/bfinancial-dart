<img align="right" src="https://imgur.com/EtCvGVc.png" height="85">
🎯 Biblioteca para ayudar con pagos a pequeña y gran escala

# SDK de dardos BFlex

> [!TIP] 
> ¿Necesita ayuda con algo del SDK? Puedes intentar interactuar en [nuestra comunidad de Discord](https://discord.gg/cdEnEtwehC)

Resumen
=====================================

  <!--Tabla de índices-->
  * [Características](#características)
  * [Instalación](#instalación)
    * [Requisitos](#requisitos)
  * [Empecemos](#comencemos)
  * [Ejemplos de código](#ejemplos)

## Características

**Facilidad de implementación del SDK**: todos nuestros SDK están diseñados para mantener una estructura consistente de identificadores y patrones de uso en diferentes lenguajes de programación. Esto proporciona una integración extremadamente intuitiva: incluso si no tienes un conocimiento profundo del lenguaje específico, podrás implementar el SDK con facilidad.

**Interfaz de usuario de pago**: si su proyecto no requiere que el usuario permanezca en una plataforma específica y permite redireccionamientos, puede simplificar la implementación del lado del servidor simplemente redirigiendo al usuario a la URL de una página de pago oficial. de BFlex, asegurando una integración práctica y eficiente.

**Facilidad de Obtener Resultados**: A diferencia de otras plataformas de pago, con BFlex puedes crear un pago usando tu método preferido con solo unas pocas líneas de código. Y lo mejor: todo ello de forma segura, sin necesidad de gestionar una comunicación directa con el consumidor.

## Instalación

### Requisitos

* Dart SDK 3.5 (o superior)

### Instalación del paquete

Para comenzar, agregue la biblioteca de BFlex a su proyecto. En el archivo `pubspec.yaml`, inserte la siguiente dependencia:

```yaml
dependencies:
  bfinancial: ^0.0.1
```

Luego, use el **[🎯 Dart](https://dart.dev/) SDK** para descargar la biblioteca. Esto se puede hacer con el comando:

```sh-session
$ dart pub get
```

## Empecemos

### 1. Configuración inicial

Utilice la clase **Client** del SDK para iniciar sesión con su **clave API**. Después de iniciar sesión, tendrá acceso a la instancia preconfigurada de la clase Pagos, que la clase **Client** devuelve automáticamente.

```dart
import 'package:bfinancial';

void main() {
  final client = Client.login("YOUR_API_KEY");
  final payments = client.payments;
}
```

### 2. ¡Haz tu primer pago!

Pruebe la integración realizando un pago de prueba de 1 **BRL**. ¡El monto se acreditará en su cuenta **BFlex** a través de una **Pix** generada automáticamente por el SDK!

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

### 3. Documentación

Puedes ver la [📚 **Documentación** haciendo clic aquí](https://bflex.tech/docs/dart-sdk).

## Ejemplos

### Generando pagos con PIX
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

### Generando pagos con tarjeta

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

### Recopilación de datos de pago

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

O, si no sabe el tipo exacto de pago al que se enfrenta, puede utilizar:

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

  // Para evitar el casting para un tipo donde el pago no coincide
  if( response is Pix ) {
    // ...
    print(response.access<Pix>());
  } else if( response is Card ) {
    // ...
    print(response.access<Card>()); 
  }

}
```

### Validación de estado en tiempo real

Con esto podrás esperar a recibir un Estado, y saber si fue recibido, u otro.

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