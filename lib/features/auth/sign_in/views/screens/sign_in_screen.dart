import 'package:bus_system/core/app_route/route_names.dart';
import 'package:bus_system/core/utilies/assets/images/app_images.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => SignInCubit(),
        child: const SignInScreenBody(),
      ),
    );
  }
}

class SignInScreenBody extends StatefulWidget {
  const SignInScreenBody({super.key});

  @override
  State<SignInScreenBody> createState() => _SignInScreenBodyState();
}

class _SignInScreenBodyState extends State<SignInScreenBody> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();

    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInLoading) {
          CustomQuickAlert.loading(
            title: 'Please wait',
            message: 'Logging you in...',
            barrierDismissible: false,
          );
        } else if (state is SignInSuccess) {
          CustomQuickAlert.dismiss();
          CustomQuickAlert.success(
            title: 'Success',
            message: 'Signed in successfully!',
          );
          Future.delayed(const Duration(milliseconds: 800), () {
            if (state.role == 'student') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.dashboardScreen,
                (route) => false,
              );
            } else if (state.role == 'driver') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.driverDashboard,
                (route) => false,
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.universityDashboard,
                (route) => false,
              );
            }
          });
        } else if (state is SignInFailure) {
          CustomQuickAlert.dismiss();
          CustomQuickAlert.error(
            title: 'Sign In Failed',
            message: state.message,
          );
        }
      },
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    // Logo with animation
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightBlue.withOpacity(0.3),
                          width: 14,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.2),
                            blurRadius: 60,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: Image.asset(AppImages.logoImage),
                    )
                        .animate()
                        .scale(duration: 800.ms, curve: Curves.easeOutBack)
                        .then()
                        .shimmer(duration: 1400.ms),

                    const SizedBox(height: 30),

                    Text(
                      'Welcome Back 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

                    Text(
                      'Login to track your bus in real-time',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

                    const SizedBox(height: 50),

                    // Email Address
                    _buildLabeledTextField(
                      controller: cubit.emailController,
                      label: 'Email Address',
                      hint: 'example@university.edu.eg',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please enter your email';
                        if (!v.contains('@') || !v.contains('.')) return 'Please enter a valid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Password
                    _buildLabeledTextField(
                      controller: cubit.passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.primaryGreen,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter your password';
                        if (v.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 30),

                    // Login Button
                    GestureDetector(
                      onTap: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.signIn();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryBlue, AppColors.primaryGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withOpacity(0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Login →',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .scale(duration: 500.ms, curve: Curves.elasticOut)
                          .then()
                          .shimmer(duration: 1200.ms),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RouteNames.selectRoleScreen);
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabeledTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(icon, color: AppColors.primaryBlue),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.lightBlue.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2);
  }
}
