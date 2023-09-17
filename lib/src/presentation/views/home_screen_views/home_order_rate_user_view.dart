import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seda_driver/src/business_logic/orders_cubit/orders_cubit.dart';
import 'package:seda_driver/src/business_logic/rate_cubit/rate_cubit.dart';
import 'package:seda_driver/src/business_logic/socket_cubit/socket_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/constants/tools/log_util.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';
import '../../../constants/end_points.dart';
import '../../../constants/tools/toast.dart';
import '../../styles/app_colors.dart';
import '../../widgets/default_app_button.dart';
import '../../widgets/default_app_text.dart';
import '../../widgets/default_text_form_field.dart';
import '../custom_profile_image_view.dart';

class RateUserView extends StatefulWidget {
  const RateUserView({Key? key}) : super(key: key);

  @override
  State<RateUserView> createState() => _RateUserViewState();
}

class _RateUserViewState extends State<RateUserView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController priceController = TextEditingController();
  double rate = 5;
  List<bool> feesPaid = [false, true];
  String paid = "";
  bool changeAdded = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 50),
          child: Container(
            width: 100.w,
            constraints: BoxConstraints(maxHeight: 90.h),
            padding: EdgeInsets.only(bottom: 3.h),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(50),
              ),
              color: isDark ? AppColors.darkBlue : AppColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24,
                ),
                DefaultAppText(
                  text: context.rateTheUser,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 6.5.h,
                  width: 6.5.h,
                  child: CustomProfileImageView(
                    avatarIconPadding: 7,
                    view: true,
                    networkImage: OrdersCubit.get(context)
                                .endOrderResponse!
                                .data![0]
                                .user!
                                .image !=
                            null
                        ? Image.network(
                            "${EndPoints.imageBaseUrl}${OrdersCubit.get(context).endOrderResponse!.data![0].user!.image}",
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultAppText(
                  text: OrdersCubit.get(context)
                      .endOrderResponse!
                      .data![0]
                      .user!
                      .name!,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: rate,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  unratedColor: AppColors.lightGrey,
                  textDirection: TextDirection.ltr,
                  itemSize: 30.sp,
                  glow: false,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_outlined,
                    color: AppColors.yellow,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rate = rating;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultAppText(
                          text: context.didThereAnyChange,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DefaultAppButton(
                            text: context.no,
                            width: 30.w,
                            height: 5.h,
                            backgroundColor: feesPaid[1]
                                ? isDark
                                    ? AppColors.white
                                    : null
                                : isDark
                                    ? AppColors.darkBlue
                                    : AppColors.white,
                            textColor: feesPaid[1]
                                ? isDark
                                    ? AppColors.darkBlue
                                    : AppColors.white
                                : isDark
                                    ? AppColors.white
                                    : AppColors.midBlue,
                            enableBorder: feesPaid[1] ? false : true,
                            borderColor:
                                isDark ? AppColors.white : AppColors.midBlue,
                            onTap: () {
                              setState(() {
                                changeAdded = true;
                                feesPaid[1] = true;
                                feesPaid[0] = false;
                                paid = 'no';
                              });
                            },
                          ),
                          DefaultAppButton(
                              text: context.yes,
                              width: 30.w,
                              height: 5.h,
                              backgroundColor: feesPaid[0]
                                  ? isDark
                                      ? AppColors.white
                                      : null
                                  : isDark
                                      ? AppColors.darkBlue
                                      : AppColors.white,
                              textColor: feesPaid[0]
                                  ? isDark
                                      ? AppColors.darkBlue
                                      : AppColors.white
                                  : isDark
                                      ? AppColors.white
                                      : AppColors.midBlue,
                              enableBorder: feesPaid[0] ? false : true,
                              borderColor:
                                  isDark ? AppColors.white : AppColors.midBlue,
                              onTap: () {
                                setState(() {
                                  changeAdded = false;
                                  feesPaid[0] = true;
                                  feesPaid[1] = false;
                                  paid = 'yes';
                                });
                                showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        enableDrag: false,
                                        backgroundColor: AppColors.transparent,
                                        builder: (context) => ChangeView(
                                            priceController: priceController))
                                    .then((value) {
                                  if (value != '') {
                                    setState(() {
                                      changeAdded = true;
                                    });
                                  }
                                });
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
                DefaultAppButton(
                    text: context.submit,
                    width: 60.w,
                    height: 5.5.h,
                    backgroundColor: isDark
                        ? AppColors.white
                        : feesPaid[0] && !changeAdded
                            ? AppColors.grey
                            : null,
                    textColor: isDark ? AppColors.darkBlue : AppColors.white,
                    onTap: feesPaid[0] && !changeAdded
                        ? () {}
                        : () {
                            showDialog(
                              context: context,
                              builder: (_) => WillPopScope(
                                onWillPop: () => Future.value(false),
                                child: const LoadingIndicator(),
                              ),
                            );
                            final userId = SocketCubit.get(context)
                                .orderResponse
                                ?.orderModel
                                ?.user
                                ?.id;
                            RateCubit.get(context).addRate(
                              userId: userId!,
                              rate: rate.toInt(),
                              comment: "some comment",
                              afterSuccess: () {
                                SocketCubit.get(context).changeStatus();
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                              },
                              afterError: () => Navigator.pop(context),
                            );
                          }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeView extends StatelessWidget {
  const ChangeView({
    super.key,
    required this.priceController,
  });

  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      constraints: BoxConstraints(maxHeight: 90.h),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 4.w,
          right: 4.w),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),
        color: isDark ? AppColors.darkBlue : AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, priceController.text);
                },
                child: Container(
                    margin: EdgeInsets.all(1.5.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: AppColors.black, width: 2)),
                    child: const Icon(Icons.close_rounded)),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultAppText(
                    text: context.areThereFeesLeft,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 1.h),
                  DefaultAppText(
                    text: context.ifFoundWritePriceHere,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ],
              ),
              DefaultTextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                hintText: '',
                height: 5.h,
                width: 15.w,
                borderColor: AppColors.grey,
              )
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          DefaultAppButton(
            text: context.submit,
            width: 60.w,
            height: 5.5.h,
            backgroundColor: isDark ? AppColors.white : null,
            textColor: isDark ? AppColors.darkBlue : AppColors.white,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: const LoadingIndicator(),
                ),
              );
              if(priceController.text.isNotEmpty){
                double amount = double.parse(priceController.text.trim());
                final orderId =
                    SocketCubit.get(context).orderResponse?.orderModel?.id;
                logError(amount.toString());
                OrdersCubit.get(context).addMoneyToWallet(
                  orderId: orderId!,
                  amount: amount,
                  afterSuccess: () {
                    Navigator.pop(context);
                    Navigator.pop(context, priceController.text);
                  },
                  afterError: () {
                    showToast(context.enterValidAmount, ToastState.error);
                    Navigator.pop(context);
                  },
                );
              }else{
                    showToast(context.enterValidAmount, ToastState.error);
                    Navigator.pop(context);
                  }
            },
          ),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
    );
  }
}
