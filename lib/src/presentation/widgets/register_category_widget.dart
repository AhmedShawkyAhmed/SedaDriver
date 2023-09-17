import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class RegisterCategoryWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const RegisterCategoryWidget({
    required this.title,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.grey,
                width: 0.5
              )
            ),
          ),
          child: ExpansionTile(
            title: DefaultText(
              text: title,
              fontWeight: FontWeight.w400,
            ),
            childrenPadding: EdgeInsets.only(bottom: 1.h),
            tilePadding: EdgeInsets.zero,
            children: children,
          ),
        ),
      ],
    );
  }
}
