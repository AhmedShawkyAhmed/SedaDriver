import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/styles/app_assets.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_text_form_field.dart';
import 'package:sizer/sizer.dart';

class CityToCityScreen extends StatefulWidget {
  const CityToCityScreen({Key? key}) : super(key: key);

  @override
  State<CityToCityScreen> createState() => _CityToCityScreenState();
}

class _CityToCityScreenState extends State<CityToCityScreen> {
  TextEditingController fromLocationController = TextEditingController();
  List<TextEditingController> toLocationController = [
    TextEditingController(),
  ];

  Widget createToLocation(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextFormField(
              controller: index == 0
                  ? toLocationController[0]
                  : toLocationController[index],
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
                    border: Border.all(color: AppColors.black, width: 2),
                    borderRadius:
                    BorderRadius.circular(50.0)), //<-- SEE HERE
                child: InkWell(
                  onTap: () {
                    setState(() {
                      toLocationController.add(TextEditingController());
                    });
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
                    setState(() {
                      toLocationController.removeAt(index);
                    });
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

  TextEditingController timeController = TextEditingController();
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
        timeController.text = DateFormat('d MMM, yyyy').format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.cityToCity,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DefaultTextFormField(
                controller: fromLocationController,
                hintText: context.chooseYourCity,
                prefix: Image.asset(AppAssets.icStartLocation),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Column(
                children: List.generate(
                  toLocationController.length,
                      (index) => createToLocation(index),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              DefaultTextFormField(
                controller: timeController,
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
            ],
          ),
        ),
      ),
    );
  }
}
