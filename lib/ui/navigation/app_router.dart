import 'package:flutter/material.dart';
import 'package:taskpay/ui/screens/demo_home_screen.dart';
import 'package:taskpay/ui/screens/theme_settings_screen.dart';
import 'package:taskpay/ui/screens/auth/sign_in_screen.dart';
import 'package:taskpay/ui/screens/auth/sign_up_screen.dart';
import 'package:taskpay/ui/screens/auth/password_reset_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String passwordReset = '/password-reset';
  static const String login = '/login'; // Keep for backward compatibility
  static const String register = '/register'; // Keep for backward compatibility
  static const String profile = '/profile';
  static const String createProfile = '/create-profile';
  static const String editProfile = '/edit-profile';
  static const String taskDetails = '/task-details';
  static const String createTask = '/create-task';
  static const String editTask = '/edit-task';
  static const String taskDiscovery = '/discover';
  static const String myTasks = '/my-tasks';
  static const String bidding = '/bidding';
  static const String chat = '/chat';
  static const String chatRoom = '/chat-room';
  static const String payment = '/payment';
  static const String wallet = '/wallet';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String themeSettings = '/theme-settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const DemoHomeScreen(),
          settings: routeSettings,
        );
      
      // Authentication routes
      case signIn:
      case login: // Backward compatibility
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: routeSettings,
        );
      
      case signUp:
      case register: // Backward compatibility
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: routeSettings,
        );
      
      case passwordReset:
        return MaterialPageRoute(
          builder: (_) => const PasswordResetScreen(),
          settings: routeSettings,
        );
      
      // Profile routes
      case profile:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Profile'),
          settings: routeSettings,
        );
      
      case createProfile:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Create Profile'),
          settings: routeSettings,
        );
      
      case editProfile:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Edit Profile'),
          settings: routeSettings,
        );
      
      // Task routes
      case taskDetails:
        final taskId = routeSettings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            title: 'Task Details',
            subtitle: taskId != null ? 'Task ID: $taskId' : null,
          ),
          settings: routeSettings,
        );
      
      case createTask:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Create Task'),
          settings: routeSettings,
        );
      
      case editTask:
        final taskId = routeSettings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            title: 'Edit Task',
            subtitle: taskId != null ? 'Task ID: $taskId' : null,
          ),
          settings: routeSettings,
        );
      
      case taskDiscovery:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Discover Tasks'),
          settings: routeSettings,
        );
      
      case myTasks:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'My Tasks'),
          settings: routeSettings,
        );
      
      // Bidding routes
      case bidding:
        final taskId = routeSettings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            title: 'Bidding',
            subtitle: taskId != null ? 'Task ID: $taskId' : null,
          ),
          settings: routeSettings,
        );
      
      // Communication routes
      case chat:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Chat'),
          settings: routeSettings,
        );
      
      case chatRoom:
        final chatRoomId = routeSettings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            title: 'Chat Room',
            subtitle: chatRoomId != null ? 'Room ID: $chatRoomId' : null,
          ),
          settings: routeSettings,
        );
      
      // Payment routes
      case payment:
        final taskId = routeSettings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            title: 'Payment',
            subtitle: taskId != null ? 'Task ID: $taskId' : null,
          ),
          settings: routeSettings,
        );
      
      case wallet:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Wallet'),
          settings: routeSettings,
        );
      
      // Other routes
      case notifications:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Notifications'),
          settings: routeSettings,
        );
      
      case settings:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(title: 'Settings'),
          settings: routeSettings,
        );
      
      case themeSettings:
        return MaterialPageRoute(
          builder: (_) => const ThemeSettingsScreen(),
          settings: routeSettings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: routeSettings,
        );
    }
  }

  // Navigation helper methods
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}

// Placeholder screen for routes that haven't been implemented yet
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'This screen is under construction',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 404 screen for unknown routes
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '404',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}