import 'package:country_info/core/presentation/widgets/hero_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeroText', () {
    testWidgets('should display text correctly', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'United States', tag: 'country_name'),
          ),
        ),
      );

      // assert
      expect(find.text('United States'), findsOneWidget);
    });

    testWidgets('should have Hero widget with correct tag', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'France', tag: 'country_FR'),
          ),
        ),
      );

      // assert
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'country_FR');
    });

    testWidgets('should use Material with transparency', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'Germany', tag: 'test_tag'),
          ),
        ),
      );

      // assert
      final material = tester.widget<Material>(find.byType(Material).last);
      expect(material.type, MaterialType.transparency);
    });

    testWidgets('should apply custom style when provided', (tester) async {
      // arrange
      const customStyle = TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      );

      // act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'Italy', tag: 'italy_tag', style: customStyle),
          ),
        ),
      );

      // assert
      final text = tester.widget<Text>(find.text('Italy'));
      expect(text.style?.fontSize, 24);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.color, Colors.blue);
    });

    testWidgets('should use default style when style is null', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'Spain', tag: 'spain_tag'),
          ),
        ),
      );

      // assert
      final text = tester.widget<Text>(find.text('Spain'));
      expect(text.style, null);
    });

    testWidgets('should display empty text', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: '', tag: 'empty_tag'),
          ),
        ),
      );

      // assert
      expect(find.text(''), findsWidgets);
      expect(find.byType(HeroText), findsOneWidget);
    });

    testWidgets('should display long text', (tester) async {
      // arrange
      const longText =
          'This is a very long country name that spans multiple words';

      // act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: longText, tag: 'long_tag'),
          ),
        ),
      );

      // assert
      expect(find.text(longText), findsOneWidget);
    });

    testWidgets('should work with Hero animations', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [HeroText(text: 'Canada', tag: 'shared_tag')],
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(Hero), findsOneWidget);
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'shared_tag');
    });

    testWidgets('should display special characters', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'العربية', tag: 'arabic_tag'),
          ),
        ),
      );

      // assert
      expect(find.text('العربية'), findsOneWidget);
    });

    testWidgets('should have correct widget tree structure', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'Japan', tag: 'japan_tag'),
          ),
        ),
      );

      // assert - verify Hero > Material > Text structure
      final heroFinder = find.byType(Hero);
      expect(heroFinder, findsOneWidget);

      final materialFinder = find.descendant(
        of: heroFinder,
        matching: find.byType(Material),
      );
      expect(materialFinder, findsOneWidget);

      final textFinder = find.descendant(
        of: materialFinder,
        matching: find.text('Japan'),
      );
      expect(textFinder, findsOneWidget);
    });

    testWidgets('should handle different tags for different instances', (
      tester,
    ) async {
      // arrange & act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                HeroText(text: 'First', tag: 'tag_1'),
                HeroText(text: 'Second', tag: 'tag_2'),
              ],
            ),
          ),
        ),
      );

      // assert
      final heroes = tester.widgetList<Hero>(find.byType(Hero)).toList();
      expect(heroes.length, 2);
      expect(heroes[0].tag, 'tag_1');
      expect(heroes[1].tag, 'tag_2');
    });

    testWidgets('should render without errors', (tester) async {
      // arrange & act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(text: 'Test', tag: 'test_tag'),
          ),
        ),
      );

      // assert
      expect(tester.takeException(), isNull);
    });

    testWidgets('should apply style with different properties', (tester) async {
      // arrange
      const customStyle = TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
      );

      // act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroText(
              text: 'Styled Text',
              tag: 'styled_tag',
              style: customStyle,
            ),
          ),
        ),
      );

      // assert
      final text = tester.widget<Text>(find.text('Styled Text'));
      expect(text.style?.fontSize, 18);
      expect(text.style?.fontStyle, FontStyle.italic);
      expect(text.style?.decoration, TextDecoration.underline);
    });
  });
}
