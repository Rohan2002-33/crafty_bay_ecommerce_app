import 'package:crafty_bay/controllers/auth_controller.dart';
import 'package:crafty_bay/controllers/cart_controller.dart';
import 'package:crafty_bay/controllers/home_controller.dart';
import 'package:crafty_bay/controllers/nav_controller.dart';
import 'package:crafty_bay/controllers/wishlist_controller.dart';
import 'package:crafty_bay/core/widgets/quantity_stepper.dart';
import 'package:crafty_bay/data/models/product_model.dart';
import 'package:crafty_bay/views/auth/login_screen.dart';
import 'package:crafty_bay/views/auth/otp_screen.dart';
import 'package:crafty_bay/views/auth/signup_screen.dart';
import 'package:crafty_bay/views/auth/splash_screen.dart';
import 'package:crafty_bay/views/cart/cart_screen.dart';
import 'package:crafty_bay/views/shared/product_card.dart';
import 'package:crafty_bay/views/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(NavController());
    Get.put(AuthController());
    Get.put(CartController());
    Get.put(WishlistController());
    Get.put(HomeController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('four-digit PIN field reports the completed code', (tester) async {
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

  testWidgets('QuantityStepper increments and decrements correctly', (tester) async {
    int value = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return QuantityStepper(
                value: value,
                onChanged: (v) => setState(() => value = v),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('01'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(value, 2);
    expect(find.text('02'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(value, 1);
    expect(find.text('01'), findsOneWidget);
  });

  testWidgets('SplashScreen displays Version 1.0 and indicator', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(name: '/login', page: () => const Scaffold(body: Text('Login Page'))),
          GetPage(name: '/main', page: () => const Scaffold(body: Text('Main Page'))),
        ],
      ),
    );

    expect(find.text('Version 1.0'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('LoginScreen renders Welcome Back and email field', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Please Enter Your Email Address'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('OtpScreen renders Enter OTP Code and 4-digit input', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: OtpScreen(email: 'test@example.com', password: 'password'),
      ),
    );

    expect(find.text('Enter OTP Code'), findsOneWidget);
    expect(find.text('A 4 Digit OTP Code has been Sent'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.byType(MaterialPinField), findsOneWidget);
  });

  testWidgets('SignUpScreen renders Complete Profile fields', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: SignUpScreen(),
      ),
    );

    expect(find.text('Complete Profile'), findsNWidgets(2));
    expect(find.text('Get started with us with your details'), findsOneWidget);
    expect(find.text('Complete'), findsOneWidget);
  });

  testWidgets('ProductCard displays title, price and wishlist button', (tester) async {
    const product = Product(
      id: 'test_shoe',
      title: 'New Year Special Shoe',
      currentPrice: 100,
      rating: 4.8,
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: ProductCard(product: product, width: 120),
        ),
      ),
    );

    expect(find.text('New Year Special Shoe'), findsOneWidget);
    expect(find.text('\$100'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('CartScreen renders Cart title and Checkout button', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: CartScreen(),
      ),
    );

    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Total Price'), findsOneWidget);
  });

  testWidgets('WishlistScreen renders Wish List title and grid items', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: WishlistScreen(),
      ),
    );

    expect(find.text('Wish List'), findsOneWidget);
    expect(find.byType(ProductCard), findsWidgets);
  });
}

