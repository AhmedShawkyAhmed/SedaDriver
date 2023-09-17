import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/constants/constant_methods.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/home_screen_views/home_earning_view.dart';
import 'package:seda_driver/src/presentation/views/main_drawer_views/main_drawer.dart';
import 'package:sizer/sizer.dart';

class HomeMainView extends StatelessWidget {
  const HomeMainView({
    super.key,
    required this.controller,
    required this.gettingMyLocation,
    required this.addMarker,
  });

  final GoogleMapController? controller;
  final ValueNotifier<bool> gettingMyLocation;
  final Function(
    LatLng position,
    String markerId,
    String imageIcon, [
    BitmapDescriptor? svgIcon,
  ]) addMarker;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5.h,
          left: 5.w,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkBlue : AppColors.white,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.transparent,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (_) => const MainDrawer(),
                  );
                },
                child: Image.asset(
                  AppAssets.icDrawerMenu,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          final authCubit = AuthCubit.get(context);
          return authCubit.isConnected == true
              ? Positioned(
                  bottom: 30.h,
                  right: 5.w,
                  child: InkWell(
                    onTap: () async {
                      gettingMyLocation.value = true;
                      await getMyLocation((location, address) async {
                        controller?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                location.latitude,
                                location.longitude,
                              ),
                              zoom: 18,
                            ),
                          ),
                        );
                        addMarker(
                          LatLng(location.latitude, location.longitude),
                          "myLocation",
                          AppAssets.icMyLocation,
                        );
                        gettingMyLocation.value = false;
                      }, context);
                    },
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkBlue : AppColors.white,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 4)
                          ]),
                      child: ValueListenableBuilder(
                        valueListenable: gettingMyLocation,
                        builder: (context, myLocation, child) => myLocation
                            ? const CircularProgressIndicator(
                                color: AppColors.black,
                              )
                            : Image.asset(
                                AppAssets.icLocation,
                                color:
                                    isDark ? AppColors.white : AppColors.black,
                              ),
                      ),
                    ),
                  ),
                )
              : Container();
        }),
        Positioned(
          top: 11.h,
          left: 0,
          right: 0,
          child: const HomeEarningView(),
        ),
      ],
    );
  }
}
