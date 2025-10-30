import 'package:integration_test/integration_test.dart';

enum TestType {
  integration,
  widget,
}

TestType getTestType() {
  try {
    IntegrationTestWidgetsFlutterBinding.instance;
    return TestType.integration;
  } catch (_) {
    return TestType.widget;
  }
}
