import 'package:bus_system/core/utilies/assets/images/app_images.dart';
import 'package:bus_system/core/utilies/colors/app_colors.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// افتراض: CustomQuickAlert موجود في مشروعك
// import 'package:your_project/widgets/custom_quick_alert.dart';   ← عدل المسار حسب مشروعك
// لو مش موجود، ممكن تستبدله بـ SnackBar أو AlertDialog مؤقتًا

// ──────────────────────────────────────────────
// Auth Cubit & State
// ──────────────────────────────────────────────

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isSuccess => user != null && !isLoading && !hasError;
}

class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient supabase;

  AuthCubit(this.supabase) : super(AuthState());

  Future<void> signUpStudent({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String gender,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // 1. Sign up in Auth
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'role': 'student',
        },
      );

      final user = response.user;
      if (user == null) {
        throw Exception('User creation failed');
      }

      // 2. Insert into profiles
      await supabase.from('profiles').insert({
        'id': user.id,
        'full_name': fullName,
        'phone': phone,
        'role': 'student',
        'gender': gender,
      });

      // 3. Insert into students
      await supabase.from('students').insert({
        'id': user.id,
        'gender': gender,
      });

      emit(state.copyWith(isLoading: false, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } on PostgrestException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Database error occurred',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error: $e',
      ));
    }
  }
}

// ──────────────────────────────────────────────
// Sign Up Screen
// ──────────────────────────────────────────────

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    return BlocProvider(
      create: (_) => AuthCubit(Supabase.instance.client),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isLoading) return;

          if (state.isSuccess) {
            CustomQuickAlert.success(
              message: 'Account created successfully!',
              title: 'Success',
              onConfirm: () {
                Navigator.pop(context); // go back (e.g. to login or previous screen)
              },
            );
          }

          if (state.hasError) {
            CustomQuickAlert.error(
              message: state.errorMessage ?? 'Something went wrong',
              title: 'Error',
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        child: Image.asset(
                          AppImages.logoImage,
                          fit: BoxFit.contain,
                        ),
                      )
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.easeOutBack)
                          .then()
                          .shimmer(duration: 1400.ms),

                      const SizedBox(height: 30),

                      Text(
                        'Create New Account 👋',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

                      Text(
                        'Join thousands of students & parents',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

                      const SizedBox(height: 40),

                      // Full Name
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Ahmed Mohamed',
                        icon: Icons.person_rounded,
                        validator: (v) =>
                            v?.trim().isEmpty ?? true ? 'Name is required' : null,
                      ),

                      const SizedBox(height: 20),

                      // Email
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'student@example.com',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Phone Number
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: '01012345678',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            (v?.length ?? 0) < 10 ? 'Invalid phone number' : null,
                      ),

                      const SizedBox(height: 20),

                      // Gender
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon:
                              const Icon(Icons.wc, color: AppColors.primaryBlue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(value: 'female', child: Text('Female')),
                        ],
                        onChanged: (v) => setState(() => _selectedGender = v),
                        validator: (v) =>
                            v == null ? 'Please select gender' : null,
                      ),

                      const SizedBox(height: 20),

                      // Password
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        icon: Icons.lock_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primaryGreen,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) => (v?.length ?? 0) < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      // Confirm Password
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hint: '••••••••',
                        icon: Icons.lock_rounded,
                        obscureText: _obscureConfirm,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primaryGreen,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        validator: (v) {
                          if (v != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: AppColors.primaryGreen,
                            onChanged: (val) =>
                                setState(() => _acceptTerms = val!),
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

                      const SizedBox(height: 30),

                      if (state.isLoading)
                        const CircularProgressIndicator()
                      else
                        GestureDetector(
                          onTap: () {
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

                            context.read<AuthCubit>().signUpStudent(
                                  fullName: _nameController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  gender: _selectedGender!,
                                );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryBlue,
                                  AppColors.primaryGreen
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryGreen.withOpacity(0.5),
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
                          ).animate().scale(
                              duration: 500.ms, curve: Curves.elasticOut),
                        ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(
                                color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
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
            hintStyle:
                GoogleFonts.poppins(color: AppColors.textSecondary.withOpacity(0.6)),
            prefixIcon: Icon(icon, color: AppColors.primaryBlue),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: AppColors.lightBlue.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2);
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