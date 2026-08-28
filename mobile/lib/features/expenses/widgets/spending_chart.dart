import 'package:flutter/material.dart';

const _lightPrimaryColor = Color.fromARGB(255, 96, 59, 181);
const _darkForegroundColor = Color.fromARGB(255, 160, 193, 206);
const _darkBackgroundBottomColor = Color.fromARGB(255, 35, 83, 92);
const _darkBackgroundTopColor = Color.fromARGB(255, 31, 35, 35);

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundBottomColor = isDark
        ? _darkBackgroundBottomColor
        : _lightPrimaryColor.withValues(alpha: 0.30);

    final backgroundTopColor = isDark
        ? _darkBackgroundTopColor
        : _lightPrimaryColor.withValues(alpha: 0.0);

    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            backgroundBottomColor,
            backgroundTopColor,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: const Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StaticChartBar(fill: 0),
                _StaticChartBar(fill: 0.75),
                _StaticChartBar(fill: 0),
                _StaticChartBar(fill: 1),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _CategoryIcon(icon: Icons.lunch_dining),
              _CategoryIcon(icon: Icons.movie),
              _CategoryIcon(icon: Icons.flight_takeoff),
              _CategoryIcon(icon: Icons.work),
            ],
          ),
        ],
      ),
    );
  }
}

class _StaticChartBar extends StatelessWidget {
  const _StaticChartBar({
    required this.fill,
  });

  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final barColor = isDark
        ? _darkForegroundColor
        : _lightPrimaryColor.withValues(alpha: 0.65);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: fill,
          alignment: Alignment.bottomCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              color: barColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark
        ? _darkForegroundColor
        : _lightPrimaryColor.withValues(alpha: 0.7);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
