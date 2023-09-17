import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:sizer/sizer.dart';

class ReservationToLocationItemView extends StatelessWidget {
  const ReservationToLocationItemView({
    Key? key,
    required this.addRemoveToLocation,
    required this.textEditingController,
    required this.index,
  }) : super(key: key);

  final Function(bool remove) addRemoveToLocation;
  final TextEditingController textEditingController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextFormField(
              controller: textEditingController,
              hintText: index == 0
                  ? context.chooseCityYouCanGoTo
                  : context.chooseAnotherCityYouCanGoTo,
              prefix: Image.asset(AppAssets.icEndLocation),
            ),
          ),
          SizedBox(
            width: 1.4.w,
          ),
          index == 0
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          addRemoveToLocation(false);
                        },
                        child: const Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Ink(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.red, width: 2),
                          borderRadius:
                              BorderRadius.circular(50.0)), //<-- SEE HERE
                      child: InkWell(
                        onTap: () {
                          addRemoveToLocation(true);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
