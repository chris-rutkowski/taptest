import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:qr/qr.dart';

import 'http_method.dart';
import 'mock_http_request_handler.dart';
import 'mock_http_response.dart';

final class ToQrImageHttpRequestHandler implements MockHttpRequestHandler {
  /// The size of the generated QR code image in pixels (both width and height).
  final int size;

  /// A callback to determine if this handler should handle the given [uri] and [method].
  final bool Function(Uri uri, HttpMethod method) handleCallback;

  const ToQrImageHttpRequestHandler(
    this.handleCallback, {
    this.size = 256,
  });

  @override
  bool canHandle(Uri uri, HttpMethod method, String path) {
    return method == HttpMethod.get && uri.path.startsWith('/img');
  }

  @override
  Future<MockHttpResponse?> handle(Uri uri, HttpHeaders headers, String? body) async {
    final headersMap = <String, List<String>>{};
    headers.forEach((name, values) => headersMap[name] = values);

    final payload = jsonEncode({
      'uri': uri.toString(),
      'headers': headersMap,
      'body': body,
    });

    final qrCode = QrCode.fromData(
      data:
          sha1 //
              .convert(utf8.encode(payload))
              .toString()
              .substring(0, 8),
      errorCorrectLevel: QrErrorCorrectLevel.L,
    );

    return MockHttpResponse(
      headers: {
        HttpHeaders.contentTypeHeader: 'image/bmp',
      },
      body: QrImage(qrCode).toBmpBytes(size: size),
    );
  }
}

extension on QrImage {
  Uint8List toBmpBytes({required int size}) {
    final moduleSize = size / (moduleCount + 2);

    // Calculate BMP file size
    final headerSize = 54;
    final imageDataSize = size * size * 3; // RGB = 3 bytes per pixel
    final totalSize = headerSize + imageDataSize;

    final bytes = Uint8List(totalSize);
    final data = ByteData.view(bytes.buffer);

    // BMP Header (14 bytes)
    bytes[0] = 0x42; // 'B'
    bytes[1] = 0x4D; // 'M'
    data.setUint32(2, totalSize, Endian.little); // File size
    data.setUint32(6, 0, Endian.little); // Reserved
    data.setUint32(10, headerSize, Endian.little); // Offset to image data

    // DIB Header (40 bytes)
    data.setUint32(14, 40, Endian.little); // DIB header size
    data.setUint32(18, size, Endian.little); // Width
    data.setUint32(22, size, Endian.little); // Height
    data.setUint16(26, 1, Endian.little); // Planes
    data.setUint16(28, 24, Endian.little); // Bits per pixel (RGB)
    data.setUint32(30, 0, Endian.little); // Compression (none)
    data.setUint32(34, imageDataSize, Endian.little); // Image data size
    data.setUint32(38, 2835, Endian.little); // X pixels per meter
    data.setUint32(42, 2835, Endian.little); // Y pixels per meter
    data.setUint32(46, 0, Endian.little); // Colors in color table
    data.setUint32(50, 0, Endian.little); // Important color count

    // Generate pixel data directly (BMP is bottom-up, so start from bottom row)
    int pixelIndex = headerSize;
    for (int y = size - 1; y >= 0; y--) {
      for (int x = 0; x < size; x++) {
        // Default to white
        var isBlack = false;

        // Check if this pixel should be black (QR module)
        final qrX = ((x - moduleSize) / moduleSize).floor();
        final qrY = ((y - moduleSize) / moduleSize).floor();

        if (qrX >= 0 && qrX < moduleCount && qrY >= 0 && qrY < moduleCount) {
          isBlack = isDark(qrY, qrX);
        }

        if (isBlack) {
          bytes[pixelIndex++] = 0; // B
          bytes[pixelIndex++] = 0; // G
          bytes[pixelIndex++] = 0; // R
        } else {
          bytes[pixelIndex++] = 255; // B
          bytes[pixelIndex++] = 255; // G
          bytes[pixelIndex++] = 255; // R
        }
      }
    }

    return bytes;
  }
}
