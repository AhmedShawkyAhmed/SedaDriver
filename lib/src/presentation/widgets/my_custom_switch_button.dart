import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants_variables.dart';

class MyCustomSwitchButton extends StatefulWidget {
  const MyCustomSwitchButton({
    Key? key,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  final bool value;
  final Function(bool value) onChanged;

  @override
  State<MyCustomSwitchButton> createState() => _MyCustomSwitchButtonState();
}

class _MyCustomSwitchButtonState extends State<MyCustomSwitchButton> {
  late bool _value;

  final _animationDuration = const Duration(milliseconds: 250);

  @override
  void didUpdateWidget(covariant MyCustomSwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
      child: SizedBox(
        width: 12.w,
        child: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.easeInOut,
                width: 8.w,
                height: 1.6.h,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(1, 1),
                        blurStyle: BlurStyle.inner,
                      )
                    ],
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: !_value
                    //       ? [
                    //           const Color(0xFFB8B8B8),
                    //           const Color(0xFFDCDCDC),
                    //         ]
                    //       : [
                    //           AppColors.darkBlue,
                    //           AppColors.lightBlue,
                    //         ],
                    //   stops: const [
                    //     0,
                    //     1,
                    //   ],
                    // ),
                    borderRadius: BorderRadius.circular(25),
                    color: _value
                        ? isDark
                            ? AppColors.white
                            : AppColors.lightBlue
                        : AppColors.midGrey),
              ),
            ),
            AnimatedAlign(
              alignment: !_value ? Alignment.centerLeft : Alignment.centerRight,
              duration: _animationDuration,
              child: Container(
                width: 2.5.h,
                height: 2.5.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.lightBlue : AppColors.white,
                  border: Border.all(
                    color: _value
                        ? isDark
                            ? AppColors.white
                            : AppColors.lightBlue
                        : AppColors.darkGrey,
                    width: 3,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
