import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:platform/platform.dart';

// Original source:
// https://github.com/Flutter-Bounty-Hunters/flutter_test_goldens/blob/main/lib/src/fonts/icons.dart
//
// Copyright (c) 2025 Declarative, Inc.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE
Future<void> loadMaterialIconsFont() {
  const fileSystem = LocalFileSystem();

  final flutterRoot = fileSystem.directory(
    LocalPlatform().environment['FLUTTER_ROOT'],
  );

  final iconFile = flutterRoot.childFile(
    fileSystem.path.join(
      'bin',
      'cache',
      'artifacts',
      'material_fonts',
      'MaterialIcons-Regular.otf',
    ),
  );

  final fontLoader = FontLoader('MaterialIcons');
  fontLoader.addFont(
    Future.value(
      iconFile.readAsBytesSync().buffer.asByteData(),
    ),
  );

  return fontLoader.load();
}
