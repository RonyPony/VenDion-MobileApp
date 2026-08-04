import 'package:flutter/material.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/screens/favorites_screen.dart';
import 'package:vendion/screens/home_screen.dart';
import 'package:vendion/screens/profile_screen.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key, required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    }
    if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(
          context, FavoriteScreen.routeName, (route) => false);
    }
    if (index == 2) {
      Navigator.pushNamedAndRemoveUntil(
          context, ProfileScreen.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          bottomPadding == 0 ? AppSpacing.md : bottomPadding,
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff18181d) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? .35 : .12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.white12 : const Color(0x11000000),
            ),
          ),
          child: Row(
            children: [
              _BottomMenuItem(
                icon: Icons.home_rounded,
                label: context.l10n.t('home'),
                active: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              _BottomMenuItem(
                icon: Icons.favorite_rounded,
                label: context.l10n.t('favorites'),
                active: _selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              _BottomMenuItem(
                icon: Icons.person_rounded,
                label: context.l10n.t('profile'),
                active: _selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomMenuItem extends StatelessWidget {
  const _BottomMenuItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: active ? 24 : 23,
                color: active ? Colors.white : inactiveColor?.withOpacity(.55),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                child: active
                    ? Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.sm),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
