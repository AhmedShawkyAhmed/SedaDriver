import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({Key? key}) : super(key: key);

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.inviteFriends,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 1.h, top: 5.h),
              child: Column(
                children: [
                  Image.asset(AppAssets.imgInviteFriends),
                  SizedBox(
                    height: 5.h,
                  ),
                  DefaultAppText(
                    text: context.inviteFriendsToGetReward,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      border: Border.all(
                        width: 1,
                        color: AppColors.grey,
                      ),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.midGrey,
                          AppColors.lightGrey,
                        ],
                        stops: [
                          0,
                          100,
                        ],
                      ),
                    ),
                    child: DefaultAppText(
                      text: 'GABC123EF',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            DefaultAppButton(
              text: context.sendInviteFriendCoupon,
              onTap: () {
                //TODO
              },
              fontSize: 13.sp,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            ),
          ],
        ),
      ),
    );
  }
}
