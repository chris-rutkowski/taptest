final class CustomFont {
  final String familyName;
  final Iterable<String> files;

  const CustomFont._({
    required this.familyName,
    required this.files,
  }) : assert(
         files.length > 0,
         'At least one font file must be provided for font: `$familyName`.',
       );

  factory CustomFont({
    required String familyName,
    required String file,
  }) {
    return CustomFont._(familyName: familyName, files: [file]);
  }

  factory CustomFont.multiple({
    required String familyName,
    required Iterable<String> files,
  }) {
    return CustomFont._(familyName: familyName, files: files);
  }
}
