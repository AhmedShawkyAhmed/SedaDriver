import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

class DefaultDropdown<T> extends StatelessWidget {
  const DefaultDropdown({
    Key? key,
    required this.items,
    this.selectedItem,
    this.hint,
    this.hintStyle,
    this.enabled = true,
    this.hasBorder = false,
    this.border,
    this.hasShadow = true,
    this.filled = true,
    this.isCollapsed = true,
    this.showSearchBox = false,
    this.maxHeight,
    this.dropDownKey,
    this.icon,
    this.selectedTextStyle,
    this.dropdownTextStyle,
    this.decoration,
    this.fillColor,
    this.disabledFillColor,
    this.borderRadius,
    this.itemAsString,
    this.selectedAlign,
    this.dropdownAlign,
    this.onChanged,
    this.dropdownButtonBuilder,
    this.selectedLeadingWidget,
    this.dropdownLeadingWidget,
    this.onBeforeChange,
  }) : super(key: key);
  final List<T> items;
  final T? selectedItem;
  final String? hint;
  final TextStyle? hintStyle;
  final BorderSide? border;
  final bool enabled, hasBorder, hasShadow, filled, isCollapsed, showSearchBox;
  final double? maxHeight;
  final Key? dropDownKey;
  final TextStyle? selectedTextStyle;
  final TextStyle? dropdownTextStyle;
  final BoxDecoration? decoration;
  final Color? fillColor;
  final Color? disabledFillColor;
  final BorderRadius? borderRadius;
  final void Function(T?)? onChanged;
  final String Function(T?)? itemAsString;
  final AlignmentGeometry? selectedAlign, dropdownAlign;
  final Widget? dropdownButtonBuilder;
  final Widget? icon;
  final Widget Function(BuildContext, T?)? selectedLeadingWidget;
  final Widget Function(BuildContext context, T item, bool isSelected)?
      dropdownLeadingWidget;

  /// callback executed before applying value change
  final BeforeChange<T>? onBeforeChange;

  @override
  Widget build(BuildContext context) {
    final relativeMenuHeight =
        (items.length * (3.h) + 10.h -(showSearchBox ? 0:7.h)); //Item count * approximate Item height
    var inputBorder = OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(7),
      borderSide: BorderSide(
        color: enabled ? AppColors.black : const Color(0xff000000),
        width: 1.5,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: AppColors.black,
          width: 1.2,
        ),
      ),
      child: DropdownSearch<T>(
        key: dropDownKey,
        enabled: enabled,
        popupProps: PopupProps.menu(
          showSearchBox: showSearchBox,
          searchFieldProps: TextFieldProps(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              isCollapsed: false,
              constraints: const BoxConstraints(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 0.5.h,
              ),
            ),
          ),
          itemBuilder: (ctx, item, b) => Container(
            alignment: dropdownAlign ?? AlignmentDirectional.center,
            padding: EdgeInsetsDirectional.fromSTEB(5.w, 1.h, 5.w, 1.h),
            child: Row(
              children: [
                dropdownLeadingWidget?.call(ctx, item, b) ?? const SizedBox(),
                Expanded(
                  child: Container(
                    alignment: dropdownAlign ?? AlignmentDirectional.center,
                    child: Text(
                      itemAsString != null
                          ? itemAsString!(item)
                          : item.toString(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: dropdownTextStyle ??
                          TextStyle(
                            color: enabled
                                ? AppColors.black
                                : const Color(0xff636363),
                            fontSize: 12.sp,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          menuProps: MenuProps(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: maxHeight ??
                (relativeMenuHeight > 20.h ? 10.h : relativeMenuHeight),
          ),
        ),
        selectedItem: selectedItem,
        itemAsString: itemAsString,
        dropdownButtonProps: DropdownButtonProps(
          constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
          splashRadius: 12,
          iconSize: 12.sp,
          icon: dropdownButtonBuilder ??
              Icon(
                Icons.keyboard_arrow_down,
                color: enabled ? AppColors.black : const Color(0xff636363),
                size: 12.sp,
              ),
          selectedIcon: dropdownButtonBuilder ??
              Icon(
                Icons.keyboard_arrow_down,
                color: enabled ? AppColors.black : const Color(0xff636363),
                size: 12.sp,
              ),
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            suffixIconConstraints:
                const BoxConstraints(minHeight: 0, minWidth: 0),
            isCollapsed: isCollapsed,
            fillColor: AppColors.white,
            filled: filled,
            border: inputBorder,
          ),
        ),
        items: items,
        dropdownBuilder: (ctx, value) {
          if (value == null || (value is String && (value == ''))) {
            return Container(
              alignment: selectedAlign ?? AlignmentDirectional.centerStart,
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: Row(
                children: [
                  icon ??  const SizedBox(),
                if(icon != null)
                const SizedBox(width: 10),
                  FittedBox(
                    alignment: selectedAlign ?? AlignmentDirectional.centerStart,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      hint ?? '',
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.ellipsis,
                      style: hintStyle ??
                          TextStyle(
                            color: AppColors.grey,
                            fontSize: 12.sp,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            alignment: selectedAlign ?? AlignmentDirectional.centerStart,
            padding: const EdgeInsetsDirectional.only(start: 10),
            child: Row(
              children: [
                selectedLeadingWidget?.call(ctx, value) ?? const SizedBox(),
                icon ??  const SizedBox(),
                if(icon != null)
                  const SizedBox(width: 10),
                FittedBox(
                  alignment: selectedAlign ?? AlignmentDirectional.centerStart,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value is String
                        ? value
                        : itemAsString == null
                            ? value.toString()
                            : itemAsString!(value),
                    maxLines: 2,
                    textDirection: TextDirection.ltr,
                    overflow: TextOverflow.ellipsis,
                    style: selectedTextStyle ??
                        TextStyle(
                          color: enabled
                              ? AppColors.black
                              : const Color(0xff636363),
                          fontSize: 12.sp,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
        onChanged: onChanged,
        onBeforeChange: onBeforeChange,
      ),
    );
  }
}
