import 'package:flutter_test/flutter_test.dart';

import 'package:streampay/streampay.dart';

void main() {
  test('Creacion de tkr', () async {
    final tkr = await StreamPay.createTKATime(
        '4yHAV9g94oM7oTOU', '8621349', '1636042022');
    print(tkr);
  });
}
