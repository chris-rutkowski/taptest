import 'package:flutter/material.dart';

/// A special character used as a placeholder:
/// - in [RichText] to represent [WidgetSpan]
///
/// In a Rich text like `Hello [User Icon] <b>Chris</b>`, you can use it like:
/// `tester.expectText(Keys.label, 'Hello ${objectReplacementCharacter} Chris');`
const String objectReplacementCharacter = '\uFFFC';
