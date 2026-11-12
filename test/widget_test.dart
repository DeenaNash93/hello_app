import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello_app/main.dart';

/// מוצא את ה-ListTile של סטודנט לפי שם
Finder tileOf(String name) =>
    find.ancestor(of: find.text(name), matching: find.byType(ListTile));

/// מוצא כפתור (פלוס/מינוס) בשורה של סטודנט מסוים
Finder buttonOf(String name, IconData icon) => find.descendant(
      of: tileOf(name),
      matching: find.widgetWithIcon(IconButton, icon),
    );

Future<void> tapTimes(WidgetTester tester, Finder f, int times) async {
  for (var i = 0; i < times; i++) {
    await tester.tap(f);
  }
  await tester.pump();
}

void main() {
  testWidgets('מציג 4 סטודנטים, ציונים וממוצע התחלתי', (tester) async {
    await tester.pumpWidget(const MyApp());

    for (final name in ['נועה', 'דנה', 'יוסף', 'עומר']) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('ציון: 92'), findsOneWidget);
    expect(find.text('ציון: 71'), findsOneWidget);
    expect(find.text('ציון: 54'), findsOneWidget);
    expect(find.text('ציון: 48'), findsOneWidget);

    // (92 + 71 + 54 + 48) / 4 = 66.25
    expect(find.text('ממוצע: 66.3'), findsOneWidget);
  });

  testWidgets('ווי ירוק לעוברים ואיקס אדום לנכשלים', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    expect(find.byIcon(Icons.cancel), findsNWidgets(2));

    expect(
      find.descendant(of: tileOf('נועה'), matching: find.byIcon(Icons.check_circle)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: tileOf('יוסף'), matching: find.byIcon(Icons.cancel)),
      findsOneWidget,
    );
  });

  testWidgets('פלוס מעלה ציון ומעדכן ממוצע; 55 הופך לעובר', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(buttonOf('יוסף', Icons.add));
    await tester.pump();

    expect(find.text('ציון: 55'), findsOneWidget);
    // (92 + 71 + 55 + 48) / 4 = 66.5
    expect(find.text('ממוצע: 66.5'), findsOneWidget);
    expect(
      find.descendant(of: tileOf('יוסף'), matching: find.byIcon(Icons.check_circle)),
      findsOneWidget,
    );
  });

  testWidgets('מינוס מוריד ציון; מתחת ל-55 הופך לנכשל', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tapTimes(tester, buttonOf('דנה', Icons.remove), 17);

    expect(find.text('ציון: 54'), findsNWidgets(2)); // דנה ויוסף
    expect(
      find.descendant(of: tileOf('דנה'), matching: find.byIcon(Icons.cancel)),
      findsOneWidget,
    );
  });

  testWidgets('הציון לא עולה מעל 100', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tapTimes(tester, buttonOf('נועה', Icons.add), 8);
    expect(find.text('ציון: 100'), findsOneWidget);

    final plus = tester.widget<IconButton>(buttonOf('נועה', Icons.add));
    expect(plus.onPressed, isNull); // הכפתור מושבת
  });

  testWidgets('הציון לא יורד מתחת ל-0', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tapTimes(tester, buttonOf('עומר', Icons.remove), 48);
    expect(find.text('ציון: 0'), findsOneWidget);

    final minus = tester.widget<IconButton>(buttonOf('עומר', Icons.remove));
    expect(minus.onPressed, isNull);
  });
}
