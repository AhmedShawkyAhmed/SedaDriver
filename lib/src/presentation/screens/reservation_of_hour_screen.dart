import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/reservation_of_hour_screen_views/reservation_to_location_item_view.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:sizer/sizer.dart';

class ReservationOfHourScreen extends StatefulWidget {
  const ReservationOfHourScreen({Key? key}) : super(key: key);

  @override
  State<ReservationOfHourScreen> createState() =>
      _ReservationOfHourScreenState();
}

class _ReservationOfHourScreenState extends State<ReservationOfHourScreen> {
  List<TextEditingController> toLocationController = [
    TextEditingController(),
  ];

  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(3000),
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
      setState(() {
        dateController.text = DateFormat('d MMM, yyyy').format(date);
      });
    }
  }

  TextEditingController timeController = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.reservationOfHour,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Column(
              children: List.generate(
                toLocationController.length,
                (index) => ReservationToLocationItemView(
                  index: index,
                  textEditingController: index == 0
                      ? toLocationController[0]
                      : toLocationController[index],
                  addRemoveToLocation: (remove) {
                    if (remove) {
                      setState(() {
                        toLocationController.removeAt(index);
                      });
                    } else {
                      setState(() {
                        toLocationController.add(TextEditingController());
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            DefaultTextFormField(
              controller: dateController,
              hintText: context.when,
              readOnly: true,
              onTap: () async => await _selectDate(context),
              prefix: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.grey,
              ),
              suffix: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.darkGrey,
                size: 15,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            DefaultTextFormField(
              controller: timeController,
              hintText: context.numberOfHours,
              keyboardType: TextInputType.number,
              prefix: const Icon(
                Icons.access_time_rounded,
                color: Colors.grey,
              ),
              suffix: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.darkGrey,
                size: 15,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            DefaultTextFormField(
              controller: costController,
              hintText: context.hourPrice,
              keyboardType: TextInputType.number,
              prefix: Image.asset(
                AppAssets.icMoney,
                fit: BoxFit.scaleDown,
                color: Colors.grey,
              ),
              suffix: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.darkGrey,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
