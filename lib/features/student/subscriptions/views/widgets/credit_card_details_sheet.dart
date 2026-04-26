import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CreditCardDetailsSheet extends StatefulWidget {
  final VoidCallback onPaymentSuccess;

  const CreditCardDetailsSheet({super.key, required this.onPaymentSuccess});

  @override
  State<CreditCardDetailsSheet> createState() => _CreditCardDetailsSheetState();
}

class _CreditCardDetailsSheetState extends State<CreditCardDetailsSheet> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.height * 0.03,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + SizeConfig.height * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConfig.height * 0.04),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
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
                    borderRadius: BorderRadius.circular(
                      SizeConfig.height * 0.01,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.05,
                ),
                child: Text(
                  "Card Details",
                  style: AppTextStyles.title22PrimaryW600,
                ),
              ),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: AppColors.kPrimaryColor,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: <CustomCardTypeIcon>[
                  // Add custom icons here if needed
                ],
              ),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                inputConfiguration: InputConfiguration(
                  cardNumberDecoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    hintStyle: AppTextStyles.title16GreyW500,
                    labelStyle: AppTextStyles.title16GreyW500,
                    prefixIcon: Icon(
                      Icons.numbers_rounded,
                      color: AppColors.kPrimaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.kPrimaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  expiryDateDecoration: InputDecoration(
                    labelText: 'Expired Date',
                    hintText: 'XX/XX',
                    hintStyle: AppTextStyles.title16GreyW500,
                    labelStyle: AppTextStyles.title16GreyW500,
                    prefixIcon: Icon(
                      Icons.date_range_rounded,
                      color: AppColors.kPrimaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.kPrimaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  cvvCodeDecoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: 'XXX',
                    hintStyle: AppTextStyles.title16GreyW500,
                    labelStyle: AppTextStyles.title16GreyW500,
                    prefixIcon: Icon(
                      Icons.security_rounded,
                      color: AppColors.kPrimaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.kPrimaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  cardHolderDecoration: InputDecoration(
                    labelText: 'Card Holder',
                    hintStyle: AppTextStyles.title16GreyW500,
                    labelStyle: AppTextStyles.title16GreyW500,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.kPrimaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.kPrimaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
              SizedBox(height: SizeConfig.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width * 0.05,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: SizeConfig.height * 0.065,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.pop(context); // Close the sheet
                        widget.onPaymentSuccess(); // Proceed
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.height * 0.02,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Pay Securely",
                      style: AppTextStyles.title18WhiteBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
