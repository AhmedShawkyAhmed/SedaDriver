import 'package:flutter/material.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_text.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.privacyPolicy),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: DefaultAppText(
          text:context.privacyPolicyContent,
          lineHeight: 1.5,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
