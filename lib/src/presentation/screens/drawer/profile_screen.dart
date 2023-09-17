import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/constants/end_points.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants_variables.dart';
import '../../styles/app_colors.dart';
import '../../views/custom_profile_image_view.dart';
import '../../widgets/default_app_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    if (AuthCubit.get(context).currentUser == null) {
      AuthCubit.get(context).profile();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text =
          AuthCubit.get(context).currentUser!.userBasicInfo!.name!;
      _emailController.text =
          AuthCubit.get(context).currentUser!.userBasicInfo!.email ?? '';
      _birthController.text =
          AuthCubit.get(context).currentUser!.userBasicInfo!.birth ??
              context.enterBirth;
      // _locationController.text =
      //     AuthCubit.get(context).currentUser!.userBasicInfo!.address!;
      // logError(
      //     "${AuthCubit.get(context).currentUser!.vehicleInfo!.vehicleTypesType}");
    });
    super.initState();
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthController = TextEditingController();
  // final _locationController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(2010),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.darkBlue,
          colorScheme: const ColorScheme.light(
            primary: AppColors.darkBlue,
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        child: child ?? const SizedBox(),
      ),
    );
    if (date != null) {
      _birthController.text = DateFormat('yyyy-MMM-d').format(date);
    }
  }

  double? _lat, _lon;
  XFile? _profileImage;

  bool editing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: editing ? context.editProfile : context.profile),
      body:
          BlocConsumer<AuthCubit, AuthState>(listener: (context, state) async {
        if (state is UpdateProfileSuccess) {
          Navigator.pop(context);
          AuthCubit.get(context).profile();
          setState(() {
            _profileImage = null;
            editing = false;
          });
        }else if(state is ProfileSuccess) {
            _nameController.text =
                AuthCubit.get(context).currentUser!.userBasicInfo!.name ?? '';
            _emailController.text =
                AuthCubit.get(context).currentUser!.userBasicInfo!.email ?? '';
            _birthController.text =
                AuthCubit.get(context).currentUser!.userBasicInfo!.birth ??
                    context.enterBirth;
            // _locationController.text =
            //     AuthCubit.get(context).currentUser!.userBasicInfo!.address ??
            //         '';
        }
      }, builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final vehicleInfo = AuthCubit.get(context).currentUser!.vehicleInfo!;
          final user = AuthCubit.get(context).currentUser!.userBasicInfo;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    child: SizedBox(
                      height: 12.h,
                      width: 12.h,
                      child: CustomProfileImageView(
                        backgroundColor: AppColors.lightGrey,
                        iconColor: AppColors.white,
                        view: !editing,
                        networkImage: _profileImage == null
                            ? Image.network(
                                "${EndPoints.imageBaseUrl}${user?.image}",
                                fit: BoxFit.cover,
                              )
                            : null,
                        selectImage: (image) {
                          Navigator.pop(context);
                          setState(() {
                            _profileImage = image;
                          });
                        },
                        image: _profileImage?.path,
                      ),
                    ),
                  ),
                ),
                DefaultTextFormField(
                  enabled: editing ? true : false,
                  controller: _nameController,
                  hintText: 'enter name',
                  top: 2.h,
                  bottom: 2.h,
                  height: 8.h,
                  hintTextColor:
                      isDark ? AppColors.white : AppColors.darkGrey,
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  prefix: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SvgPicture.asset(AppAssets.icPerson,
                        color: isDark ? AppColors.white : AppColors.darkGrey),
                  ),
                ),
                DefaultTextFormField(
                  enabled: editing ? true : false,
                  controller: _emailController,
                  hintText: 'enter email address',
                  top: 2.h,
                  bottom: 2.h,
                  height: 8.h,
                  hintTextColor:
                      isDark ? AppColors.white : AppColors.darkGrey,
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  prefix: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SvgPicture.asset(AppAssets.icEmail,
                        color: isDark ? AppColors.white : AppColors.darkGrey),
                  ),
                ),
                DefaultTextFormField(
                  enabled: editing ? true : false,
                  readOnly: true,
                  controller: _birthController,
                  hintText: 'enter birth of date',
                  top: 2.h,
                  bottom: 2.h,
                  height: 8.h,
                  hintTextColor:
                      isDark ? AppColors.white : AppColors.darkGrey,
                  margin: EdgeInsets.symmetric(vertical: 1.5.h),
                  prefix: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SvgPicture.asset(AppAssets.icCalender,
                        color: isDark ? AppColors.white : AppColors.darkGrey),
                  ),
                  suffix: editing
                      ? Icon(Icons.keyboard_arrow_down_rounded,
                          color:
                              isDark ? AppColors.white : AppColors.darkGrey)
                      : null,
                  onTap: () => _selectDate(context),
                ),
                // DefaultTextFormField(
                //   enabled: editing ? true : false,
                //   readOnly: true,
                //   controller: _locationController,
                //   hintText: 'enter your Location',
                //   top: 2.h,
                //   bottom: 2.h,
                //   height: 8.h,
                //   hintTextColor:
                //       isDark ? AppColors.white : AppColors.darkGrey,
                //   margin: EdgeInsets.symmetric(vertical: 1.5.h),
                //   prefix: SvgPicture.asset(AppAssets.icLocation1,
                //       color: isDark ? AppColors.white : AppColors.darkGrey),
                //   suffix: editing
                //       ? Image.asset(AppAssets.icLocation,
                //           color:
                //               isDark ? AppColors.white : AppColors.darkGrey)
                //       : null,
                //   onTap: () {
                //     showModalBottomSheet(
                //       context: context,
                //       isScrollControlled: true,
                //       enableDrag: false,
                //       builder: (_) => const SelectLocationMapView(),
                //     ).then((value) {
                //       if (value != null) {
                //         setState(() {
                //           _lat = value['latitude'];
                //           _lon = value['longitude'];
                //           _locationController.text = value['address'];
                //         });
                //       }
                //     });
                //   },
                // ),
                if (!editing)
                  Container(
                    height: 6.4.h,
                    margin: EdgeInsets.symmetric(vertical: 1.5.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.sp,
                          color:
                              isDark ? AppColors.white : AppColors.darkGrey,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.icCar,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.darkGrey,
                            ),
                            SizedBox(width: 5.w),
                            DefaultAppText(
                              text:
                                  '${vehicleInfo.vehicleTypesCompany!}  ${vehicleInfo.vehicleTypesType!}',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.4.h, horizontal: 0.6.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    width: 1.sp,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.grey,
                                  )),
                              child: DefaultAppText(
                                text: vehicleInfo.carNumber!,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Container(
                              height: 2.h,
                              width: 2.h,
                              decoration: BoxDecoration(
                                color: Color(
                                    int.parse(vehicleInfo.vehicleColorCode!)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                DefaultAppButton(
                  text: editing ? context.save : context.editProfile,
                  height: 5.5.h,
                  textColor: AppColors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
                  onTap: () {
                    if (editing) {
                      final user = AuthCubit.get(context).currentUser;
                      String? name, nickname, birth, email;
                      name = (user!.userBasicInfo!.name?.trim() !=
                                  _nameController.text.trim() &&
                              _nameController.text.trim().isNotEmpty)
                          ? _nameController.text.trim()
                          : user.userBasicInfo!.name;
                      email = (user.userBasicInfo!.email?.trim() !=
                                  _emailController.text.trim() &&
                              _emailController.text.trim().isNotEmpty)
                          ? _emailController.text.trim()
                          : user.userBasicInfo!.email;
                      birth = (user.userBasicInfo!.birth?.trim() !=
                                  _birthController.text.trim() &&
                              _birthController.text.isNotEmpty)
                          ? _birthController.text.trim()
                          : user.userBasicInfo!.birth;
                      if (name != null ||
                          email != null ||
                          birth != null ||
                          _profileImage != null) {
                        showDialog(
                          context: context,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        AuthCubit.get(context).updateProfile(
                          name: name,
                          email: email,
                          birthDate: birth,
                          image: _profileImage?.path,
                        );
                      }
                    } else {
                      setState(() {
                        editing = true;
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
