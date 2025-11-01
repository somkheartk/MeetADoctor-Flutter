import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final IconData? icon;
  final EdgeInsets padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = AppSizes.buttonHeightM,
    this.borderRadius = AppSizes.radiusM,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width,
      height: height,
      child:
          isOutlined
              ? _buildOutlinedButton(isEnabled)
              : _buildElevatedButton(isEnabled),
    );
  }

  Widget _buildElevatedButton(bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        disabledBackgroundColor: AppColors.textLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(bool isEnabled) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color:
              isEnabled
                  ? (backgroundColor ?? AppColors.primary)
                  : AppColors.textLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined
                ? (backgroundColor ?? AppColors.primary)
                : (textColor ?? AppColors.textWhite),
          ),
        ),
      );
    }

    final Color finalTextColor =
        isOutlined
            ? (backgroundColor ?? AppColors.primary)
            : (textColor ?? AppColors.textWhite);

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: finalTextColor, size: AppSizes.iconS),
          const SizedBox(width: AppSizes.paddingS),
          Text(
            text,
            style: AppTextStyles.buttonMedium.copyWith(color: finalTextColor),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.buttonMedium.copyWith(color: finalTextColor),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final bool hasShadow;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = AppSizes.iconXL,
    this.iconSize = AppSizes.iconM,
    this.borderRadius = AppSizes.radiusM,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow ? AppShadows.light : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor ?? AppColors.textPrimary,
          size: iconSize,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
