import 'package:http/http.dart' as http;
import 'dart:convert';

import './models/server/payments.dart';
export './models/server/payments.dart';

import './models/client/payments.dart';
export './models/client/payments.dart';

class Client {
  final String auth;
  final Payments payments;

  Client._(this.auth, this.payments);

  /// # Login
  /// 
  /// Enter your BFlex Financial Solutions access code.
  /// Here we will save important information about your account.
  ///
  /// # _DO NOT SHARE THIS KEY WITH ANYONE!_
  static Client login(String authKey) {
    final payments = Payments._call('Bearer $authKey');
    
    return Client._(authKey, payments);
  }
}

class Payments {
  final String _api = 'http://127.0.0.1:8080';
  final String _auth;

  Payments._(this._auth);

  static Payments _call(String token) {
    return Payments._(token);
  }

  /// # Create payments
  /// 
  /// This function creates a payment using BFlex Financial Solutions
  /// 
  /// # Examples
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
  /// print(response);
  /// ```
  Future<(Response, String?)> create(PaymentCreate data) async {
    String? error;
    Response ok = InvalidResp();

    try {
      final String method =  
        data is PixCreate ? 'Pix' :
        data is CardCreate ? 'Card' :
        throw UnsupportedError('Invalid data type');

      final payload = data.payload();

      final url = Uri.parse('$_api/payment/create');
      final request = http.Request('POST', url)..headers.addAll({
          'Content-type': 'application/json',
          'Authorization-key': _auth
        },
      )
      ..body = json.encode(payload);

      final response = await request.send();
      final content = await response.stream.bytesToString();
      final contentJson = json.decode(content);
      final received = contentJson['data'] as Map<String, dynamic>;

      if( received.containsKey('error') ) {
        error = received['error'];
      } 

      ok = Response.validate(method, received);

    } catch (_) {
      return (ok, 'Failed request');
    }

    return (ok, error);
  }

  /// # Get payment information
  /// 
  /// To collect payment data, you need to use the `obtain` function.
  /// 
  /// This way, we can collect all the information necessary for your system to work.
  /// 
  /// ## You can:
  /// 
  /// - Collect the payment qrCode again
  /// - Collect the transaction status
  /// - Collect the cause of the failure (if it fails)
  /// - _Among other data..._
  /// 
  /// # Exemple
  /// 
  /// ```dart
  /// // Create the payment
  /// final (response, err) = await payments.create(PixCreate( ... ));
  /// 
  /// // Ensures that there are no errors when creating the payment
  /// if( err != null ) {
  ///   print("Error returned when generating payment: $err");
  /// }
  /// 
  /// // Collects PIX (casted)
  /// final pix = response.access<Pix>();
  /// 
  /// // Collects and prints payment data
  /// final info = await payments.obtain(pix.paymentId);
  /// print(info);
  /// 
  /// ```
  Future<(Response, String?)> obtain(String id) async {
    String? error;
    Response ok = InvalidResp();

    try {

      final url = Uri.parse('$_api/payment/get/$id');
      final request = http.Request('GET', url)..headers.addAll({
        'Content-type': 'application/json',
        'Authorization-key': _auth
      });

      final response = await request.send();
      final content = await response.stream.bytesToString();
      final contentJson = json.decode(content);
      final data = contentJson['data'] as Map<String, dynamic>;

      if( data.containsKey('error') ) {
        error = data['error'];
      } 

      ok = Response.parse(data, id);

    } catch(_) {
      return (ok, 'Failed request');
    }

    return (ok, error);
  }
}