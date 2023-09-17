import 'package:flutter/material.dart';
import 'package:seda_driver/src/business_logic/walletCubit/wallet_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:sizer/sizer.dart';

class HomeWalletPageView extends StatelessWidget {
  const HomeWalletPageView({
    Key? key,
    required this.animate,
    required this.updateState,
  }) : super(key: key);

  final bool animate;
  final Function() updateState;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 17.w),
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: animate ? 2.h : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: animate
            ? Border.all(
                color: AppColors.midBlue,
                width: 3,
              )
            : null,
        color: animate ? AppColors.white : AppColors.transparent,
      ),
      duration: const Duration(milliseconds: 250),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultAppButton(
            margin: EdgeInsets.symmetric(horizontal: 7.w),
            backgroundColor: AppColors.midBlue,
            icon: Image.asset(
              AppAssets.icHomeWallet,
            ),
            text:
                '${WalletCubit.get(context).walletResponse.data?.wallet?.balance ?? '0.0'} SAR',
            onTap: updateState,
          ),
          if (animate)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultAppButton(
                    height: 5.h,
                    margin: EdgeInsets.symmetric(horizontal: 7.w),
                    backgroundColor: AppColors.white,
                    enableBorder: true,
                    fontSize: 11.sp,
                    borderColor: AppColors.midBlue,
                    textColor: AppColors.midBlue,
                    fontWeight: FontWeight.w500,
                    text: context.walletRecharge,
                    onTap: () {
                      //TODO
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
