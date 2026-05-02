import 'package:bus_system/core/components/custom_text_form_field.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:bus_system/core/utilies/sizes/sized_config.dart';
import 'package:bus_system/features/auth/sign_up/view_models/sign_up_cubit/sign_up_cubit.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignUpForm extends StatefulWidget {
  final String role;
  const SignUpForm({super.key, required this.role});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Full Name
          CustomTextFormField(
            controller: _nameController,
            lable: 'Full Name',
            hintText: 'Ahmed Mohamed',
            prefixIcon: Icons.person_rounded,
            validator: (v) => v?.trim().isEmpty ?? true ? 'Name is required' : null,
          ),

          SizedBox(height: SizeConfig.height * 0.02),

          // Email
          CustomTextFormField(
            controller: _emailController,
            lable: 'Email',
            hintText: 'student@example.com',
            prefixIcon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                return 'Invalid email format';
              }
              return null;
            },
          ),

          SizedBox(height: SizeConfig.height * 0.02),

          // Phone Number
          CustomTextFormField(
            controller: _phoneController,
            lable: 'Phone Number',
            hintText: '01012345678',
            prefixIcon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            validator: (v) => (v?.length ?? 0) < 10 ? 'Invalid phone number' : null,
          ),

          SizedBox(height: SizeConfig.height * 0.02),

          // Gender
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender',
              labelStyle: GoogleFonts.poppins(color: AppColors.primaryBlue),
              prefixIcon: const Icon(Icons.wc, color: AppColors.primaryBlue),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primaryBlue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.lightBlue.withOpacity(0.3)),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (v) => setState(() => _selectedGender = v),
            validator: (v) => v == null ? 'Please select gender' : null,
          ),

          SizedBox(height: SizeConfig.height * 0.02),

          // Password
          CustomTextFormField(
            controller: _passwordController,
            lable: 'Password',
            hintText: '••••••••',
            prefixIcon: Icons.lock_rounded,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryGreen,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) => (v?.length ?? 0) < 6 ? 'Password must be at least 6 characters' : null,
          ),

          SizedBox(height: SizeConfig.height * 0.02),

          // Confirm Password
          CustomTextFormField(
            controller: _confirmPasswordController,
            lable: 'Confirm Password',
            hintText: '••••••••',
            prefixIcon: Icons.lock_rounded,
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryGreen,
              ),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            validator: (v) {
              if (v != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),

          SizedBox(height: SizeConfig.height * 0.015),

          Row(
            children: [
              Checkbox(
                value: _acceptTerms,
                activeColor: AppColors.primaryGreen,
                onChanged: (val) => setState(() => _acceptTerms = val!),
              ),
              Expanded(
                child: Text(
                  'I agree to the Terms & Conditions and Privacy Policy',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.height * 0.03),

          GestureDetector(
            onTap: _submit,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: SizeConfig.height * 0.02),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.5),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Create Account 🚀',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      CustomQuickAlert.warning(
        message: 'You must agree to the terms and conditions',
        title: 'Terms Required',
      );
      return;
    }
    if (_selectedGender == null) {
      CustomQuickAlert.warning(
        message: 'Please select your gender',
        title: 'Gender Required',
      );
      return;
    }

    context.read<SignUpCubit>().signUpUser(
          role: widget.role,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          gender: _selectedGender!,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
