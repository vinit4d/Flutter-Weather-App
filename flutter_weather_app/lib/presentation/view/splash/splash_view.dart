import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/config/extenstions/imagePaths.dart';
import 'package:flutter_weather_app/presentation/theme/theme_config.dart';
import 'package:lottie/lottie.dart';

import '../../../config/app_route.dart';
import '../../../data/local_services/cache_services.dart';
import '../../../domain/app_data.dart';
import '../../theme/app_colors_dart.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () async {
        await CacheService.getInstance();
        AppData.accessToken = await CacheService.getAccessToken();

        print(AppData.accessToken);
        if (AppData.accessToken.isEmpty) {


          Navigator.pushReplacementNamed(context, AppRoute.signInRoute,
              arguments: false);
        } else {
          Navigator.pushReplacementNamed(context, AppRoute.homeRoute,
              arguments: 0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Thunderstorm".toGif),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('assets/images/png/splashScreen.png'),
              Container(),
              Container(),
              Container(),



              AnimatedTextKit(
                animatedTexts: [

                  TyperAnimatedText('Flutter Weather App.',
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],

              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        backgroundColor: ThemeConfig.colors.hintColor,
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors().splashLoader),
                      )),

                  SizedBox(height: 16),
                  const Text(
                    'V1.0.0', // Replace with your app version text
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
