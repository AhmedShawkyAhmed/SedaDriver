import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:sizer/sizer.dart';
import '../../business_logic/app_cubit/app_cubit.dart';
import '../../constants/constants_variables.dart';
import '../../constants/shared_preference_keys.dart';
import '../../constants/tools/toast.dart';
import '../../services/cache_helper.dart';
import '../styles/app_colors.dart';
import '../widgets/default_app_button.dart';
import '../widgets/default_app_text.dart';

class AppLanguageDialog extends StatefulWidget {
  const AppLanguageDialog({Key? key}) : super(key: key);

  @override
  State<AppLanguageDialog> createState() => _AppLanguageDialogState();
}

class _AppLanguageDialogState extends State<AppLanguageDialog> {
  final String ar = 'ar';
  final String en = 'en';
  String group = '';

  @override
  void initState() {
    final lang = CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguage,
        ) ??
        en;
    if (lang == ar) {
      group = ar;
    } else {
      group = en;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h, bottom: 1.h),
                child: DefaultAppText(
                  text: context.appLangCh,
                  fontSize: 18.sp,
                ),
              ),
              RadioListTile<String>(
                value: ar,
                groupValue: group,
                onChanged: (val) => setState(() {
                  group = val!;
                }),
                title: Text.rich(
                  TextSpan(
                    text: context.arabic,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                    ),
                    children: const [
                      TextSpan(
                        text: " (AR)",
                      )
                    ],
                  ),
                ),
              ),
              RadioListTile<String>(
                value: en,
                groupValue: group,
                onChanged: (val) => setState(() {
                  group = val!;
                }),
                title: Text.rich(
                  TextSpan(
                    text: context.english,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                    ),
                    children: const [
                      TextSpan(
                        text: " (EN)",
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 2.h),
                child: DefaultAppButton(
                  text: context.confirm,
                  onTap: () async {
                    final app = AppCubit.get(context);
                    final lang = CacheHelper.getDataFromSharedPreference(
                        key: SharedPreferenceKeys.appLanguage);
                    if (lang == 'ar' && group == ar) {
                      showToast(context.appLangChErrAr, ToastState.warning);
                      return;
                    } else if (lang == 'en' && group == en) {
                      showToast(context.appLangChErrEn, ToastState.warning);
                      return;
                    } else if (group != ar && group != en) {
                      showToast(context.appLangChErrEmpty, ToastState.error);
                      return;
                    }
                    app
                        .changeAppLanguage(Locale(group))
                        .then((value) => Navigator.pop(context));
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
