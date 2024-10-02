import 'package:flutter_app/view_models/all_drink_waters_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/view_models/me_vm.dart';
import 'package:flutter_app/views/drink_water_page.dart';
import 'package:flutter_app/views/wiki/wiki_list_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/views/cover_page.dart';
import 'package:flutter_app/views/auth_page.dart';
import 'package:flutter_app/views/nav_bar.dart';
import 'package:flutter_app/views/goal/goal_details_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/services/authentication.dart';

final routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/cover',
      pageBuilder: (context, state) => const NoTransitionPage<void>(
        child: CoverPage(),
      ),
      routes: <RouteBase>[
        GoRoute(
          path: 'auth',
          builder: (context, state) => const AuthPage(),
        )
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        final myId = Provider.of<AuthenticationService>(context, listen: false).checkAndGetLoggedInUserId();

        if (myId == null) {
          debugPrint('Warning: ShellRoute should not be built without a user');
          return const SizedBox.shrink();
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<MeViewModel>(
              create: (_) => MeViewModel(myId),
            ),
            ChangeNotifierProvider<AllDrinkWatersViewModel>(
              create: (_) => AllDrinkWatersViewModel(),
            ),
          ],
          child: child
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const NavBar(selectedTab: HomeTab.home),
          routes: <RouteBase>[
            GoRoute(
              path: 'drinkwater',
              builder: (context, state) => const DrinkWaterPage()
            )
          ]
        ),
        GoRoute(
          path: '/plant',
          builder: (context, state) => const NavBar(selectedTab: HomeTab.plant),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const NavBar(selectedTab: HomeTab.chat),
          // routes: <RouteBase>[
          //   GoRoute(
          //     path: 'inform',
          //     builder: (context, state) => const ChatInformPage(),
          //   ),
          // ],
        ),
        GoRoute(
          path: '/goal',
          builder: (context, state) => const NavBar(selectedTab: HomeTab.goal),
          routes: <RouteBase>[
            GoRoute(
              path: ':goalId',
              builder: (context, state) => GoalDetailsPage(goalId: state.pathParameters['goalId']!),
            )
          ]
        ),
        GoRoute(
          path: '/wiki',
          builder: (context, state) => WikiListPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const NavBar(selectedTab: HomeTab.profile),
        ),
      ],
    ),
  ],
  initialLocation: '/cover',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final currentPath = state.uri.path;
    final isLoggedIn = Provider.of<AuthenticationService>(context, listen: false)
                .checkAndGetLoggedInUserId() != null;
    if (isLoggedIn && currentPath == '/cover/auth') {
      return '/home';
    }
    if (!isLoggedIn && currentPath != '/cover/auth') {
      // Redirect to auth page if the user is not logged in
      return '/cover';
    }
    if (currentPath == '/') {
      return '/home';
    }
    // No redirection needed for other routes
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);

class NavigationService {
  late final GoRouter _router;

  NavigationService() {
    _router = routerConfig;
  }

  void goAuth() {
    _router.go('/cover/auth');
  }

  void goHome({required HomeTab tab}) {
    _router.go('/${tab.name}');
  }

  void goGoalDetailsOnCategory({required String goalId}) {
    _router.go('/goal/$goalId');
  }

  void goDrinkWater() {
    _router.go('/home/drinkwater');
  }

  void pop(BuildContext context) {
    _router.pop(context);
  }

  // void goInform() {
  //   _router.go('/chat/inform'); // Add navigation to InformPage
  // }
}
