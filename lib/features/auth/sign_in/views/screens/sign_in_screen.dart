import 'package:bus_system/core/utilies/assets/images/app_images.dart';
import 'package:bus_system/features/auth/select_role/select_role.dart';
import 'package:bus_system/features/student/dashboard/test.dart'; // Assuming this is StudentDashboardScreen
import 'package:bus_system/features/student/dashboard/views/screens/student_dashboard_screen.dart';
import 'package:custom_quick_alert/custom_quick_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppColors {
  AppColors._();
  static const Color primaryBlue = Color(0xFF0D4C73);
  static const Color lightBlue = Color(0xFF2F8FBE);
  static const Color primaryGreen = Color(0xFF3FAF6C);
  static const Color background = Color(0xFFF5F7FA);
  static const Color white = Colors.white;
  static const Color accentBlue = Color(0xFF1C7ED6);
  static const Color accentGreen = Color(0xFF2FBF71);
  static const Color textPrimary = primaryBlue;
  static const Color textSecondary = Color(0xFF6C757D);
}

// ────────────────────────────────────────────────
//                     Auth State
// ────────────────────────────────────────────────
enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final String? role;

  AuthState({this.status = AuthStatus.initial, this.message, this.role});

  AuthState copyWith({AuthStatus? status, String? message, String? role}) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      role: role ?? this.role,
    );
  }
}

// ────────────────────────────────────────────────
//                     Auth Cubit (unchanged)
// ────────────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient supabase;

  AuthCubit(this.supabase) : super(AuthState());

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final authRes = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = authRes.user;
      if (user == null) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            message: 'Login failed. Please try again.',
          ),
        );
        return;
      }

      final profile = await supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null || profile['role'] == null) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            message: 'No role assigned to this account.',
          ),
        );
        return;
      }

      final rawRole = profile['role'] as String;
      final normalizedRole = rawRole.trim().toLowerCase();

      emit(
        state.copyWith(
          status: AuthStatus.success,
          role: normalizedRole,
          message: 'Login successful!',
        ),
      );
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.message));
    } on PostgrestException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'An unexpected error occurred.',
        ),
      );
    }
  }
}

// ────────────────────────────────────────────────
//                     Login Screen
// ────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleNavigation(String? role) {
    if (!mounted) return;

    if (role == 'student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => DashboardCubit(),
            child: const StudentDashboardScreen(),
          ),
        ),
      );
    } else if (role == 'driver') {
      // TODO: Replace with your DriverHomeScreen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Driver dashboard coming soon...')),
      );
    } else if (role == 'university') {
      // TODO: Replace with your UniversityHomeScreen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('University dashboard coming soon...')),
      );
    } else {
      CustomQuickAlert.warning(
        title: 'Unknown Role',
        message: 'Role: $role\nPlease contact support.',
        confirmBtnColor: Colors.orange,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(Supabase.instance.client),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state.status == AuthStatus.loading) {
            CustomQuickAlert.loading(
              title: 'Please wait',
              message: 'Logging you in...',
              barrierDismissible: false,
            );
          }

          if (state.status == AuthStatus.success) {
            // Close any open loading alert (if supported by the package)
            CustomQuickAlert.dismiss();

            // Show success alert
            await CustomQuickAlert.success(
              title: 'Success',
              message: 'Welcome back!',
              confirmBtnColor: AppColors.primaryGreen,
              // autoCloseDuration: const Duration(seconds: 2), // optional
              showConfirm: true, // or false if you want auto close only
            );

            // Small delay to let the alert animation finish nicely
            await Future.delayed(const Duration(milliseconds: 800));

            if (!mounted) return;

            _handleNavigation(state.role?.toLowerCase());
          }

          if (state.status == AuthStatus.error) {
            CustomQuickAlert.dismiss(); // close loading if open

            CustomQuickAlert.error(
              title: 'Error',
              message: state.message ?? 'Login failed. Please try again.',
              confirmBtnColor: Colors.redAccent,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Form(
                  key: _formKey,
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

                      // Email
                      _buildTextField(
                        controller: _emailController,
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
                      _buildTextField(
                        controller: _passwordController,
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

                      const SizedBox(height: 40),

                      // Login Button
                      if (isLoading)
                        const CircularProgressIndicator()
                      else
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                              );
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
            hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary.withOpacity(0.6)),
            prefixIcon: Icon(icon, color: AppColors.primaryBlue),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.lightBlue.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2);
  }
}