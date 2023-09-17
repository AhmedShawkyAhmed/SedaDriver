import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants_variables.dart';

class CustomListViewItem extends StatelessWidget {
  const CustomListViewItem({
    Key? key,
    this.leading,
    this.trailing,
    this.title,
    this.titleText,
    required this.onClick,
    this.height,
    this.titleFontSize,
    this.titleFontWeight,
    this.padding,
    this.titleColor,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.enableBorder = false,
    this.leadingTitleSpacing,
    this.textAlign,
    this.width,
    this.margin,
  }) : super(key: key);

  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final String? titleText;
  final Function()? onClick;
  final double? height;
  final double? width;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final EdgeInsets? padding;
  final Color? titleColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool enableBorder;
  final double? leadingTitleSpacing;
  final TextAlign? textAlign;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: backgroundColor ??
            (isDark ? AppColors.darkBlue : AppColors.transparent),
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: onClick,
          child: Container(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: enableBorder
                  ? Border.all(
                      color: borderColor ??
                          (isDark ? AppColors.white : AppColors.darkGrey),
                    )
                  : null,
            ),
            height: height ?? 6.5.h,
            width: width,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) leading!,
                if (leading != null)
                  SizedBox(
                    width: leadingTitleSpacing ?? 3.w,
                  ),
                if (titleText != null)
                  Expanded(
                    child: DefaultAppText(
                      text: titleText!,
                      fontWeight: titleFontWeight ?? FontWeight.w400,
                      fontSize: titleFontSize ?? 12.sp,
                      textAlign: textAlign,
                      color: titleColor ??
                          (isDark ? AppColors.white : AppColors.black),
                    ),
                  ),
                if (title != null)
                  Expanded(
                    child: title!,
                  ),
                if (trailing == null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isDark ? AppColors.white : AppColors.lightBlue,
                  ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
