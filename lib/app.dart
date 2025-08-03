import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taskpay/ui/theme/app_theme.dart';
import 'package:taskpay/ui/theme/theme_provider.dart';
import 'package:taskpay/ui/navigation/app_router.dart';
import 'package:taskpay/ui/blocs/auth/index.dart';
import 'package:taskpay/ui/screens/auth/auth_wrapper.dart';

class TaskPayApp extends StatelessWidget {
  const TaskPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(const AuthCheckRequested()),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider()..loadThemeMode(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              title: 'TaskPay',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.materialThemeMode,
              home: const AuthWrapper(),
              onGenerateRoute: AppRouter.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
