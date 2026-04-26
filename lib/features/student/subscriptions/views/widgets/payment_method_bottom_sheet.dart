import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/features/student/subscriptions/views/widgets/credit_card_details_sheet.dart';
import 'package:bus_system/features/student/subscriptions/views/widgets/fawry_dialog.dart';
import 'package:bus_system/features/student/subscriptions/views/widgets/vodafone_cash_dialog.dart';
import 'package:flutter/material.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  final Function(String) onPaymentConfirmed;

  const PaymentMethodBottomSheet({
    super.key,
    required this.onPaymentConfirmed,
  });

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  String _selectedMethod = 'Credit Card';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'Credit Card',
      'subtitle': 'Visa, Mastercard',
      'icon': Icons.credit_card_rounded,
      'color': Colors.blueAccent,
    },
    {
      'title': 'Vodafone Cash',
      'subtitle': '010xxxxxxx',
      'icon': Icons.phone_android_rounded,
      'color': Colors.redAccent,
    },
    {
      'title': 'Fawry',
      'subtitle': 'Pay at any kiosk',
      'icon': Icons.storefront_rounded,
      'color': Colors.orange,
    },
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay when you ride',
      'icon': Icons.money_rounded,
      'color': Colors.green,
    },
  ];

  void _handlePaymentSelection(BuildContext context) {
    Navigator.pop(context); // Close the initial options sheet
    
    if (_selectedMethod == 'Credit Card') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => CreditCardDetailsSheet(
          onPaymentSuccess: () {
            widget.onPaymentConfirmed(_selectedMethod);
          },
        ),
      );
    } else if (_selectedMethod == 'Vodafone Cash') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => VodafoneCashDialog(
          onPaymentSuccess: () {
            widget.onPaymentConfirmed(_selectedMethod);
          },
        ),
      );
    } else if (_selectedMethod == 'Fawry') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => FawryDialog(
          onPaymentSuccess: () {
            widget.onPaymentConfirmed(_selectedMethod);
          },
        ),
      );
    } else {
      // Cash on delivery
      widget.onPaymentConfirmed(_selectedMethod);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.05,
        vertical: SizeConfig.height * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConfig.height * 0.04),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: SizeConfig.width * 0.15,
              height: SizeConfig.height * 0.006,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(SizeConfig.height * 0.01),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.height * 0.03),
          Text(
            "Select Payment Method",
            style: AppTextStyles.title22TextPrimaryW600,
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          ..._paymentMethods.map((method) => _buildPaymentOption(method)),
          SizedBox(height: SizeConfig.height * 0.03),
          SizedBox(
            width: double.infinity,
            height: SizeConfig.height * 0.065,
            child: ElevatedButton(
              onPressed: () => _handlePaymentSelection(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
                ),
                elevation: 0,
              ),
              child: Text(
                "Continue",
                style: AppTextStyles.title18WhiteBold,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> method) {
    final isSelected = _selectedMethod == method['title'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method['title'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: SizeConfig.height * 0.015),
        padding: EdgeInsets.all(SizeConfig.height * 0.02),
        decoration: BoxDecoration(
          color: isSelected ? method['color']?.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.height * 0.02),
          border: Border.all(
            color: isSelected ? method['color'] : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.height * 0.01),
              decoration: BoxDecoration(
                color: method['color']?.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                method['icon'],
                color: method['color'],
                size: SizeConfig.height * 0.03,
              ),
            ),
            SizedBox(width: SizeConfig.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['title'],
                    style: AppTextStyles.title16BlackBold,
                  ),
                  SizedBox(height: SizeConfig.height * 0.005),
                  Text(
                    method['subtitle'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: SizeConfig.width * 0.032,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: method['color'],
                size: SizeConfig.height * 0.03,
              ),
          ],
        ),
      ),
    );
  }
}
