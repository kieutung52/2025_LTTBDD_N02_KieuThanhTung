import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:animate_do/animate_do.dart';

class StreakDisplay extends StatelessWidget {
  final int streak;
  final bool showAnimation;
  final double size;
  final bool isAlreadyActiveToday;

  const StreakDisplay({
    super.key,
    required this.streak,
    this.showAnimation = true,
    this.size = 100.0,
    this.isAlreadyActiveToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasStreak = streak > 0;
    final Color color;
    if (isAlreadyActiveToday) {
      color = AppColors.flame;
    } else if (hasStreak) {
      color = AppColors.flame.withAlpha((255 * 0.5).round());
    } else {
      color = AppColors.textDisabled;
    }
    Widget flameIcon = Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          LucideIcons.flame,
          color: color,
          size: size,
        ),
        if (hasStreak)
          Text(
            streak.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.3,
              shadows: const [
                Shadow(blurRadius: 2.0, color: Colors.black38)
              ],
            ),
          ),
      ],
    );

    if (!showAnimation || !hasStreak) {
      return flameIcon;
    }

    return Pulse(
      duration: const Duration(seconds: 2),
      infinite: true,
      child: flameIcon,
    );
  }
}