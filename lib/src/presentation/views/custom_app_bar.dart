import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.height,
    this.elevation,
    this.padding,
  }) : super(key: key);

  final double? height;
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final Widget? actions;
  final double? elevation;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? 0,
      child: Container(
        padding: padding,
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            leading ??
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    context.isAr ?Icons.arrow_back_ios:Icons.arrow_back_ios_new,
                    color: isDark ? AppColors.white : AppColors.darkGrey,
                  ),
                ),
            if (titleWidget != null)
              Expanded(
                child: titleWidget!,
              ),
            if (title != null)
              Expanded(
                flex: 10,
                child: DefaultAppText(
                  text: title ?? '_',
                  color: isDark ? AppColors.white : AppColors.darkGrey,
                  fontSize: 15.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(width: 30,),
            if (title != null) const Spacer(),
            if (actions != null) actions!
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 8.h);
}
