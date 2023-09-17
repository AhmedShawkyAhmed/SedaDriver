import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/walletCubit/wallet_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  void initState() {
    super.initState();
    WalletCubit.get(context).getPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.points,
      ),
      body: BlocBuilder<WalletCubit, WalletStates>(builder: (context, state) {
        final cubit = WalletCubit.get(context);
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
            vertical: 4.h,
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
                      text: '${cubit.points.points ?? '0'} points',
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                    )
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
                height: 2.h,
              ),
              Column(
                children: List.generate(
                    cubit.points.transaction?.length ?? 0,
                    (index) => Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DefaultAppText(
                                text: cubit.points.transaction?[index].type ??
                                    '-----',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                                color: AppColors.darkBlue,
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              DefaultAppText(
                                text:
                                    "${cubit.points.transaction?[index].amount ?? '0'} SAR",
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        )),
              )
            ],
          ),
        );
      }),
    );
  }
}
