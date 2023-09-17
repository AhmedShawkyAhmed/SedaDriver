import 'package:flutter/material.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_earning_page_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_points_page_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_promotions_page_view.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_wallet_page_view.dart';
import 'package:sizer/sizer.dart';

class HomeEarningView extends StatefulWidget {
  const HomeEarningView({Key? key}) : super(key: key);

  @override
  State<HomeEarningView> createState() => _HomeEarningViewState();
}

class _HomeEarningViewState extends State<HomeEarningView> {
  bool _animate = false;
  final _pageController = PageController();
  final _pageCount = 4;
  int _selectedIndex = 0;

  _generateView(int index) {
    switch (index) {
      case 0:
        return HomeEarningPageView(
          animate: _animate,
          updateState: () {
            setState(() {
              _animate = !_animate;
            });
          },
        );
      case 1:
        return HomePointsPageView(
          animate: _animate,
          updateState: () {
            setState(() {
              _animate = !_animate;
            });
          },
        );
      case 2:
        return HomeWalletPageView(
          animate: _animate,
          updateState: () {
            setState(() {
              _animate = !_animate;
            });
          },
        );
      case 3:
        return HomePromotionsPageView(
          animate: _animate,
          updateState: () {
            setState(() {
              _animate = !_animate;
            });
          },
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 26.h,
          child: PageView.builder(
            physics: _animate ? null : const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            controller: _pageController,
            itemCount: _pageCount,
            itemBuilder: (context, index) {
              return _generateView(index);
            },
          ),
        ),
        if (_animate)
          SizedBox(
            height: 2.h,
          ),
        if (_animate)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _generateIndicators,
          ),
      ],
    );
  }

  List<Widget> get _generateIndicators => List.generate(
        _pageCount,
        (index) => AnimatedContainer(
          width: _selectedIndex == index ? 5.w : 3.w,
          height: 3.w,
          margin: EdgeInsets.only(right: 2.w),
          duration: const Duration(
            milliseconds: 300,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.midBlue,
            ),
            borderRadius: BorderRadius.circular(30),
            color:
                _selectedIndex == index ? AppColors.midBlue : AppColors.white,
          ),
        ),
      );
}
