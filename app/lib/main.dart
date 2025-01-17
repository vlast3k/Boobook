import 'dart:async';

import 'package:boobook/common_providers.dart';
import 'package:boobook/presentation/router/router.dart';
import 'package:boobook/presentation/theme/theme.dart';
import 'package:boobook/presentation/views/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:layout_builder/layout_builder.dart'
    show PlatformApp, appThemeProvider;
import 'package:localization/localization.dart';
import 'package:purchases/purchases.dart';
import 'package:sign_in/sign_in.dart';
import 'firebase_options.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(ProviderScope(
      child: const BoobookApp(),
    ));
  }, (error, stackTrace) {
    //FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class BoobookApp extends ConsumerWidget {
  const BoobookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        appThemeProvider.overrideWithProvider(boobookTheme),
        // // purchasesSettingsProvider
        // //     .overrideWithProvider(boobookPurchasesSettings),
        authSettingsProvider.overrideWithProvider(boobookAuthSettingsProvider),
        signInThemeProvider.overrideWithProvider(boobookSignInTheme),
        // userLocaleProvider.overrideWithProvider(boobookUserLocaleProvider),
      ],
      child: PlatformApp(
        navigatorKey: AppRouter.main,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
        home: SplashPage(),
      ),
    );
  }
}
