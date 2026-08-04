import 'package:flutter/material.dart';
import 'package:vendion/config/app_constants.dart';
import 'package:vendion/l10n/app_localizations.dart';
import 'package:vendion/screens/notifications_screen.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: IconButton(
        tooltip: context.l10n.t('notifications'),
        onPressed: () {
          Navigator.pushNamed(context, NotificationsScreen.routeName);
        },
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1d1d24) : AppColors.lightSurface,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xffe53935),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(width: 7, height: 7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
