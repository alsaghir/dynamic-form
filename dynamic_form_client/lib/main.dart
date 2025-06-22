import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'infra/providers.dart';

///
/// This is the main entry point of the application.
/// Bootstrapping the app is done here.

/// Use flutter hooks for local widget state management.
/// HookConsumerWidget == StatelessWidget
/// StatefulHookConsumerWidget == StatefulWidget

/// Initialization logic also is done here.
/// No UI or widget related logic should be here except
/// [MyApp]

void main() {
  /// https://pub.dev/packages/talker_flutter#get-started-flutter
  final talker = TalkerFlutter.init();

  // Setting the provider for usage across the widgets
  Providers.talkerProvider = Provider.autoDispose<Talker>((ref) => talker);

  runTalkerZonedGuarded(
    talker,
    () => runApp(
      // https://riverpod.dev/docs/introduction/getting_started#usage-example-hello-world
      // For widgets to be able to read providers, we need to wrap the entire
      // application in a "ProviderScope" widget.
      // This is where the state of our providers will be stored.
      ProviderScope(
        observers: [TalkerRiverpodObserver(talker: talker)],
        child: const MyApp(),
      ),
    ),
    (Object error, StackTrace stack) {
      talker.handle(error, stack, 'Uncaught app exception');
    },
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(Providers.asyncConfigProvider);
    final userPreferences = ref.watch(Providers.userPrefProvider);
    final routerConfig = ref.watch(Providers.goRouterProvider);
    final talker = ref.watch(Providers.talkerProvider);

    config.whenData(
      (data) => talker.info('Running with app config: ${data.name}'),
    );

    return config.when(
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) => MaterialApp.router(
        themeMode: userPreferences.themeMode,
        theme: ThemeData.light(
          useMaterial3: true,
        ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        darkTheme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        title: "12312312312312312",
      ),
    );
  }
}
