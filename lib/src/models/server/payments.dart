import 'package:bfinancial/bfinancial.dart';

enum StatusType {
  reject,
  cancelled,
  approved,
  refunded,
  pending,
  unknown,
}

class Status {
  final StatusType type;
  final String? complement;

  const Status(this.type, [this.complement]);

  @override
  String toString() {
    if( complement != null ) {
      return "$type('$complement')";
    }
    return "$type";
  }
}

sealed class Response {

  static Response validate(String method, Map<String, dynamic> data) {
    if( data.containsKey('error') ) {
      return InvalidResp();
    } 

    switch(method) {
      case 'Pix': 
        return Pix(
          paymentId: (data['payment_id'] as int).toString(),
          literal:   data['qr_code']['literal'] as String,
          qrCode:    data['qr_code']['base64'] as String,
          status:    Status(StatusType.pending)
        );

      case 'Card':
        return Card(
          totalAmount: data['total_amount'] as double,
          paymentId:   data['payment_id'] as String,
          increse:     data['increase'] as double,
          status:      Status(StatusType.pending),
        );
    }

    return InvalidResp();
  }
// # Access the payment
  ///
  /// If you have created a payment, and you know exactly
  /// what type it is and you are sure that it does not
  /// need verification via MATCH, you can force direct 
  /// access with Access
  /// 
  /// # Exemples
  /// 
  /// - If you do not know what type of payment was generated (in this case PIX), you should use:
  /// 
  /// ```dart
  /// // Create the payment
  /// final (response, err) = await payments.create(PixCreate(
  ///   payerEmail: 'test@gmail.com',
  ///   payerCpf: '12345678910',
  ///   amount: 1000.00
  /// ));
  /// 
  /// // Ensures that there are no errors when creating the payment
  /// if( err != null ) {
  ///   print("Error returned when generating payment: $err");
  /// }
  /// 
  /// // It checks the type of payment and handles it appropriately for each
  /// if( response is Pix ) { ... }
  /// else if( response is Card ) { ... }
  /// ```
  /// 
  /// - If you know what type of payment was generated and want to save lines of code, you should use:
  /// 
  /// ```dart
  /// // Create the payment
  /// final (response, err) = await payments.create(PixCreate(
  ///   payerEmail: 'test@gmail.com',
  ///   payerCpf: '12345678910',
  ///   amount: 1000.00
  /// ));
  /// 
  /// // Ensures that there are no errors when creating the payment
  /// if( err != null ) {
  ///   print("Error returned when generating payment: $err");
  /// }
  /// 
  /// // Collects PIX from within the enumerator
  /// final pix = response.access<Pix>(); 
  /// /* 
  ///   or you can use the AS keyword:
  ///   final pix = response as Pix;
  /// */ 
  /// ```
  T access<T>() {
    return this as T;
  }

}

class Card implements Response {
  final double _totalAmount;
  final String _paymentId;
  final double _increse;
  final Status _status;

  Card({
    required double totalAmount,
    required String paymentId,
    required double increse,
    required Status status,
  }) : _totalAmount = totalAmount,
       _paymentId = paymentId,
       _increse = increse,
       _status = status;

  @override
  String toString() => 
      'Payment(Card) by BFlex F. Solutions {\n'
      '\t.paymentId = "$_paymentId"\n'
      '\t.status = ${_status.toString()}\n'
      '\t.increse = $_increse\n'
      '\t.totalAmount = $_totalAmount\n}';

  String get method => "Card";
  double get totalAmount => _totalAmount;
  String get paymentId => _paymentId;
  double get increse => _increse;
  Status get status => _status;

  @override
  Card access<Card>() => this as Card;
}


class Pix implements Response {
  final String _paymentId;
  final String _literal;
  final String _qrCode;
  final Status _status;

  Pix({
    required String paymentId,
    required String literal,
    required String qrCode,
    required Status status,
  }) : _paymentId = paymentId,
       _literal   = literal,
       _qrCode    = qrCode,
       _status    = status;

  @override
  String toString() => 
    'Payment(Pix) by BFlex F. Solutions {\n'
    '\t.paymentId = "$_paymentId"\n'
    '\t.status = ${_status.toString()}\n'
    '\t.literal = "$_literal"\n'
    '\t.qrCode = "$_qrCode"\n}';

  String get method => "Pix";
  String get paymentId => _paymentId;
  String get literal => _literal;
  String get qrCode => _qrCode;
  Status get status => _status;

  @override
  Pix access<Pix>() => this as Pix;
}


class InvalidResp implements Response {
  @override
  String toString() => 'Invalid response (Try debug the second value in the record)';
  
  String get method => "None"; 

  @override
  InvalidResp access<InvalidResp>() => this as InvalidResp;
}