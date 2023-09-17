import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/auth_cubit/auth_cubit.dart';
import '../../../business_logic/orders_cubit/orders_cubit.dart';

//ignore: must_be_immutable
class MainDrawerHeader extends StatelessWidget {
  MainDrawerHeader({Key? key}) : super(key: key);

  List<String> _titles(BuildContext context) => [
        context.hourDay,
        context.trips,
        context.cancellation,
        '',
      ];
  List<String> _values = [
    '-',
    '-',
    '- %',
    '',
  ];
  String getLevelName(String level, BuildContext context) {
    if (level == 'silver') return context.silverLevel;
    if (level == 'gold') return context.goldenLevel;
    if (level == 'platinum') return context.platinumLevel;
    if (level == 'diamond') return context.diamondLevel;
    return context.silverLevel;
  }

  String getLevelIcon(String level, BuildContext context) {
    if (level == 'silver') return AppAssets.icSilverLevelSvg;
    if (level == 'gold') return AppAssets.icGoldenLevelSvg;
    if (level == 'platinum') return AppAssets.icPlatinumLevelSvg;
    if (level == 'diamond') return AppAssets.icDiamondLevelSvg;
    return AppAssets.icSilverLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 100.w,
      color: AppColors.midBlue,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultAppText(
            text:
                AuthCubit.get(context).currentUser?.userBasicInfo?.name ?? '  ',
            fontSize: 14.sp,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          SizedBox(
            height: 1.5.h,
          ),
          BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
            final cubit = OrdersCubit.get(context);
            _values = [
              cubit.statistics.totalTime ?? '0',
              '${cubit.statistics.orderCount ?? 0}',
              '${((cubit.statistics.cancellationPercent ?? 0) * 100).toStringAsFixed(2)} %',
              ''
            ];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    flex: index == 1 ? 2 : 3,
                    child: Column(
                      children: [
                        DefaultAppText(
                          text: index == 3
                              ? getLevelName(
                                  cubit.statistics.level ?? 'silver', context)
                              : _titles(context)[index],
                          fontSize: 12.sp,
                          color: AppColors.white,
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        index == 3
                            ? SvgPicture.asset(getLevelIcon(
                                cubit.statistics.level ?? 'silver', context))
                            : DefaultAppText(
                                text: _values[index],
                                fontSize: 12.sp,
                                color: AppColors.white,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(
            height: 1.5.h,
          ),
        ],
      ),
    );
  }
}
