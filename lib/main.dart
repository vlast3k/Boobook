import 'package:boobook/providers/common.dart';
import 'package:boobook/presentation/routes/navigators.dart';
import 'package:boobook/presentation/routes/router.dart';
import 'package:boobook/presentation/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:layout_builder/layout_builder.dart'
    show PlatformApp, appThemeProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
    child: const BoobookApp(),
  ));
}

class BoobookApp extends ConsumerWidget {
  const BoobookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(boobookThemeProvider);
    final selectedLang = ref.watch(selectedLangProvider);

    return ProviderScope(
      overrides: [
        appThemeProvider.overrideWithValue(appTheme),
      ],
      child: PlatformApp(
        locale: Locale.fromSubtags(languageCode: selectedLang.identifier),
        navigatorKey: NavigatorKeys.main,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppRoutes.splashPage,
        onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
        builder: (context, child) {
          return ProviderScope(
            overrides: [
              localizationProvider
                  .overrideWithValue(AppLocalizations.of(context)!),
            ],
            child: child!,
          );
        },
      ),
    );
  }
}