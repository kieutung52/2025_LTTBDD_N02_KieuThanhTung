import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/user/user_response.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class AppBarUserInfo extends StatelessWidget {
  final UserResponse user;
  final bool showName;

  const AppBarUserInfo({
    super.key,
    required this.user,
    this.showName = true,
  });

  String _getAvatarImagePath(String name) {
    List<String> avatarPaths = [
      "images/1.JPG",
      "images/2.JPG", 
      "images/3.JPG",
    ];

    int index = name.hashCode.abs() % avatarPaths.length;
    return avatarPaths[index];
  }

  bool _isStreakActiveToday(UserResponse user) {
    final lastActive = user.lastStreakActiveDate.toLocal();
    final today = user.currentDate.toLocal();
    return DateUtils.isSameDay(lastActive, today);
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _isStreakActiveToday(user);
    final Color flameColor;
    if (isActive) {
      flameColor = AppColors.flame;
    } else if (user.streak > 0) {
      flameColor = AppColors.flame.withAlpha((255 * 0.5).round());
    } else {
      flameColor = AppColors.textDisabled;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.flame, color: flameColor, size: 24),
        const SizedBox(width: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Text(
            user.streak.toString(),
            key: ValueKey<int>(user.streak),
            style: TextStyle(
              color: flameColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const VerticalDivider(width: 32, indent: 8, endIndent: 8),

        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.lightBlue,
          backgroundImage: AssetImage(_getAvatarImagePath(user.fullName)),
          child: user.fullName.isNotEmpty 
              ? Text(
                  user.fullName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryBlue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 10
                  ),
                )
              : const Text("A"),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showName)
                Text(
                  user.email,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}