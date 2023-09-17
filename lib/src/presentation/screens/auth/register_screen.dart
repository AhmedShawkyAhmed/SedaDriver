import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seda_driver/src/constants/constants_variables.dart';
import 'package:seda_driver/src/constants/localization/app_localization.dart';
import 'package:seda_driver/src/presentation/router/app_routes_names.dart';
import 'package:seda_driver/src/presentation/styles/app_colors.dart';
import 'package:seda_driver/src/presentation/views/custom_app_bar.dart';
import 'package:seda_driver/src/presentation/views/pick_image_bottom_sheet.dart';
import 'package:seda_driver/src/presentation/widgets/attachment_widget.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_button.dart';
import 'package:seda_driver/src/presentation/widgets/default_app_rich_text.dart';
import 'package:seda_driver/src/presentation/widgets/register_category_widget.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<void> _pickImage(
      BuildContext context, Function(XFile image) image) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(35),
          topLeft: Radius.circular(35),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (_) => PickImageBottomSheet(
        selectImage: image,
      ),
    );
  }

  bool idPhoto = false;
  bool idVehicle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Complete Data"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            RegisterCategoryWidget(
              title: "National ID",
              children: [
                AttachmentWidget(
                  image: frontImage,
                  title: "Front",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        frontImage = image;
                      });
                    });
                  },
                ),
                AttachmentWidget(
                  image: backImage,
                  title: "Back",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        backImage = image;
                      });
                    });
                  },
                ),
              ],
            ),
            RegisterCategoryWidget(
              title: "Driver License",
              children: [
                AttachmentWidget(
                  image: frontImage,
                  title: "Front",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        frontImage = image;
                      });
                    });
                  },
                ),
                AttachmentWidget(
                  image: backImage,
                  title: "Back",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        backImage = image;
                      });
                    });
                  },
                ),
              ],
            ),
            RegisterCategoryWidget(
              title: "Car License",
              children: [
                AttachmentWidget(
                  image: frontImage,
                  title: "Front",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        frontImage = image;
                      });
                    });
                  },
                ),
                AttachmentWidget(
                  image: backImage,
                  title: "Back",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        backImage = image;
                      });
                    });
                  },
                ),
              ],
            ),
            RegisterCategoryWidget(
              title: "Vehicle Photo",
              children: [
                AttachmentWidget(
                  image: frontImage,
                  title: "Front",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        frontImage = image;
                      });
                    });
                  },
                ),
                AttachmentWidget(
                  image: backImage,
                  title: "Back",
                  onSelect: () {
                    _pickImage(context, (image) {
                      Navigator.pop(context);
                      setState(() {
                        backImage = image;
                      });
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            DefaultAppRichText(
              children: [
                TextSpan(
                  text: context.registerText1,
                ),
                TextSpan(
                  text: " ${context.terms}",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushNamed(
                      context,
                      AppRouterNames.termsAndConditions,
                    ),
                  style: const TextStyle(
                    color: AppColors.lightBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
              globalTextColor: AppColors.darkGrey,
              globalTextFontSize: 10.sp,
              globalTextFontWeight: FontWeight.w500,
              globalTextAlign: TextAlign.center,
              globalTextHeight: 1.5,
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
            SizedBox(
              height: 3.h,
            ),
            DefaultAppButton(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              text: context.registration,
              onTap: () {
                Navigator.pushNamed(context, AppRouterNames.success);
              },
            ),
          ],
        ),
      ),
    );
  }
}
