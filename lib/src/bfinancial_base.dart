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
      final brute = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization-key': _auth
        },
        body: json.encode(payload)
      );

      final response = json.decode(brute.body);
      final rData = response['data'] as Map<String, dynamic>;

      if( rData.containsKey('error') ) {
        error = rData['error'];
      } 

      ok = Response.validate(method, rData);

    } catch (_) {
      return (ok, 'Failed request');
    }

    return (ok, error);
  }
}