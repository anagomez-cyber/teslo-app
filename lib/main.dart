import 'dart:developer';
import 'dart:math';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configuration = DatadogConfiguration(
  clientToken: 'pub95c970e7bf49c8c35cdfddb2d5f78309',
  env: 'dev',
  site: DatadogSite.eu1,
  nativeCrashReportEnabled: true,
  loggingConfiguration: DatadogLoggingConfiguration(),
  rumConfiguration: DatadogRumConfiguration(
    applicationId: '828ca0b8-8371-46e1-bba1-de4c8ca5e4f8',
    sessionSamplingRate: 100,
  ),
);

  await Environment.initEnvironment();

  await DatadogSdk.runApp(
    configuration,
    TrackingConsent.granted,
    () async {

      runApp(
        const ProviderScope(
          child: MainApp(),
        ),
      );
    },
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
