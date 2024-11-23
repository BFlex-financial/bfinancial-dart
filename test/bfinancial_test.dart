import 'package:bfinancial/bfinancial.dart';
import 'package:test/test.dart';

void main() {
  group('main tests', () {
    test('forced failure', () async {
      final client = Client.login("admin");
      final payments = client.payments;

      var (response, err) = await payments.create(PixCreate(
        payerEmail: 'lucasdwbfff@gmail.com',
        payerCpf: '1245678910',
        amount: .01,
      ));

      expect(err, null);

      print(response.access<Pix>().literal);

      final (approved, status) = await response.access<Pix>().check((client, "approved"));
      if( approved ) {
        print("Pagamento aprovado");
      }

      String paymentId = response.access<Pix>().paymentId;
      (response, err) = await payments.obtain(paymentId);
      print(response);

      expect(err, null);

      
    });
  });
}
