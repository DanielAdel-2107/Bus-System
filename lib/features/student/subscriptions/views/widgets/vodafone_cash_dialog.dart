import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class VodafoneCashDialog extends StatelessWidget {
  final VoidCallback onPaymentSuccess;
  final String transferNumber = "01012345678";
  final String email = "payment@bus-system.com";

  const VodafoneCashDialog({super.key, required this.onPaymentSuccess});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.height * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(SizeConfig.height * 0.02),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.phone_android_rounded,
              color: Colors.redAccent,
              size: SizeConfig.height * 0.06,
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          Text(
            "Vodafone Cash Payment",
            style: AppTextStyles.title20BlackBold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          Text(
            "Please transfer the subscription amount to the following number:",
            textAlign: TextAlign.center,
            style: AppTextStyles.title16Grey.copyWith(height: 1.4),
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.height * 0.015,
              horizontal: SizeConfig.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(SizeConfig.height * 0.015),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transferNumber,
                  style: AppTextStyles.title18BlackBold.copyWith(
                    letterSpacing: 1.5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: transferNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Number copied to clipboard')),
                    );
                  },
                  child: Icon(
                    Icons.copy_rounded,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          Text(
            "After transferring, please send the receipt screenshot to:",
            textAlign: TextAlign.center,
            style: AppTextStyles.title14Grey.copyWith(height: 1.4),
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          Text(
            email,
            style: AppTextStyles.title16PrimaryColorBold,
          ),
          SizedBox(height: SizeConfig.height * 0.03),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                onPaymentSuccess(); // Proceed with subscription
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.height * 0.015),
                ),
              ),
              child: Text(
                "I have transferred",
                style: AppTextStyles.title16WhiteBold,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.01),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTextStyles.title16GreyW500,
            ),
          ),
        ],
      ),
    );
  }
}
