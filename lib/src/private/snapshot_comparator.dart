import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final class SnapshotComparator extends LocalFileComparator {
  final double acceptableDifference;
  final void Function(ComparisonResult result) onResult;

  SnapshotComparator(
    super.testFile,
    this.acceptableDifference,
    this.onResult,
  ) : assert(acceptableDifference >= 0 && acceptableDifference <= 1);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    onResult(result);

    if (result.passed || result.diffPercent <= acceptableDifference) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
