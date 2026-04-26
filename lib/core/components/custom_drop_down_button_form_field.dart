import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';

class CustomDropDownButtonFormField<T> extends StatelessWidget {
  const CustomDropDownButtonFormField({
    super.key,
    required this.items,
    this.controller,
    this.hintText,
    this.title,
    this.onChanged,
    this.fillColor,
    this.itemLabelBuilder,
    this.value,
    this.primaryColor,
  });

  final List<T> items;
  final T? value; // ✅ دي هي القيمة المختارة حاليًا

  final TextEditingController? controller;
  final String? hintText;
  final String? title;
  final Function(T?)? onChanged;
  final Color? fillColor;
  final Color? primaryColor;

  final String Function(T)? itemLabelBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: AppTextStyles.title18PrimaryColorW500.copyWith(color: primaryColor)),
        SizedBox(height: SizeConfig.height * 0.003),
        DropdownButtonFormField<T>(
          initialValue: value, // ✅ القيمة المختارة
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e, // ✅ هنا العنصر نفسه
                  child: Text(
                    itemLabelBuilder != null
                        ? itemLabelBuilder!(e)
                        : e.toString(),
                    style: AppTextStyles.title18Black,
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (controller != null) {
              controller!.text = val.toString();
            }
            if (onChanged != null) onChanged!(val);
          },
          isExpanded: true,
          iconEnabledColor: primaryColor ?? AppColors.kPrimaryColor,
          iconDisabledColor: primaryColor ?? AppColors.kPrimaryColor,
          dropdownColor: Colors.white,
          style: AppTextStyles.title18Black,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.015,
            ),
            filled: true,
            fillColor: fillColor ?? Colors.grey.shade50,
            border: buildBorder(),
            enabledBorder: buildBorder(),
            focusedBorder: buildBorder(primaryColor ?? AppColors.kPrimaryColor),
          ),
          hint: Text(
            hintText ?? "Select",
            style: AppTextStyles.title16Grey,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.width * 0.03),
      borderSide: BorderSide(
        color: color ?? Colors.grey.withOpacity(0.15),
        width: color != null ? 2 : 1.5,
      ),
    );
  }
}
