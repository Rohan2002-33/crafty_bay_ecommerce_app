import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  testWidgets('four-digit PIN field reports the completed code', (
    tester,
  ) async {
    final controller = PinInputController();
    String? completedPin;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MaterialPinField(
            length: 4,
            pinController: controller,
            onCompleted: (pin) => completedPin = pin,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), '1234');
    await tester.pump();

    expect(controller.text, '1234');
    expect(completedPin, '1234');

    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });
}
