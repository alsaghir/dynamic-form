import 'package:dynamic_form_client/infra/providers.dart';
import 'package:dynamic_form_client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });


  group('MyApp Widget Tests', () {
    testWidgets('MyApp initialization test - loading state', (WidgetTester tester) async {

      // Pump the MyApp widget wrapped in ProviderScope
      await tester.pumpWidget(UncontrolledProviderScope
        (container: container, child: const MyApp()));


      // Initially, we should see a loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('MyApp initialization test - success state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(ProviderScope(child: const MyApp()));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Verify that MaterialApp.router is rendered
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp initialization test - error state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            Providers.asyncConfigProvider.overrideWith(
              (ref) async => throw Exception('Test error'),
            ),
          ],
          child: const MyApp(),
        ),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Verify that error text is displayed
      expect(find.byType(Text), findsOneWidget);
      expect(find.textContaining('Exception: Test error'), findsOneWidget);
    });
  });
}
