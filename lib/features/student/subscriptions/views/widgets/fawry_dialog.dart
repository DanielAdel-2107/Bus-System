import 'dart:math';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FawryDialog extends StatefulWidget {
  final VoidCallback onPaymentSuccess;

  const FawryDialog({super.key, required this.onPaymentSuccess});

  @override
  State<FawryDialog> createState() => _FawryDialogState();
}

class _FawryDialogState extends State<FawryDialog> {
  late String fawryCode;

  @override
  void initState() {
    super.initState();
    // Generate a random Fawry code starting with 940
    final random = Random();
    final randomPart = List.generate(7, (_) => random.nextInt(10)).join();
    fawryCode = "940$randomPart";
  }

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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.circular(SizeConfig.height * 0.01),
            ),
            child: Text(
              "Fawry Pay",
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.height * 0.024,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.025),
          Text(
            "Your Fawry Reference Code",
            style: AppTextStyles.title18BlackBold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.height * 0.02,
              horizontal: SizeConfig.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(SizeConfig.height * 0.015),
              border: Border.all(
                color: Colors.yellow[700]!,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fawryCode.substring(0, 3) + " " + fawryCode.substring(3, 6) + " " + fawryCode.substring(6),
                  style: TextStyle(
                    fontSize: SizeConfig.height * 0.03,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: SizeConfig.width * 0.03),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: fawryCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied to clipboard')),
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
          Container(
            padding: EdgeInsets.all(SizeConfig.height * 0.015),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(SizeConfig.height * 0.01),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.orange[800]),
                SizedBox(width: SizeConfig.width * 0.02),
                Expanded(
                  child: Text(
                    "Please pay within 24 hours to avoid cancellation.",
                    style: TextStyle(color: Colors.orange[900], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.03),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onPaymentSuccess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.height * 0.015),
                ),
              ),
              child: Text(
                "Done",
                style: AppTextStyles.title16WhiteBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
