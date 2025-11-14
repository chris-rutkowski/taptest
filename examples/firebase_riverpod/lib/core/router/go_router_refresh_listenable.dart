import 'dart:async';

import 'package:flutter/material.dart';

final class GoRouterRefreshListenable extends ChangeNotifier {
  // ignore: unused_field
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshListenable(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  // Good practice, but since it will never be disposed, so it just affects code coverage.
  // @override
  // void dispose() {
  //   _subscription.cancel();
  //   super.dispose();
  // }
}
