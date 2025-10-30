import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

Widget defaultWidgetQRStubBuilder(String src, double? width, double? height, BoxFit? fit) {
  return WidgetQRStub(
    src: src,
    width: width,
    height: height,
    fit: fit,
  );
}

final class WidgetQRStub extends StatelessWidget {
  static const _defaultSize = 32.0;

  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const WidgetQRStub({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final payload = jsonEncode({
      'src': src,
      'width': width,
      'height': height,
      'fit': fit?.toString(),
    });

    final qrCode = QrCode.fromData(
      data: sha1.convert(utf8.encode(payload)).toString().substring(0, 8),
      errorCorrectLevel: QrErrorCorrectLevel.L,
    );

    return SizedBox(
      width: width ?? _defaultSize,
      height: height ?? _defaultSize,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: CustomPaint(
            painter: _Painter(QrImage(qrCode)),
          ),
        ),
      ),
    );
  }
}

final class _Painter extends CustomPainter {
  final QrImage qrImage;

  const _Painter(this.qrImage);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final moduleCount = qrImage.moduleCount;
    final moduleSize = size.width / (moduleCount + 2);

    for (int x = 0; x < moduleCount; x++) {
      for (int y = 0; y < moduleCount; y++) {
        if (!qrImage.isDark(y, x)) continue;

        final rect = Rect.fromLTWH(
          (x + 1) * moduleSize,
          (y + 1) * moduleSize,
          moduleSize,
          moduleSize,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Painter || oldDelegate.qrImage != qrImage;
  }
}
