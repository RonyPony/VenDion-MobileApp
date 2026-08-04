import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/providers/settings_provider.dart';
import 'package:vendion/widgets/drawer.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settingsScreen";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GeneralDrawer(),
      appBar: AppBar(
        title: Text(context.l10n.t('settings')),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            _SettingsSection(
              title: context.l10n.t('appearance'),
              children: const [
                _ThemeModeSelector(),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _SettingsSection(
              title: context.l10n.t('preferences'),
              children: const [
                _LanguageSelector(),
                _ComingSoonTile(
                  icon: Icons.text_fields,
                  titleKey: 'textSize',
                  subtitleKey: 'textSizeComingSoon',
                ),
                _ComingSoonTile(
                  icon: Icons.notifications_none,
                  titleKey: 'notificationsPrefs',
                  subtitleKey: 'notificationsPrefsSubtitle',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: theme.dividerColor.withOpacity(.45)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.contrast, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  context.l10n.t('appTheme'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined),
                label: Text(context.l10n.t('light')),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: Text(context.l10n.t('dark')),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.settings_suggest_outlined),
                label: Text(context.l10n.t('system')),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (selection) {
              settings.updateThemeMode(selection.first);
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const Icon(Icons.language, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.t('language'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.t('languageSubtitle'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: settings.languageCode,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                value: 'es',
                child: Text(context.l10n.t('spanish')),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Text(context.l10n.t('english')),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                settings.updateLanguageCode(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ComingSoonTile extends StatelessWidget {
  const _ComingSoonTile({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
  });

  final IconData icon;
  final String titleKey;
  final String subtitleKey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(context.l10n.t(titleKey)),
      subtitle: Text(context.l10n.t(subtitleKey)),
      trailing: const Icon(Icons.chevron_right),
      enabled: false,
    );
  }
}
