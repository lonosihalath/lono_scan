import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lono_scan/lono_scan.dart';


void main() {
  const MethodChannel channel = MethodChannel('lono/scan');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LonoScan.platformVersion, '42');
  });
}
