import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final IconData? fallbackIcon;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppSizes.avatarM,
    this.fallbackIcon,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor ?? AppColors.primary.withOpacity(0.1),
        image:
            imageUrl?.isNotEmpty == true
                ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: imageUrl?.isNotEmpty != true ? _buildFallback() : null,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  Widget _buildFallback() {
    if (fallbackIcon != null) {
      return Icon(fallbackIcon, size: size * 0.6, color: AppColors.primary);
    }

    if (name?.isNotEmpty == true) {
      return Center(
        child: Text(
          name!.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Icon(Icons.person, size: size * 0.6, color: AppColors.primary);
  }
}

class AppStatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;
  final double borderRadius;

  const AppStatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSizes.paddingM,
      vertical: AppSizes.paddingXS,
    ),
    this.borderRadius = AppSizes.radiusXL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color? color;
  final EdgeInsets margin;

  const AppDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.color,
    this.margin = const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Divider(
        height: height,
        thickness: thickness,
        color: color ?? AppColors.border,
      ),
    );
  }
}
