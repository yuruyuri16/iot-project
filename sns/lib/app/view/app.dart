import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/home/home.dart';
import 'package:sns/l10n/l10n.dart';
import 'package:sns_repository/sns_repository.dart';

class App extends StatelessWidget {
  const App({
    required SnsRepository snsRepository,
    super.key,
  }) : _snsRepository = snsRepository;

  final SnsRepository _snsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _snsRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
