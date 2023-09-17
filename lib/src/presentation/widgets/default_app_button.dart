import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class DefaultAppButton extends StatelessWidget {
  const DefaultAppButton({
    Key? key,
    required this.text,
    this.textAlign,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    required this.onTap,
    this.height,
    this.borderRadius,
    this.width,
    this.margin,
    this.gradient,
    this.backgroundColor,
    this.icon,
    this.iconSpacing,
    this.borderWidth,
    this.borderColor,
    this.enableBorder = false,
    this.buttonShape,
    this.padding,
    this.shadow,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function() onTap;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Widget? icon;
  final double? iconSpacing;
  final double? borderWidth;
  final Color? borderColor;
  final bool enableBorder;
  final BoxShape? buttonShape;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height ?? 5.h,
      width: width,
      decoration: BoxDecoration(
        borderRadius: buttonShape == null
            ? BorderRadius.circular(borderRadius ?? 50)
            : null,
        color: backgroundColor,
        border: enableBorder
            ? Border.all(
                color: borderColor ?? AppColors.darkBlue,
                width: borderWidth ?? 1,
              )
            : null,
        shape: buttonShape ?? BoxShape.rectangle,
        boxShadow: shadow,
        gradient: backgroundColor == null
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.darkBlue2,
                  AppColors.darkBlue,
                  AppColors.midBlue,
                ],
              )
            : null,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: Alignment.center,
      child: Material(
        color: AppColors.transparent,
        type: buttonShape == BoxShape.circle
            ? MaterialType.circle
            : MaterialType.canvas,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) icon!,
                  if (icon != null)
                    SizedBox(
                      width: iconSpacing ?? 15,
                    ),
                  DefaultAppText(
                    text: text,
                    textAlign: textAlign ?? TextAlign.center,
                    color: textColor ?? AppColors.white,
                    fontSize: fontSize ?? 13.sp,
                    fontWeight: fontWeight ?? FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
