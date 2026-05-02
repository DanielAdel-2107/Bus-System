import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.lable,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.maxline = 1,
    this.fillColor,
    this.onChanged,
    this.onTap,
    this.enable = true,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });
  final int maxline;
  final String? hintText;
  final String? lable;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final Color? fillColor;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool enable;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          style: AppTextStyles.title18Black,
          onChanged: onChanged,
          controller: controller,
          onTap: onTap,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            labelText: lable,
            labelStyle: AppTextStyles.title16PrimaryColorW500,
            enabled: enable,
            fillColor: fillColor ?? Colors.transparent,
            filled: true,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.kPrimaryColor)
                : null,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: AppTextStyles.title16Grey,
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.015,
            ),
            border: buildBorder(),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(),
            errorBorder: buildBorder(color: Colors.red),
            focusedErrorBorder: buildBorder(color: Colors.red, width: 2),
          ),
          maxLines: maxline,
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: color ?? AppColors.kPrimaryColor,
        width: width,
      ),
    );
  }
}
