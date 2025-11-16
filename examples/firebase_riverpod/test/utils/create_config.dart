import 'package:firebase_riverpod/demo_app.dart';
import 'package:firebase_riverpod/features/auth/data_domain/app_user.dart';
import 'package:firebase_riverpod/features/auth/data_domain/auth_repository_provider.dart';
import 'package:firebase_riverpod/features/memos/data_domain/memos_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taptest/taptest.dart';

import '../mocks/mock_auth_repository.dart';
import '../mocks/mock_memos_repository.dart';

Config createConfig({AppUser? user, Iterable<AppUserWithPassword>? allUsers, String? initialRoute}) {
  final config = Config(
    initialRoute: initialRoute,
    variants: Variant.lightAndDarkVariants,
    builder: (params) {
      final providerContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            MockAuthRepository(
              user: user,
              allUsers: allUsers,
            ),
          ),
          memosRepositoryProvider.overrideWithValue(
            MockMemosRepository(),
          ),
        ],
      );

      return UncontrolledProviderScope(
        container: providerContainer,
        child: DemoApp(params: params),
      );
    },
  );

  return config;
}
