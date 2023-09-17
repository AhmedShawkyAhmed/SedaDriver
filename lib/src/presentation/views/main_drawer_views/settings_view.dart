import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view_item.dart';
import 'package:seda_driver/src/presentation/widgets/my_custom_switch_button.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/app_cubit/app_cubit.dart';
import '../../../constants/constants_variables.dart';
import '../app_language_dialog.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List<List<dynamic>> _reg(BuildContext context) => <List<dynamic>>[
        [
          context.darkModeSetting,
          SvgPicture.asset(
            AppAssets.icDarkMode,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ],
        [
          context.languageSetting,
          SvgPicture.asset(
            AppAssets.icLanguage,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return CustomListView(
        enableBorder: false,
        enableDivider: false,
        children: [
          CustomListViewItem(
            trailing: MyCustomSwitchButton(
              value: isDark,
              onChanged: (_) => AppCubit.get(context).toggleTheme(),
            ),
            leading: _reg(context)[0][1],
            onClick: AppCubit.get(context).toggleTheme,
            height: 6.h,
            leadingTitleSpacing: 6.w,
            titleText: _reg(context)[0][0],
            titleFontSize: 13.sp,
            titleColor:
                isDark ? AppColors.white : AppColors.darkGrey.withOpacity(0.7),
            titleFontWeight: FontWeight.w500,
          ),
          const Divider(
            indent: 15,
            endIndent: 30,
          ),
          CustomListViewItem(
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            leading: _reg(context)[1][1],
            onClick: () => showDialog(
              context: context,
              builder: (_) => const AppLanguageDialog(),
            ),
            height: 6.h,
            leadingTitleSpacing: 6.w,
            titleText: _reg(context)[1][0],
            titleFontSize: 13.sp,
            titleColor:
                isDark ? AppColors.white : AppColors.darkGrey.withOpacity(0.7),
            titleFontWeight: FontWeight.w500,
          ),
        ],
      );
    });
  }
}
