// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taleem_ai/shared/widgets/custom_text_field.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _institutionController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _roleTitle {
    return widget.role[0].toUpperCase() + widget.role.substring(1);
  }

  String get _roleUrdu {
    switch (widget.role) {
      case 'student':
        return 'طالب علم';
      case 'teacher':
        return 'استاد';
      case 'parent':
        return 'والدین';
      default:
        return '';
    }
  }

  Color get _roleColor {
    switch (widget.role) {
      case 'student':
        return AppColors.grade6;
      case 'teacher':
        return AppColors.grade7;
      case 'parent':
        return AppColors.grade8;
      default:
        return AppColors.primary;
    }
  }

  IconData get _roleIcon {
    switch (widget.role) {
      case 'student':
        return Icons.school_rounded;
      case 'teacher':
        return Icons.person_rounded;
      case 'parent':
        return Icons.family_restroom_rounded;
      default:
        return Icons.person;
    }
  }

  Future<void> _handleLogin() async {
    // if (!_formKey.currentState!.validate()) return;

    // setState(() => _isLoading = true);

    // // Simulate API call
    // await Future.delayed(const Duration(seconds: 2));

    // if (!mounted) return;

    // setState(() => _isLoading = false);

    if (widget.role == 'teacher') {
      context.push(RouteNames.studentDashboard);
    } else if (widget.role == 'parent') {
      context.push(RouteNames.studentDashboard);
    } else {
      context.push(RouteNames.courseContentListScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role == 'student';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              _roleColor.withOpacity(0.05),
              AppColors.background,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorations
            _buildBackgroundDecorations(),

            // Main content
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTabletOrDesktop = constraints.maxWidth > 600;
                  final maxContentWidth =
                      isTabletOrDesktop ? 500.0 : constraints.maxWidth;

                  return Center(
                    child: SingleChildScrollView(
                      child: Container(
                        width: maxContentWidth,
                        padding: EdgeInsets.all(AppDimensions.paddingL),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: AppDimensions.spaceL),

                                  // Back button
                                  _buildBackButton(),

                                  SizedBox(height: AppDimensions.spaceXL),

                                  // Header
                                  _buildHeader(),

                                  SizedBox(height: AppDimensions.spaceXL * 1.5),

                                  // Login form card
                                  _buildLoginCard(isStudent),

                                  SizedBox(height: AppDimensions.spaceL),

                                  // Register link
                                  _buildRegisterLink(),

                                  SizedBox(height: AppDimensions.spaceXL),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _roleColor.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: -40,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _roleColor.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: 30,
          child: Opacity(
            opacity: 0.1,
            child: Icon(_roleIcon, size: 60.w, color: _roleColor),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
              size: 24.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role icon
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_roleColor, _roleColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: _roleColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(_roleIcon, size: 36.w, color: Colors.white),
        ),

        SizedBox(height: AppDimensions.spaceL),

        // Title
        Text('Login as $_roleTitle', style: AppTextStyles.display2()),

        SizedBox(height: AppDimensions.spaceS),

        // Urdu Title
        Text(
          '$_roleUrdu کے طور پر لاگ ان کریں',
          style: AppTextStyles.h4(color: AppColors.textSecondary, isUrdu: true),
        ),

        SizedBox(height: AppDimensions.spaceM),

        // Subtitle
        Text(
          'Enter your credentials to access your account',
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginCard(bool isStudent) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Institution Key Field
          CustomTextField(
            label: isStudent ? "Registration PIN" : "Institution Key",
            hint:
                isStudent
                    ? "Enter your registration PIN"
                    : "Enter institution key",
            prefixIcon: Icon(Icons.apartment_rounded, color: _roleColor),
            controller: _institutionController,
            validator: (v) => v!.isEmpty ? "This field is required" : null,
          ),

          if (!isStudent) ...[
            SizedBox(height: AppDimensions.spaceL),
            // Email Field
            CustomTextField(
              label: "Email Address",
              hint: "Enter your email",
              prefixIcon: Icon(Icons.email_rounded, color: _roleColor),
              controller: _emailController,
              validator: (v) {
                if (v!.isEmpty) return "Email is required";
                if (!v.contains('@')) return "Enter a valid email";
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
          ],

          SizedBox(height: AppDimensions.spaceL),

          // Password Field
          CustomTextField(
            label: "Password",
            hint: "Enter your password",
            prefixIcon: Icon(Icons.lock_rounded, color: _roleColor),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            controller: _passwordController,
            validator: (v) {
              if (v!.isEmpty) return "Password is required";
              if (v.length < 6) return "Password must be at least 6 characters";
              return null;
            },
            obscureText: _obscurePassword,
          ),

          SizedBox(height: AppDimensions.spaceM),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push(RouteNames.forgotPassword),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: AppDimensions.paddingXS,
                ),
              ),
              child: Text(
                'Forgot Password?',
                style: AppTextStyles.bodyMedium(color: _roleColor),
              ),
            ),
          ),

          SizedBox(height: AppDimensions.spaceL),

          // Login Button
          _isLoading
              ? Center(child: CircularProgressIndicator(color: _roleColor))
              : CustomButton(
                text: 'Login',
                onPressed: _handleLogin,
                icon: Icons.arrow_forward_rounded,
                backgroundColor: _roleColor,
              ),

          SizedBox(height: AppDimensions.spaceM),

          // Divider with text
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.border, thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Text(
                  'OR',
                  style: AppTextStyles.caption(color: AppColors.textSecondary),
                ),
              ),
              Expanded(child: Divider(color: AppColors.border, thickness: 1)),
            ],
          ),

          SizedBox(height: AppDimensions.spaceM),

          // Biometric login option (placeholder)
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement biometric login
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Biometric login coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(
              Icons.fingerprint_rounded,
              color: _roleColor,
              size: 24.w,
            ),
            label: Text(
              'Login with Biometric',
              style: AppTextStyles.button(color: _roleColor),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
              side: BorderSide(color: _roleColor.withOpacity(0.3), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Don't have an account?",
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
            SizedBox(width: AppDimensions.spaceS),
            GestureDetector(
              onTap:
                  () => context.push(
                    '${RouteNames.register}?role=${widget.role}',
                  ),
              child: Text(
                'Register',
                style: AppTextStyles.bodyMedium(color: _roleColor).copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
