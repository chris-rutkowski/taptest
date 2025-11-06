import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:platform/platform.dart';

Future<void> loadRobotoFont() async {
  const fileSystem = LocalFileSystem();

  final flutterRoot = fileSystem.directory(
    LocalPlatform().environment['FLUTTER_ROOT'],
  );

  final materialFontsDir = flutterRoot.childDirectory(
    fileSystem.path.join('bin', 'cache', 'artifacts', 'material_fonts'),
  );

  final entities = materialFontsDir.listSync();

  final fontLoader = FontLoader('Roboto');

  for (final entity in entities) {
    if (entity is File) {
      final filename = fileSystem.path.basename(entity.path);
      if (!filename.startsWith('Roboto') || !filename.endsWith('.ttf')) {
        continue;
      }

      fontLoader.addFont(
        Future.value(
          entity.readAsBytesSync().buffer.asByteData(),
        ),
      );
    }
  }

  await fontLoader.load();
}
