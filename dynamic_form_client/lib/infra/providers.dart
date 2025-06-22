import 'package:dynamic_form_client/presentation/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yaml/yaml.dart';

import '../domain/app_config.dart';
import '../domain/user_preference.dart';
import '../presentation/app.dart';
import '../presentation/authorized.dart';
import '../presentation/home.dart';

class Providers {
  static AutoDisposeProvider<Talker> talkerProvider =
      Provider.autoDispose<Talker>((ref) {
        throw UnimplementedError("Talker provider not initialized.");
      });

  final configProvider = Provider.autoDispose<AppConfig>((ref) {
    final AsyncValue<AppConfig> config = ref.watch(asyncConfigProvider);

    return config.maybeWhen(
      orElse: () => throw StateError(
        "Configuration not loaded. Ensure asyncConfigProvider is watched first.",
      ),
      data: (config) => config,
    );
  });

  static final asyncConfigProvider = FutureProvider.autoDispose<AppConfig>((
    ref,
  ) async {
    final yamlString = await rootBundle.loadString('assets/config.yaml');
    final dynamic yamlMap = loadYaml(yamlString);
    String backendHost = _getBackendHost(yamlMap);

    const environmentParameter = String.fromEnvironment('ENV');
    AppConfig config;
    switch (environmentParameter) {
      case 'prod':
        config = ProdConfig(
          kBackendHost: backendHost,
          kFormsApi: yamlMap['api.forms'],
        );
      case 'dev':
        config = DevConfig(
          kBackendHost: backendHost,
          kFormsApi: yamlMap['api.forms'],
        );
      default:
        config = ProdConfig(
          kBackendHost: backendHost,
          kFormsApi: yamlMap['api.forms'],
        );
    }
    return config;
  });

  static String _getBackendHost(yamlMap) {
    String backendHost =
        "${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}";
    if (yamlMap is YamlMap && yamlMap.containsKey('backend.host')) {
      backendHost = yamlMap['backend.host'];
    }
    return backendHost;
  }

  static final userPrefProvider = StateProvider.autoDispose((ref) {
    return UserPreference(themeMode: ThemeMode.light);
  });

  static final AutoDisposeProvider<GoRouter> goRouterProvider =
      Provider.autoDispose<GoRouter>((ref) {
        final talker = ref.watch(talkerProvider);

        /// Routes configurations. Must be executed when called for widgets
        /// constructions, hence, not a variable nor state provider
        return GoRouter(
          initialLocation: '/home',
          debugLogDiagnostics: true,
          observers: [TalkerRouteObserver(talker)],
          routes: [
            GoRoute(
              name: 'home',
              path: '/home',
              builder: (context, state) => AppScreen(page: HomeScreen()),
            ),
            GoRoute(
              name: 'authorized',
              path: '/authorized',
              builder: (context, state) => AppScreen(page: AuthorizedScreen()),
            ),
            GoRoute(
              name: 'logs',
              path: '/logs',
              builder: (context, state) => AppScreen(page: LogScreen()),
            ),
          ],
        );
      });
}
