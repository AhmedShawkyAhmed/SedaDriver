import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:sizer/sizer.dart';

import '../../styles/app_assets.dart';
import '../../styles/app_colors.dart';
import '../../widgets/default_app_text.dart';

class HomeTripRequestDraggableView extends StatefulWidget {
  const HomeTripRequestDraggableView({
    Key? key,
    required this.child,
    required this.onDragUp,
    required this.onDragDown,
  }) : super(key: key);

  final Widget child;
  final Function() onDragUp;
  final Function() onDragDown;

  @override
  State<HomeTripRequestDraggableView> createState() =>
      _HomeTripRequestDraggableViewState();
}

class _HomeTripRequestDraggableViewState
    extends State<HomeTripRequestDraggableView> {
  bool accept = true;
  bool refuse = true;
  double height = 0;
  bool up = true;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      affinity: Axis.horizontal,
      axis: Axis.vertical,
      feedback: widget.child,
      onDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy != 0) {
          if (details.offset.dy < 55.h) {
            if (details.offset.dy > 50.h) {
            } else {
              widget.onDragUp();
              setState(() {
                accept = false;
                refuse = false;
              });
            }
          } else if (details.offset.dy > 60.h) {
            if (details.offset.dy > 70.h) {
              widget.onDragDown();
              setState(() {
                accept = false;
                refuse = false;
              });
            }
          }
        }
      },
      onDragUpdate: (details) {
        // print(details.delta.direction);
        if (details.delta.direction != 0.0) {
          height = 60.h;
        }
        if (details.delta.dy.isNegative) {
          setState(() {
            up = true;
          });
          if (details.localPosition.dy > 50.h) {
            setState(() {
              accept = false;
              refuse = false;
            });
          } else {
            setState(() {
              accept = true;
              refuse = false;
            });
          }
        } else {
          setState(() {
            up = false;
          });
          if (details.localPosition.dy > 82.h) {
            setState(() {
              accept = false;
              refuse = true;
            });
          } else {
            setState(() {
              accept = false;
              refuse = false;
            });
          }
        }
      },
      childWhenDragging: Container(
        height: height,
        width: 100.w,
        margin: EdgeInsets.symmetric(
          horizontal: 0.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(50), bottom: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              offset: const Offset(0, -2),
              blurRadius: 3,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 2.h,
        ),
        child: Column(
          mainAxisAlignment:
              up ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            DefaultAppText(
              text: accept
                  ? context.acceptingOrder
                  : refuse
                      ? context.rejectingOrder
                      : '',
              color: accept
                  ? AppColors.green
                  : refuse
                      ? AppColors.red
                      : AppColors.lightGrey,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              height: 20.h,
              width: 20.h,
              padding: EdgeInsets.all(1.5.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: accept
                          ? AppColors.green
                          : refuse
                              ? AppColors.red
                              : AppColors.grey,
                      width: 1.5.h)),
              alignment: Alignment.center,
              child: Image.asset(
                AppAssets.imgCar,
              ),
            ),
          ],
        ),
      ),
      child: widget.child,
    );
  }
}
