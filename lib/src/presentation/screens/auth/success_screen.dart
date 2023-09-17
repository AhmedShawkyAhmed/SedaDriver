import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/custom_clipper.dart';
import 'package:seda_driver/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue2,
      body: Stack(
        children: [
          CustomPaint(
            painter: CardPaint(),
            size: Size(100.w, 55.h),
          ),
          SizedBox(
            width: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 37.h ),
                  child: Image.asset(
                    "assets/icons/ic_logo1.png",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 17.h,right: 3.w),
                  child: DefaultText(
                    text:
                        "شكرا لتسجيلك\n سيتم مراجعة البيانات\n والرد عليك في أقرب وقت",
                    align: TextAlign.right,
                    textColor: AppColors.white,
                    maxLines: 3,
                    fontWeight: FontWeight.w400,
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
