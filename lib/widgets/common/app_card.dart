import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.paddingM),
    this.margin,
    this.borderRadius = AppSizes.radiusM,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardWidget = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? AppShadows.card,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}

class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? backgroundColor;

  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSizes.paddingM),
    this.borderRadius = AppSizes.radiusM,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSizes.paddingM),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSizes.paddingXS),
                      subtitle!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSizes.paddingM),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
