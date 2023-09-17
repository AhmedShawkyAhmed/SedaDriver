import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:sizer/sizer.dart';

class OfferRideSuggestPriceBottomSheet extends StatefulWidget {
  const OfferRideSuggestPriceBottomSheet({Key? key}) : super(key: key);

  @override
  State<OfferRideSuggestPriceBottomSheet> createState() =>
      _OfferRideSuggestPriceBottomSheetState();
}

class _OfferRideSuggestPriceBottomSheetState
    extends State<OfferRideSuggestPriceBottomSheet> {
  final _offerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.h,
        bottom: 2.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 0.7.h,
            width: 20.w,
            decoration: BoxDecoration(
              color: AppColors.midBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: DefaultAppText(
              text: context.suggestPrice,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: AppColors.darkBlue,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.5.h),
            child: DefaultTextFormField(
              controller: _offerController,
              hintText: context.priceOffer,
            ),
          ),
          DefaultAppButton(
            text: context.send,
            onTap: () {
              //TODO
            },
            fontSize: 13.sp,
            width: 80.w,
            margin: EdgeInsets.symmetric(vertical: 3.h),
          ),
          DefaultAppButton(
            width: 80.w,
            margin: EdgeInsets.only(bottom: 3.h),
            backgroundColor: AppColors.transparent,
            text: context.close,
            enableBorder: true,
            borderColor: AppColors.midBlue,
            textColor: AppColors.midBlue,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
