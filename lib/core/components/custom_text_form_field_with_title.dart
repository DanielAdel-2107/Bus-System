import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldWithTitle extends StatefulWidget {
  const CustomTextFormFieldWithTitle({
    super.key,
    this.onChanged,
    this.enable = true,
    this.labelText,
    this.hintText,
    this.title,
    this.isPassword = false,
    this.controller,
    this.enableValidator = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.keyboardType,
    this.primaryColor,
  });
  final String? labelText;
  final String? hintText;
  final String? title;
  final TextInputType? keyboardType;
  final bool isPassword, enableValidator;
  final TextEditingController? controller;
  final int maxLines;
  final bool? enable;
  final IconData? prefixIcon;
  final Color? primaryColor;
  final Function(String)? onChanged;
  @override
  State<CustomTextFormFieldWithTitle> createState() =>
      _CustomTextFormFieldWithTitleState();
}

class _CustomTextFormFieldWithTitleState
    extends State<CustomTextFormFieldWithTitle> {
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title == null
            ? const SizedBox()
            : Text(
                widget.title!,
                style: AppTextStyles.title18PrimaryColorW500.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
        SizedBox(height: SizeConfig.height * 0.003),
        TextFormField(
          style: AppTextStyles.title18Black,
          enabled: widget.enable,
          cursorColor: widget.primaryColor ?? AppColors.primaryBlue,
          controller: widget.controller,
          onChanged: widget.onChanged,
          validator: widget.enableValidator
              ? (value) => value!.isEmpty
                    ? "Field ${widget.title ?? ''} is required"
                    : null
              : null,
          obscureText: widget.isPassword ? isPassword : false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.0175,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    color: widget.primaryColor ?? AppColors.kPrimaryColor,
                    size: SizeConfig.width * 0.07,
                  ),
            hintStyle: AppTextStyles.title16Grey,
            border: buildBorder(),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(
              widget.primaryColor ?? AppColors.kPrimaryColor,
            ),
            disabledBorder: buildBorder(),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    icon: Icon(
                      isPassword ? Icons.visibility_off : Icons.visibility,
                      color: widget.primaryColor ?? AppColors.kPrimaryColor,
                    ),
                  )
                : null,
          ),
          maxLines: widget.maxLines,
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        SizeConfig.width * 0.03,
      ), // 3% من العرض
      borderSide: BorderSide(
        color: color ?? Colors.grey.withOpacity(0.15),
        width: color != null ? 2 : 1.5,
      ),
    );
  }
}
