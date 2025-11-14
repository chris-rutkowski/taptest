import 'package:go_router/go_router.dart';

import '../../features/auth/data_domain/auth_repository.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/misc/about_screen.dart';
import 'go_router_refresh_listenable.dart';

GoRouter createGoRouter({required AuthRepository authRepository, String? initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,

    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final path = state.uri.path;

      if (authRepository.user == null && path.startsWith('/member')) {
        return '/';
      }

      if (authRepository.user != null && !path.startsWith('/member')) {
        return '/member';
      }

      return null;
    },
    refreshListenable: GoRouterRefreshListenable(authRepository.userStream),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RegisterScreen(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: 'about',
            builder: (context, state) => AboutScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/member',
        pageBuilder: (_, _) => const NoTransitionPage(
          child: DashboardScreen(),
        ),
      ),
    ],
  );
}
