import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone/state/auth/provider/is_logged_in_provider.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtool show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

extension Log on Object {
  void log() => devtool.log(
        toString(),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
            indicatorColor: Colors.blueGrey),
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: Consumer(builder: ((context, ref, child) {
          final isloggedIn = ref.watch(isLoggedInProvider);
          if (isloggedIn) {
            return const MainView();
          }
          return const LoginView();
        }))
        // const LoginView(),
        );
  }
}

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
        centerTitle: true,
      ),
      body: Scaffold(
        body: TextButton(
          onPressed: () {
            ref.read(authStateProvider.notifier).logOut();
          },
          child: const Text('LogOut'),
        ),
      ),
    );
  }
}

class LoginView extends ConsumerWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var column = SafeArea(
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              final result =
                  ref.read(authStateProvider.notifier).loginWithGoogle();
              result.log();
            },
            child: const Text(
              'Sign In with Google',
            ),
          ),
          TextButton(
            onPressed: () async {
              final result =
                  ref.read(authStateProvider.notifier).loginWithFacebook();
              result.log();
            },
            child: const Text(
              'Sign In with Facebook',
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      body: column,
    );
  }
}
