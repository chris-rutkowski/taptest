import 'package:flutter/services.dart';

import '../config/custom_font.dart';

Future<void> loadCustomFonts(Iterable<CustomFont> customFonts) async {
  for (final font in customFonts) {
    final fontLoader = FontLoader(font.familyName);

    for (final file in font.files) {
      final fontData = await rootBundle.load(file);
      fontLoader.addFont(Future.value(fontData));
    }

    await fontLoader.load();
  }
}
