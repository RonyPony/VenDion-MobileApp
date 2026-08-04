import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/providers/auth_provider.dart';
import 'package:vendion/providers/messages_provider.dart';
import 'package:vendion/screens/favorites_screen.dart';
import 'package:vendion/screens/filters_screen.dart';
import 'package:vendion/screens/home_screen.dart';
import 'package:vendion/screens/login_screen.dart';
import 'package:vendion/screens/messages_screen.dart';
import 'package:vendion/screens/notifications_screen.dart';
import 'package:vendion/screens/profile_screen.dart';
import 'package:vendion/screens/settings_screen.dart';

class GeneralDrawer extends StatelessWidget {
  const GeneralDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;

    return Drawer(
      backgroundColor: theme.drawerTheme.backgroundColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
              child: Row(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 46,
                    height: 46,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    context.l10n.t('appName'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.home_rounded,
              title: context.l10n.t('home'),
              textColor: textColor,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);
              },
            ),
            _DrawerItem(
              icon: Icons.favorite_rounded,
              title: context.l10n.t('favorites'),
              textColor: textColor,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, FavoriteScreen.routeName, (route) => false);
              },
            ),
            _DrawerItem(
              icon: Icons.person_rounded,
              title: context.l10n.t('profile'),
              textColor: textColor,
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
            ),
            _DrawerItem(
              icon: Icons.directions_car_filled_rounded,
              title: context.l10n.t('recommended'),
              textColor: textColor,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);
              },
            ),
            _DrawerItem(
              icon: Icons.tune_rounded,
              title: context.l10n.t('filters'),
              textColor: textColor,
              onTap: () {
                Navigator.pushNamed(context, FiltersScreen.routeName);
              },
            ),
            _DrawerItem(
              icon: Icons.notifications_none_rounded,
              title: context.l10n.t('notifications'),
              textColor: textColor,
              onTap: () {
                Navigator.pushNamed(context, NotificationsScreen.routeName);
              },
            ),
            Consumer<MessagesProvider>(
              builder: (context, messagesProvider, child) {
                return _DrawerItem(
                  icon: Icons.forum_rounded,
                  title: context.l10n.t('messages'),
                  textColor: textColor,
                  badgeCount: messagesProvider.unreadConversationCount,
                  onTap: () {
                    Navigator.pushNamed(context, MessagesScreen.routeName);
                  },
                );
              },
            ),
            _DrawerItem(
              icon: Icons.settings_rounded,
              title: context.l10n.t('settings'),
              textColor: textColor,
              onTap: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.withValues(alpha: .35)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: Text(context.l10n.t('logout')),
                onPressed: () async {
                  await Provider.of<AuthenticationProvider>(
                    context,
                    listen: false,
                  ).signOutUser();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.routeName, (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.textColor,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String title;
  final Color? textColor;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
          if (badgeCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
