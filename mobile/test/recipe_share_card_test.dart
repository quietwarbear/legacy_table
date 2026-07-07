import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:family_recipe_app/models/recipe.dart';
import 'package:family_recipe_app/widgets/recipe_share_sheet.dart';

Recipe _recipe({String? story, String? authorName}) => Recipe(
      id: 'abcdef1234567890',
      title: "Grandma Rose's Gumbo",
      ingredients: const ['1 cup flour', '1 cup vegetable oil'],
      instructions: 'Stir until it looks like Louisiana.',
      story: story,
      authorId: 'user-1',
      authorName: authorName,
      createdAt: DateTime(2026, 7, 1),
      updatedAt: DateTime(2026, 7, 1),
    );

void main() {
  testWidgets('share card shows title, author, story, and brand footer',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: RecipeShareCard(
            recipe: _recipe(
              story: 'She stirred until it looked like Louisiana.',
              authorName: 'Doc Touré',
            ),
          ),
        ),
      ),
    ));

    expect(find.text("Grandma Rose's Gumbo"), findsOneWidget);
    expect(find.text('Doc Touré'), findsOneWidget);
    expect(find.textContaining('looked like Louisiana'), findsOneWidget);
    expect(find.text('Made with Legacy Table'), findsOneWidget);
    expect(find.text('legacytable.app'), findsOneWidget);
  });

  testWidgets('share card renders without story or author', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Center(child: RecipeShareCard(recipe: _recipe()))),
    ));

    expect(find.text("Grandma Rose's Gumbo"), findsOneWidget);
    expect(find.text('Made with Legacy Table'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('share card rasterizes to a non-empty PNG at 3x',
      (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: key,
            child: RecipeShareCard(
              recipe: _recipe(story: 'A story worth keeping.'),
            ),
          ),
        ),
      ),
    ));

    // Same capture path the sheet's "Share as card" button runs.
    final bytes = await tester.runAsync(() async {
      final boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data;
    });

    expect(bytes, isNotNull);
    expect(bytes!.lengthInBytes, greaterThan(10000),
        reason: 'a real card render should be a substantial PNG');
  });
}
