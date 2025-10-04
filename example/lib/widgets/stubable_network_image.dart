import 'package:flutter/material.dart';

import 'common_keys.dart';

final class StubableNetworkImage extends StatelessWidget {
  static Widget Function(String source, double? width, double? height, BoxFit? fit)? stubBuilder;

  final String source;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const StubableNetworkImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (stubBuilder != null) {
      return stubBuilder!(source, width, height, fit);
    }

    // Feel free to use CachedNetworkImage or similar
    return Image.network(
      source,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        final isLoaded = (frame != null || wasSynchronouslyLoaded);

        if (isLoaded) {
          return child;
        }

        return KeyedSubtree(
          key: CommonKeys.loadingNetworkImage,
          child: child,
        );
      },
    );
  }
}
