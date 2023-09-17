import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants_variables.dart';

class DefaultTextFormField extends StatelessWidget {
  const DefaultTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly,
    this.enabled,
    this.expand,
    this.obscureText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTapOutside,
    this.suffix,
    this.prefix,
    this.height,
    this.width,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.borderColor,
    this.margin,
    this.backgroundColor,
    this.border,
    this.fontSize,
    this.textAlign,
    this.hintTextColor,
    this.borderRadius,
  }) : super(key: key);

  final TextEditingController controller;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? readOnly;
  final bool? enabled;
  final bool? expand;
  final bool? obscureText;
  final String? Function(String? val)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final Function()? onTap;
  final Function(String val)? onChanged;
  final Function(String val)? onFieldSubmitted;
  final Function(PointerDownEvent event)? onTapOutside;
  final Widget? suffix;
  final Widget? prefix;
  final double? height;
  final double? width;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? fontSize;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final EdgeInsets? margin;
  final InputBorder? border;
  final TextAlign? textAlign;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height ?? 6.h,
      width: width ?? 80.w,
      child: TextFormField(
        textAlign: textAlign ?? TextAlign.start,
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        readOnly: readOnly ?? false,
        enabled: enabled,
        expands: expand ?? false,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters ?? [],
        style: TextStyle(
          fontSize: fontSize ?? 13.sp,
          color: isDark ? AppColors.white : AppColors.darkGrey,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.only(
            top: top ?? 0,
            bottom: bottom ?? 0,
            left: left ?? 10,
            right: right ?? 10,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 11.sp,
            color: hintTextColor ?? (isDark ? AppColors.white : AppColors.grey),
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: suffix,
          prefixIcon: prefix,
          disabledBorder: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: BorderSide(
                  width: 1.sp,
                  color: borderColor ??
                      (isDark ? AppColors.white : AppColors.darkGrey),
                ),
              ),
          enabledBorder: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: BorderSide(
                  width: 1.sp,
                  color: borderColor ??
                      (isDark ? AppColors.white : AppColors.darkGrey),
                ),
              ),
          errorBorder: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: BorderSide(
                  width: 1.sp,
                  color: borderColor ??
                      (isDark ? AppColors.white : AppColors.darkGrey),
                ),
              ),
          focusedBorder: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: BorderSide(
                  width: 1.sp,
                  color: borderColor ??
                      (isDark ? AppColors.white : AppColors.darkGrey),
                ),
              ),
          focusedErrorBorder: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: BorderSide(
                  width: 1.sp,
                  color: borderColor ??
                      (isDark ? AppColors.white : AppColors.darkGrey),
                ),
              ),
          fillColor: backgroundColor,
          filled: backgroundColor != null,
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 10),
                borderSide: BorderSide(
                  width: 1.sp,
                  color: borderColor ??
                      (isDark ? AppColors.white : AppColors.darkGrey),
                ),
              ),
        ),
        onTap: onTap,
        onChanged: onChanged,
        onTapOutside: onTapOutside ??
            (e) => FocusManager.instance.primaryFocus?.unfocus(),
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscureText ?? false,
      ),
    );
  }
}
