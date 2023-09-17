import 'package:flutter/material.dart';

class DefaultAppRichText extends StatelessWidget {
  const DefaultAppRichText({
    Key? key,
    required this.children,
    required this.globalTextColor,
    required this.globalTextFontSize,
    required this.globalTextFontWeight,
    required this.globalTextAlign,
    this.globalTextHeight, required this.padding,
  }) : super(key: key);

  final List<InlineSpan> children;
  final Color globalTextColor;
  final double globalTextFontSize;
  final FontWeight globalTextFontWeight;
  final TextAlign globalTextAlign;
  final double? globalTextHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text.rich(
        TextSpan(
          children: children,
          style: TextStyle(
            height: globalTextHeight,
            fontWeight: globalTextFontWeight,
            fontSize: globalTextFontSize,
            color: globalTextColor,
            fontFamily: 'Roboto',
          ),
        ),
        textAlign: globalTextAlign,
      ),
    );
  }
}
