import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppInternetConnectedState) {
          Navigator.pop(context);
        }
      },
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultAppText(
                  text: context.noInternet,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 2.h,
                ),
                DefaultAppText(
                  text: context.slowOrNoInternet,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Image.asset(AppAssets.imgNoInternet),
                SizedBox(
                  height: 8.h,
                ),
                DefaultAppButton(
                  text: context.reloadPage,
                  width: 70.w,
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return WillPopScope(
                            onWillPop: () => Future.value(true),
                            child: const LoadingIndicator(),
                          );
                        });
                    bool result =
                        await AppCubit.get(context).checkNetworkState();
                    if (result) {
                      Navigator.of(context)
                        ..pop(context)
                        ..pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
