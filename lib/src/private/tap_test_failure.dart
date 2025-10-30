final class TapTestFailure implements Exception {
  final String message;
  final bool retriable;

  const TapTestFailure(
    this.message, {
    this.retriable = true,
  });

  @override
  String toString() => message.toString();
}
