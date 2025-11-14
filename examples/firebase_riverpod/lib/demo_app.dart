import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taptest_runtime/taptest_runtime.dart';

import 'core/router/create_go_router.dart';
import 'features/auth/data_domain/auth_repository_provider.dart';

final class DemoApp extends ConsumerStatefulWidget {
  final RuntimeParams? params;
  const DemoApp({super.key, this.params});

  @override
  ConsumerState<DemoApp> createState() => _DemoAppState();
}

final class _DemoAppState extends ConsumerState<DemoApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();

    router = createGoRouter(
      authRepository: ref.read(authRepositoryProvider),
      initialLocation: widget.params?.initialRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ?widget.params?.themeMode,
        ?widget.params?.locale,
      ]),
      builder: (context, _) {
        return MaterialApp.router(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.params?.themeMode.value,
          debugShowCheckedModeBanner: widget.params == null,
          routerConfig: router,
        );
      },
    );
  }
}
