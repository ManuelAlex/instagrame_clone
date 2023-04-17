import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/provider/auth_state_provider.dart';
import 'package:instagram_clone/state/auth/provider/is_logged_in_provider.dart';
import 'package:instagram_clone/state/provider/is_loading_provider.dart';
import 'package:instagram_clone/views/component/animation/data_not_found_animation_view.dart';
import 'package:instagram_clone/views/component/animation/empty_animation_view.dart';
import 'package:instagram_clone/views/component/animation/error_animation_view.dart';
import 'package:instagram_clone/views/component/animation/small_error_animation_view.dart';
import 'package:instagram_clone/views/component/loading/loading_screen.dart';
import 'package:instagram_clone/views/login/login_view.dart';
import 'firebase_options.dart';

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

// extension Log on Object {
//   void log() => devtool.log(
//         toString(),
//       );
// }

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
          ref.listen<bool>(isLoadingProvider, (_, isloading) {
            if (isloading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
          });

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
        title: Row(
          children: [
            const Text('Instagram'),
            const SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).logOut();
              },
              child: const Text('LogOut'),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: const Scaffold(body: EmptyContentAnimationView()),
    );
  }
}
