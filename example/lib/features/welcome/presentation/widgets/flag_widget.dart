import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';

final class FlagWidget extends StatelessWidget {
  const FlagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    final flagAsset = switch (locale.languageCode) {
      'en' => switch (locale.countryCode) {
        'US' => Assets.images.usa,
        'GB' || _ => Assets.images.uk,
      },
      'es' => Assets.images.es,
      _ => Assets.images.usa,
    };

    return ClipOval(
      child: flagAsset.image(width: 32, height: 32),
    );
  }
}
