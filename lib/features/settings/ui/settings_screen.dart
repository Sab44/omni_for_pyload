import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart' as app_models;
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';
import 'package:omni_for_pyload/features/settings/viewmodel/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel(
      settingsRepository: getIt<ISettingsRepository>(),
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Settings Section
          _buildSectionTitle('App settings'),
          const SizedBox(height: 12),
          _buildThemeOption(),
          const SizedBox(height: 16),
          _buildSkipSelectionOption(),
          const SizedBox(height: 32),

          // Server Settings Section
          // _buildSectionTitle('Server settings'),
          // const SizedBox(height: 12),
          // _buildComingSoonPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildThemeOption() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            SegmentedButton<app_models.ThemeMode>(
              segments: const [
                ButtonSegment<app_models.ThemeMode>(
                  value: app_models.ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment<app_models.ThemeMode>(
                  value: app_models.ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode),
                ),
                ButtonSegment<app_models.ThemeMode>(
                  value: app_models.ThemeMode.system,
                  label: Text('Follow System'),
                  icon: Icon(Icons.brightness_auto),
                ),
              ],
              selected: {_viewModel.themeMode},
              onSelectionChanged: (Set<app_models.ThemeMode> newSelection) {
                _viewModel.setThemeMode(newSelection.first);
              },
              showSelectedIcon: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipSelectionOption() {
    return Card(
      child: ListTile(
        title: const Text(
          'Skip selection screen if only one server is configured',
        ),
        trailing: Switch(
          value: _viewModel.skipSelectionScreenIfOnlyOneServer,
          onChanged: (bool value) {
            _viewModel.setSkipSelectionScreenIfOnlyOneServer(value);
          },
        ),
      ),
    );
  }

  // Widget _buildComingSoonPlaceholder() {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Text(
  //         'Coming soon',
  //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //           color: Colors.grey,
  //           fontStyle: FontStyle.italic,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
