import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:sizer/sizer.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    Key? key,
    this.data,
    this.children,
    this.onTap,
    this.checked,
    this.enabled,
    this.disabledColor,
    this.padding,
    this.enableBorder = true,
    this.enableDivider = true,
    this.borderColor,
    this.dividerColor,
    this.dividerHorizontalPadding,
    this.separatorHeight,
    this.separatorWidth,
    this.margin,
    this.isScrollable = false,
    this.scrollDirection = Axis.vertical,
    this.height,
    this.width,
    this.reverse = false,
  }) : super(key: key);

  final List<String>? data;
  final List<Widget>? children;
  final Function(int index)? onTap;
  final List<bool>? checked;
  final List<bool>? enabled;
  final Color? disabledColor;
  final bool enableBorder;
  final bool enableDivider;
  final EdgeInsets? padding;
  final Color? borderColor;
  final Color? dividerColor;
  final double? dividerHorizontalPadding;
  final double? separatorHeight;
  final double? separatorWidth;
  final bool isScrollable;
  final EdgeInsets? margin;
  final Axis scrollDirection;
  final double? height;
  final double? width;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin ?? EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: enableBorder
            ? Border.all(
                width: 1,
                color: borderColor ?? AppColors.darkGrey,
              )
            : null,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ListView.separated(
        reverse: reverse,
        scrollDirection: scrollDirection,
        shrinkWrap: true,
        physics: isScrollable
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => IgnorePointer(
          ignoring: index == 0 ||
                  (enabled != null && enabled![index - 1] == true) ||
                  enabled == null
              ? false
              : true,
          child: Material(
            color: AppColors.transparent,
            child: children?[index] ??
                CustomListViewItem(
                  backgroundColor: disabledColor != null &&
                          enabled != null &&
                          (index == 0 ||
                              enabled![index] == true ||
                              (enabled![index - 1] == true))
                      ? null
                      : disabledColor,
                  onClick: () => onTap?.call(index),
                  trailing: checked != null && checked![index]
                      ? Row(
                          children: [
                            Image.asset(AppAssets.icRegisterCheck),
                            SizedBox(
                              width: 3.w,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.lightBlue,
                            ),
                          ],
                        )
                      : null,
                  titleText: data![index],
                ),
          ),
        ),
        separatorBuilder: (context, index) => enableDivider
            ? Padding(
                padding: dividerHorizontalPadding != null
                    ? EdgeInsets.symmetric(
                        horizontal: dividerHorizontalPadding!,
                      )
                    : EdgeInsets.zero,
                child: scrollDirection == Axis.vertical
                    ? Divider(
                        color: dividerColor ?? AppColors.darkGrey,
                        thickness: 1,
                        height: 0,
                      )
                    : VerticalDivider(
                        color: dividerColor ?? AppColors.darkGrey,
                        thickness: 1,
                        width: 0,
                      ),
              )
            : SizedBox(
                height:
                    scrollDirection == Axis.vertical ? separatorHeight : null,
                width:
                    scrollDirection == Axis.horizontal ? separatorWidth : null,
              ),
        itemCount: children?.length ?? data!.length,
      ),
    );
  }
}
