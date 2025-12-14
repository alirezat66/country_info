import 'package:country_info/features/country/presentation/views/widgets/country_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryListItem', () {
    testWidgets('should display flag, name, and chevron icon', (tester) async {
      // arrange
      bool tapped = false;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              flag: '🇺🇸',
              name: 'United States',
              countryCode: 'US',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // assert
      expect(find.text('🇺🇸'), findsOneWidget);
      expect(find.text('United States'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // arrange
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              flag: '🇨🇦',
              name: 'Canada',
              countryCode: 'CA',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // act
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      // assert
      expect(tapped, true);
    });

    testWidgets('should display different country information correctly',
        (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              flag: '🇬🇧',
              name: 'United Kingdom',
              countryCode: 'GB',
              onTap: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('🇬🇧'), findsOneWidget);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('should have correct flag font size', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryListItem(
              flag: '🇫🇷',
              name: 'France',
              countryCode: 'FR',
              onTap: () {},
            ),
          ),
        ),
      );

      // assert
      final textWidget = tester.widget<Text>(find.text('🇫🇷'));
      expect(textWidget.style?.fontSize, 32);
    });
  });
}

