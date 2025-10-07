// lib/features/auth/presentation/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _emailSent = true;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Text(
                'Password reset link sent to your email',
                style: AppTextStyles.bodyMedium(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.primaryLight.withOpacity(0.05),
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

                                // Content card
                                _emailSent
                                    ? _buildSuccessCard()
                                    : _buildResetForm(),

                                SizedBox(height: AppDimensions.spaceXL),
                              ],
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
              color: AppColors.primaryLight.withOpacity(0.1),
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
              color: AppColors.accent.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: 30,
          child: Opacity(
            opacity: 0.1,
            child: Icon(
              Icons.lock_reset_rounded,
              size: 60.w,
              color: AppColors.primary,
            ),
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
        // Icon
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            size: 36.w,
            color: Colors.white,
          ),
        ),

        SizedBox(height: AppDimensions.spaceL),

        // Title
        Text('Forgot Password?', style: AppTextStyles.display2()),

        SizedBox(height: AppDimensions.spaceS),

        // Urdu Title
        Text(
          'پاس ورڈ بھول گئے؟',
          style: AppTextStyles.h4(color: AppColors.textSecondary, isUrdu: true),
        ),

        SizedBox(height: AppDimensions.spaceM),

        // Subtitle
        Text(
          _emailSent
              ? 'Check your email for reset instructions'
              : 'Enter your email address and we\'ll send you a link to reset your password',
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildResetForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field
            CustomTextField(
              label: 'Email Address',
              hint: 'Enter your registered email',
              controller: _emailController,
              validator: Validators.validateEmail,
              prefixIcon: Icon(Icons.email_rounded, color: AppColors.primary),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: AppDimensions.spaceL),

            // Info box
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.info,
                    size: 20.w,
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Text(
                      'You will receive a password reset link if this email is registered with us.',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppDimensions.spaceXL),

            // Reset button
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
                : CustomButton(
                  text: 'Send Reset Link',
                  onPressed: _handleResetPassword,
                  icon: Icons.send_rounded,
                ),

            SizedBox(height: AppDimensions.spaceL),

            // Back to login link
            Center(
              child: TextButton.icon(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 18.w,
                  color: AppColors.primary,
                ),
                label: Text(
                  'Back to Login',
                  style: AppTextStyles.bodyMedium(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
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
        children: [
          // Success icon
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_rounded,
              size: 50.w,
              color: AppColors.success,
            ),
          ),

          SizedBox(height: AppDimensions.spaceXL),

          // Success title
          Text(
            'Email Sent Successfully!',
            style: AppTextStyles.h3(),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spaceM),

          // Success message
          Text(
            'We\'ve sent a password reset link to',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spaceS),

          Text(
            _emailController.text,
            style: AppTextStyles.bodyLarge(
              color: AppColors.primary,
            ).copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spaceXL),

          // Instructions
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Steps:',
                  style: AppTextStyles.label(color: AppColors.textPrimary),
                ),
                SizedBox(height: AppDimensions.spaceS),
                _buildInstructionStep('1', 'Check your email inbox'),
                _buildInstructionStep('2', 'Click the reset link'),
                _buildInstructionStep('3', 'Create your new password'),
              ],
            ),
          ),

          SizedBox(height: AppDimensions.spaceXL),

          // Resend button
          OutlinedButton.icon(
            onPressed: () {
              setState(() => _emailSent = false);
            },
            icon: Icon(
              Icons.refresh_rounded,
              color: AppColors.primary,
              size: 20.w,
            ),
            label: Text(
              'Resend Email',
              style: AppTextStyles.button(color: AppColors.primary),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              side: BorderSide(
                color: AppColors.primary.withOpacity(0.3),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
          ),

          SizedBox(height: AppDimensions.spaceM),

          // Back to login
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Back to Login',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.caption(
                  color: Colors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
