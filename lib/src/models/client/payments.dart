sealed class PaymentCreate {
  Map<String, dynamic> payload() => {
    '_': 0
  };
}

class CardCreate implements PaymentCreate {
  final int expirationMonth;
  final int expirationYear;
  final String payerEmail;
  final String payerName;
  final String payerCpf;
  final double amount;
  final String number;
  final String cvv;

  CardCreate({
    required this.expirationMonth,
    required this.expirationYear,
    required this.payerEmail,
    required this.payerName,
    required this.payerCpf,
    required this.amount,
    required this.number,
    required this.cvv
  });

  @override
  Map<String, dynamic> payload() => {
    'method': 'Card',
    // Payload content
    'expiration_month': expirationMonth,
    'expiration_year': expirationYear,
    'payer_email': payerEmail,
    'payer_name': payerName,
    'payer_cpf': payerCpf,
    'amount': amount,
    'number': number,
    'cvv': cvv,
  };
}

class PixCreate implements PaymentCreate {
  final String payerEmail;
  final String payerCpf; 
  final double amount;

  PixCreate({
    required this.payerEmail,
    required this.payerCpf,
    required this.amount
  });

  @override
  Map<String, dynamic> payload() => {
    'method': 'Pix',
    // Payload content
    'payer_email': payerEmail,
    'payer_cpf': payerCpf,
    'amount': amount
  };
}