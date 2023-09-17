import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/models/vehicle_company_type.dart';
import 'package:seda_driver/src/models/vehicle_type.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class VehicleColorScreen extends StatefulWidget {
  const VehicleColorScreen({
    Key? key,
    required this.vehicleCompanyType,
    required this.vehicleType,
  }) : super(key: key);
  final VehicleType vehicleType;
  final VehicleCompanyType vehicleCompanyType;

  @override
  State<VehicleColorScreen> createState() => _VehicleColorScreenState();
}

class _VehicleColorScreenState extends State<VehicleColorScreen> {
  @override
  void initState() {
    super.initState();
    if (AuthCubit.get(context).vehicleColors.isEmpty) {
      AuthCubit.get(context).getVehiclesType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.vehicleColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final cubit = AuthCubit.get(context);
            return state is GetVehiclesTypesLoading
                ? const LoadingIndicator()
                : cubit.vehicleColors.isNotEmpty
                    ? CustomListView(
                        isScrollable: true,
                        children: cubit.vehicleColors
                            .map(
                              (e) => InkWell(
                                onTap: () => Navigator.pop(
                                  context,
                                  [
                                    widget.vehicleType,
                                    widget.vehicleCompanyType,
                                    e,
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  height: 6.5.h,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 4.w,
                                        height: 5.w,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xffCACACA),
                                          ),
                                          color: Color(int.parse("${e.code}")),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: DefaultAppText(
                                          text: "${e.name}",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.lightBlue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DefaultAppText(
                              text: context.noAvailVehicleColors,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            DefaultAppButton(
                              width: 60.w,
                              text: context.fetchVehicleColors,
                              onTap: () =>
                                  AuthCubit.get(context).getVehiclesType(),
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
