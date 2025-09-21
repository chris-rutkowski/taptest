import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/http_screen/http_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
final class Router extends _$Router {
  @override
  GoRouter build() {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      // refreshListenable: RouterRefreshChangeNotifier(ref),
      // redirect: (_, state) async {
      //   final isLoggedIn = await ref.read(isLoggedInProvider.future);
      //   final path = state.uri.path;

      //   // redirect logged in user to member if needed
      //   if (isLoggedIn && !path.startsWith('/member')) {
      //     return '/member';
      //   }

      //   // redirect guest to non-member area if needed
      //   if (!isLoggedIn && path.startsWith('/member')) {
      //     return '/';
      //   }

      //   return null;
      // },
      routes: [
        // Anonymous only
        GoRoute(
          path: '/',
          builder: (context, state) => const WelcomeScreen(),
          routes: [
          //   GoRoute(
          //     path: 'login',
          //     builder: (context, state) => const LoginScreen(),
          //   ),
          //   GoRoute(
          //     path: 'registration',
          //     builder: (context, state) => const RegistrationNameScreen(),
          //   ),
          //   GoRoute(
          //     path: 'diagnostics',
          //     builder: (context, state) => const DiagnosticsScreen(),
          //   ),
          //   GoRoute(
          //     path: 'long',
          //     builder: (context, state) => const LongScreen(),
          //   ),
            GoRoute(
              path: 'http',
              builder: (context, state) => const HttpScreen(),
            ),
          //   GoRoute(
          //     path: 'menu',
          //     builder: (context, state) => const MenuScreen(),
          //   ),
          ],
        ),

        // Member only
        // GoRoute(
        //   path: '/member',
        //   builder: (context, state) => const DashboardScreen(),
        //   routes: [
        //     GoRoute(
        //       path: 'profile',
        //       builder: (context, state) => const ProfileScreen(),
        //     ),
        //     GoRoute(
        //       path: 'promotions',
        //       builder: (context, state) => const PromotionsListScreen(),
        //       routes: [
        //         GoRoute(
        //           path: ':id',
        //           builder: (context, state) {
        //             final id = state.pathParameters['id']!;
        //             return PromotionDetailScreen(id: id);
        //           },
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
