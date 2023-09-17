import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/walletCubit/wallet_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WalletCubit.get(context).getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.wallet,
      ),
      body: BlocBuilder<WalletCubit, WalletStates>(builder: (context, state) {
        final cubit = WalletCubit.get(context);
        return Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 3.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                margin: EdgeInsets.only(bottom: 3.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: isDark ? AppColors.white : AppColors.darkGrey,
                  ),
                  color: isDark ? AppColors.darkBlue : AppColors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DefaultAppText(
                      text: context.availableBalance,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                      color: isDark ? AppColors.white : AppColors.darkBlue,
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    DefaultAppText(
                      text: '${cubit.wallet.balance ?? '0.0'} SAR',
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    DefaultAppButton(
                      enableBorder: true,
                      borderColor: AppColors.midBlue,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.midBlue,
                      borderRadius: 120,
                      margin: EdgeInsets.symmetric(horizontal: 18.w),
                      text: context.walletRecharge,
                      onTap: () {
                        //TODO
                      },
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    DefaultAppButton(
                      enableBorder: true,
                      borderColor: isDark ? AppColors.white : AppColors.midBlue,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.midBlue,
                      borderRadius: 120,
                      margin: EdgeInsets.symmetric(horizontal: 18.w),
                      text: context.walletWithdraw,
                      onTap: () {
                        //TODO
                      },
                    ),
                  ],
                ),
              ),
              DefaultAppText(
                text: '${context.transactions} : ',
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                color: isDark ? AppColors.white : AppColors.darkBlue,
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Divider(
                height: 0.h,
                color: isDark ? AppColors.white : AppColors.darkGrey,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.h,
                  ),
                  child: Column(
                    children: List.generate(
                        cubit.wallet.transaction?.length ?? 0,
                        (index) => Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 1,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.darkGrey,
                                ),
                                color: isDark
                                    ? AppColors.darkBlue
                                    : AppColors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  DefaultAppText(
                                    text:
                                        cubit.wallet.transaction?[index].type ??
                                            'charge',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.darkBlue,
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  DefaultAppText(
                                    text:
                                        "${cubit.wallet.transaction?[index].amount ?? '0'} SAR",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  )
                                ],
                              ),
                            )),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
