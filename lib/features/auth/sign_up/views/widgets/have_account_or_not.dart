import 'package:flutter/material.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';

class HaveAcountOrNot extends StatelessWidget {
  const HaveAcountOrNot({
    super.key,
    required this.title,
    required this.actionTitle,
    this.onTap,
  });
  final String title;
  final String actionTitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: AppTextStyles.title14Grey700),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionTitle,
            style: AppTextStyles.title14Primary600Underline,
          ),
        ),
      ],
    );
  }
}
