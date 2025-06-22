import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A common widget acts as a container for the whole app.
/// Routes navigate to this widget and any pre or post
/// rendering logic goes here. Example of that is loading config
/// from yaml file and make sure it is loaded on startup
class AppScreen extends HookConsumerWidget {
  final Widget page;

  const AppScreen({super.key, required this.page});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return page;
  }
}
