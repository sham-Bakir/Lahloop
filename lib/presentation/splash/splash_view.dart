import 'dart:async';

import 'package:advapp/app/app_prefs.dart';
import 'package:advapp/app/dependency_injection.dart';
import 'package:advapp/presentation/resources/assets_manager.dart';
import 'package:advapp/presentation/resources/constants_manager.dart';
import 'package:advapp/presentation/resources/routes_manager.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color.fromARGB(255, 19, 143, 124),
      splash: Lottie.asset('assets/animation/Main Scene.json'),
      nextScreen: _NavigationPlaceholder(), // Use a placeholder widget
      duration: 5000,
      splashIconSize: 400,
    );
  }
}

class _NavigationPlaceholder extends StatelessWidget {
  _NavigationPlaceholder({super.key});

  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    // Trigger navigation when this widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
            if (isUserLoggedIn)
              {
                // Navigate to Home Page after Splash
                Navigator.pushReplacementNamed(context, Routes.mainRoute)
              }
            else
              {
                _appPreferences
                    .isOnBoardingScreenViewed()
                    .then((isOnBoardingScreenViewed) => {
                          // Navigate to Login Screen after Splash
                          if (isOnBoardingScreenViewed)
                            {
                              Navigator.pushReplacementNamed(
                                  context, Routes.loginRoute)
                            }
                          else
                            {
                              // Navigate to OnBoardings after Splash
                              Navigator.pushReplacementNamed(
                                  context, Routes.onBoardingRoute)
                            }
                        })
              }
          });
    });

    // Return an empty widget as this is just a placeholder
    return const SizedBox.shrink();
  }
}
