import 'package:bus_system/core/constants/app_constants.dart';
import 'package:bus_system/core/helper/get_responsive_font_size.dart';
import 'package:bus_system/core/utilies/assets/lotties/app_lotties.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/core/utilies/styles/app_text_styles.dart';
import 'package:bus_system/features/student/subscriptions/models/subscriptions_plan_screen.dart';
import 'package:bus_system/features/student/subscriptions/view_models/cubit/subscription_cubit.dart';
import 'package:bus_system/features/student/subscriptions/views/widgets/payment_method_bottom_sheet.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // الشاشة الرئيسية
            Column(
              children: [
                const SubscriptionHeader(),
                Expanded(
                  child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
                    listener: (context, state) {
                      if (state is SubscriptionSuccess) {
                        Navigator.pop(
                          context,
                        ); // Close the seat selection screen
                        CustomQuickAlert.success(
                          title: "Subscription Successful",
                          message: "Your ${state.planName} plan is now active!",
                          animationType:
                              CustomQuickAlertAnimationType.slideInDown,
                        );
                      } else if (state is SubscriptionFailure) {
                        CustomQuickAlert.error(
                          title: "Subscription Failed",
                          message: state.error,
                          animationType:
                              CustomQuickAlertAnimationType.slideInDown,
                        );
                      }
                    },
                    builder: (context, state) {
                      final cubit = context.read<SubscriptionCubit>();
                      final selectedName = _getSelectedPlanName(state);
                      final selectedPlan = AppConstants.subscriptionPlans
                          .firstWhere((p) => p.name == selectedName);
                      final activeSub = (state is SubscriptionInitial) ? state.activeSubscription : null;

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width * 0.04,
                          vertical: SizeConfig.height * 0.025,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (activeSub != null) ...[
                              _ActiveSubscriptionCard(activeSub: activeSub),
                              SizedBox(height: SizeConfig.height * 0.03),
                            ],
                            Text(
                              "Select the perfect subscription for you",
                              style: AppTextStyles.title22TextPrimaryW600,
                            ),
                            SizedBox(height: SizeConfig.height * 0.025),
                            ...AppConstants.subscriptionPlans.map(
                              (plan) => PlanCard(
                                plan: plan,
                                isSelected: selectedName == plan.name,
                                onSelect: () => cubit.selectPlan(plan.name),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            BlocBuilder<SubscriptionCubit, SubscriptionState>(
              builder: (context, state) {
                if (state is! SubscriptionLoading) {
                  return const SizedBox.shrink();
                }

                return Container(
                  color: Colors.black.withOpacity(0.45),
                  child: Center(
                    child:
                        Container(
                          padding: EdgeInsets.all(SizeConfig.height * 0.035),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.height * 0.03,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 25,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                AppLotties.paymentLottie,
                                width: SizeConfig.width * 0.6,
                                height: SizeConfig.height * 0.3,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: SizeConfig.height * 0.02),
                              Text(
                                "Please wait...",
                                style: TextStyle(
                                  fontSize: getResponsiveFontSize(fontSize: 16),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: SizeConfig.height * 0.015),
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ).animate().scale(
                          curve: Curves.elasticOut,
                          duration: 400.ms,
                        ),
                  ),
                );
              },
            ),
          ],
        ),

        // Bottom Bar يظهر فقط لما مش في loading
        bottomNavigationBar: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const SizedBox.shrink();
            }

            final selectedName = _getSelectedPlanName(state);
            final selectedPlan = AppConstants.subscriptionPlans.firstWhere(
              (p) => p.name == selectedName,
            );

            return StickyPayButton(
              price: selectedPlan.price,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => PaymentMethodBottomSheet(
                    onPaymentConfirmed: (method) {
                      context.read<SubscriptionCubit>().subscribe(
                            plan: selectedPlan,
                            paymentMethod: method,
                          );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getSelectedPlanName(SubscriptionState state) {
    if (state is SubscriptionInitial) return state.selectedPlanName;
    if (state is SubscriptionSuccess) return state.planName;
    return "Yearly"; // fallback
  }
}
// ──────────────────────────────────────────────
// باقي الويدجيتس (Header, PlanCard, etc.)
// ──────────────────────────────────────────────

class _ActiveSubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> activeSub;

  const _ActiveSubscriptionCard({required this.activeSub});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.height * 0.024),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(SizeConfig.height * 0.03),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, SizeConfig.height * 0.012),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.height * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: SizeConfig.height * 0.035,
                ),
              ),
              SizedBox(width: SizeConfig.width * 0.03),
              Text(
                "Current Active Plan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(fontSize: 18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: getResponsiveFontSize(fontSize: 14),
                    ),
                  ),
                  Text(
                    activeSub['type']?.toString() ?? 'Semester',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getResponsiveFontSize(fontSize: 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Valid Until",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: getResponsiveFontSize(fontSize: 14),
                    ),
                  ),
                  Text(
                    (activeSub['end_date'] as String?)?.split('T')[0] ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getResponsiveFontSize(fontSize: 16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2);
  }
}

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        SizeConfig.width * 0.05,
        SizeConfig.height * 0.03 + MediaQuery.of(context).padding.top,
        SizeConfig.width * 0.05,
        SizeConfig.height * 0.04,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(SizeConfig.height * 0.045),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.height * 0.014),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_bus_rounded,
              size: SizeConfig.height * 0.048,
              color: Colors.white,
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choose Your Plan", style: AppTextStyles.title28WhiteW500),
                SizedBox(height: SizeConfig.height * 0.008),
                Text(
                  "Safe & comfortable rides to campus at the best prices",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: getResponsiveFontSize(fontSize: 15.5),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(bottom: SizeConfig.height * 0.022),
        padding: EdgeInsets.all(SizeConfig.height * 0.024),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.height * 0.028),
          border: Border.all(
            color: isSelected ? plan.color : Colors.transparent,
            width: isSelected ? 2.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? plan.color.withOpacity(0.22)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: Offset(0, SizeConfig.height * 0.012),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlanHeader(plan: plan, isPopular: plan.isPopular),
            SizedBox(height: SizeConfig.height * 0.022),
            _PriceRow(plan: plan),
            if (plan.saveText.isNotEmpty) ...[
              SizedBox(height: SizeConfig.height * 0.006),
              Text(
                plan.saveText,
                style: TextStyle(
                  color: AppColors.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: getResponsiveFontSize(fontSize: 15),
                ),
              ),
            ],
            SizedBox(height: SizeConfig.height * 0.028),
            ...plan.features.map((f) => FeatureRow(text: f)),
          ],
        ),
      ),
    );
  }
}

class _PlanHeader extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isPopular;

  const _PlanHeader({required this.plan, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.height * 0.013),
          decoration: BoxDecoration(
            color: plan.color.withOpacity(0.13),
            shape: BoxShape.circle,
          ),
          child: Icon(
            plan.icon,
            color: plan.color,
            size: SizeConfig.height * 0.038,
          ),
        ),
        SizedBox(width: SizeConfig.width * 0.035),
        Expanded(child: Text(plan.name, style: AppTextStyles.title22BlackW600)),
        if (isPopular)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.008,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(SizeConfig.height * 0.05),
            ),
            child: Text(
              "BEST VALUE",
              style: TextStyle(
                color: Colors.white,
                fontSize: getResponsiveFontSize(fontSize: 13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final SubscriptionPlan plan;

  const _PriceRow({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          "${plan.price} EGP",
          style: TextStyle(
            color: plan.color,
            fontSize: getResponsiveFontSize(fontSize: 34),
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
        SizedBox(width: SizeConfig.height * 0.012),
        Text(
          plan.period,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: getResponsiveFontSize(fontSize: 15),
          ),
        ),
      ],
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String text;

  const FeatureRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.height * 0.014),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.kPrimaryColor,
            size: SizeConfig.height * 0.024,
          ),
          SizedBox(width: SizeConfig.height * 0.014),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: getResponsiveFontSize(fontSize: 15.5),
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StickyPayButton extends StatelessWidget {
  final String price;
  final VoidCallback onTap;

  const StickyPayButton({super.key, required this.price, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.width * 0.05,
        SizeConfig.height * 0.018,
        SizeConfig.width * 0.05,
        SizeConfig.height * 0.035,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: Offset(0, -SizeConfig.height * 0.01),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: SizeConfig.height * 0.068,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.height * 0.04),
              ),
              elevation: 0,
            ),
            child: Text(
              "Pay $price EGP Now",
              style: AppTextStyles.title18WhiteBold,
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentSuccessDialog extends StatelessWidget {
  final SubscriptionPlan plan;

  const PaymentSuccessDialog({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: SizeConfig.height * 0.9,
          maxHeight: SizeConfig.height * 0.75,
        ),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.height * 0.04),
        padding: EdgeInsets.all(SizeConfig.height * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.height * 0.045),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 40,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              AppLotties.paymentLottie,
              width: SizeConfig.height * 0.22,
              height: SizeConfig.height * 0.22,
              fit: BoxFit.contain,
              repeat: false,
            ),
            SizedBox(height: SizeConfig.height * 0.035),
            Text("Payment Successful!", style: AppTextStyles.title26BlackBold),
            SizedBox(height: SizeConfig.height * 0.018),
            Text(
              "${plan.name} Plan Activated",
              style: TextStyle(
                color: AppColors.kPrimaryColor,
                fontSize: getResponsiveFontSize(fontSize: 18),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.012),
            Text(
              "Enjoy your rides to campus",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: getResponsiveFontSize(fontSize: 15.5),
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.045),
            SizedBox(
              width: double.infinity,
              height: SizeConfig.height * 0.065,
              child: ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.height * 0.04,
                    ),
                  ),
                ),
                child: Text(
                  "Back to Home",
                  style: AppTextStyles.title18WhiteBold,
                ),
              ),
            ),
          ],
        ),
      ).animate().scale(curve: Curves.elasticOut, duration: 420.ms),
    );
  }
}
