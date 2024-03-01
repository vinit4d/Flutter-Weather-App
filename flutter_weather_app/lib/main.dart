import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/presentation/theme/theme_config.dart';
import 'config/app_route.dart';
import 'presentation/view/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeConfig.init(context);
    return MaterialApp(
        onGenerateRoute: AppRoute.generateRoute,
        debugShowCheckedModeBanner: false,
        title: ThemeConfig.strings.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashView());
  }
}
