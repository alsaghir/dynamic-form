import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

@immutable
class Config {
  const Config({required this.kBackendHost, required this.kFormsApi});

  final String kBackendHost;
  final String kFormsApi;

  String getEndpoint(String endpoint) {
    return kBackendHost + endpoint;
  }
}

@immutable
abstract class AppConfig {
  const AppConfig({required this.kBackendHost, required this.kFormsApi});

  String get name;

  LogLevel get logLevel;

  final String kBackendHost;
  final String kFormsApi;

  String getEndpoint(String endpoint) => kBackendHost + endpoint;

  isDebugEnabled() => logLevel == LogLevel.debug;
}

@immutable
class ProdConfig extends AppConfig {
  const ProdConfig({required super.kBackendHost, required super.kFormsApi});

  @override
  LogLevel get logLevel => LogLevel.info;

  @override
  get name => 'prod';
}

@immutable
class DevConfig extends AppConfig {
  const DevConfig({required super.kBackendHost, required super.kFormsApi});

  @override
  LogLevel get logLevel => LogLevel.debug;

  @override
  get name => 'dev';
}
