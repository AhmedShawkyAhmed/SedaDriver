import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda_driver/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/models/vehicle_type.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/custom_list_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:seda_driver/src/presentation/widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class VehicleModelScreen extends StatefulWidget {
  const VehicleModelScreen({Key? key, required this.vehicleType})
      : super(key: key);

  final VehicleType vehicleType;

  @override
  State<VehicleModelScreen> createState() => _VehicleModelScreenState();
}

class _VehicleModelScreenState extends State<VehicleModelScreen> {
  final _searchController = TextEditingController();
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    if (AuthCubit.get(context).vehicleCompanyTypes.isEmpty) {
      AuthCubit.get(context).getVehiclesCompanyType(
        company: "${widget.vehicleType.company}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.vehicleModel),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DefaultTextFormField(
              controller: _searchController,
              hintText: context.vehicleModelSearch,
              onChanged: (val) {
                if (val.isNotEmpty) {
                  _filled = true;
                } else {
                  _filled = false;
                }
                setState(() {});
              },
              suffix: _filled
                  ? InkWell(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _filled = false;
                        });
                      },
                      child: Image.asset(AppAssets.icRemove),
                    )
                  : null,
              prefix: const Icon(
                Icons.search,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final cubit = AuthCubit.get(context);
                final data = [...cubit.vehicleCompanyTypes];
                if (_filled) {
                  data.removeWhere((element) =>
                      "${element.type} ${element.model}"
                          .toLowerCase()
                          .contains(_searchController.text.trim()) ==
                      false);
                }
                return state is GetVehiclesCompanyTypesLoading
                    ? const LoadingIndicator()
                    : data.isNotEmpty
                        ? CustomListView(
                            isScrollable: true,
                            data: data
                                .map((e) => "${e.type} ${e.model}")
                                .toList(),
                            onTap: (index) {
                              Navigator.pushNamed(
                                context,
                                AppRouterNames.vehicleColor,
                                arguments: [
                                  widget.vehicleType,
                                  data[index],
                                ],
                              ).then((value) {
                                if (value != null) {
                                  Navigator.pop(context, value);
                                }
                              });
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultAppText(
                                  text: context.noAvailVehicleModels,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                DefaultAppButton(
                                  width: 60.w,
                                  text: context.fetchVehicleModels,
                                  onTap: () => AuthCubit.get(context)
                                      .getVehiclesCompanyType(
                                    company: "${widget.vehicleType.company}",
                                  ),
                                ),
                              ],
                            ),
                          );
              },
            )
          ],
        ),
      ),
    );
  }
}
