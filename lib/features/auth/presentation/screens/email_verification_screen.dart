// lib/features/auth/presentation/screens/email_verification_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String?
  role; // Optional: to redirect to appropriate dashboard after verification

  const EmailVerificationScreen({super.key, required this.email, this.role});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;
  bool _isResending = false;
  bool _isCheckingVerification = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startResendTimer();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _handleResendEmail() async {
    if (!_canResend || _isResending) return;

    setState(() => _isResending = true);

    // TODO: Implement actual resend logic
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isResending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Text(
                'Verification email sent successfully',
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

    _startResendTimer();
  }

  Future<void> _handleCheckVerification() async {
    setState(() => _isCheckingVerification = true);

    // TODO: Implement actual verification check
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isCheckingVerification = false);

    // Simulate verification check
    // In real implementation, check if email is verified
    bool isVerified = false; // Replace with actual check

    if (isVerified) {
      _navigateAfterVerification();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_rounded, color: Colors.white),
              SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Text(
                  'Email not verified yet. Please check your inbox.',
                  style: AppTextStyles.bodyMedium(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
        ),
      );
    }
  }

  void _navigateAfterVerification() {
    // Navigate based on role
    if (widget.role == 'teacher') {
      context.go(RouteNames.teacherDashboard);
    } else if (widget.role == 'parent') {
      context.go('/parent/dashboard');
    } else {
      context.go(RouteNames.home);
    }
  }

  void _handleChangeEmail() {
    context.pop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _resendTimer?.cancel();
    super.dispose();
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

                                // Main content card
                                _buildVerificationCard(),

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
              Icons.mark_email_read_rounded,
              size: 60.w,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
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
          // Animated email icon
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.primary.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.mark_email_read_rounded,
                  size: 60.w,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          SizedBox(height: AppDimensions.spaceXL),

          // Title
          Text(
            'Verify Your Email',
            style: AppTextStyles.h2(),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spaceS),

          // Urdu Title
          Text(
            'اپنی ای میل کی تصدیق کریں',
            style: AppTextStyles.h4(
              color: AppColors.textSecondary,
              isUrdu: true,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spaceL),

          // Message
          Text(
            'We\'ve sent a verification link to',
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppDimensions.spaceS),

          // Email address
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Text(
              widget.email,
              style: AppTextStyles.bodyLarge(
                color: AppColors.primary,
              ).copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: AppDimensions.spaceXL),

          // Instructions
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.border.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 20.w,
                    ),
                    SizedBox(width: AppDimensions.spaceS),
                    Text(
                      'Next Steps:',
                      style: AppTextStyles.label(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spaceM),
                _buildInstructionStep('1', 'Check your email inbox'),
                _buildInstructionStep('2', 'Click the verification link'),
                _buildInstructionStep(
                  '3',
                  'Return here and click "I\'ve Verified"',
                ),
              ],
            ),
          ),

          SizedBox(height: AppDimensions.spaceXL),

          // Check verification button
          _isCheckingVerification
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : CustomButton(
                text: "I've Verified My Email",
                onPressed: _handleCheckVerification,
                icon: Icons.check_circle_rounded,
              ),

          SizedBox(height: AppDimensions.spaceL),

          // Resend section
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              children: [
                Text(
                  "Didn't receive the email?",
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceM),
                if (!_canResend)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16.w,
                        color: AppColors.textTertiary,
                      ),
                      SizedBox(width: AppDimensions.spaceS),
                      Text(
                        'Resend available in $_resendCountdown seconds',
                        style: AppTextStyles.bodySmall(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  )
                else
                  _isResending
                      ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                      : TextButton.icon(
                        onPressed: _handleResendEmail,
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 18.w,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Resend Verification Email',
                          style: AppTextStyles.button(color: AppColors.primary),
                        ),
                      ),
              ],
            ),
          ),

          SizedBox(height: AppDimensions.spaceL),

          // Change email option
          TextButton.icon(
            onPressed: _handleChangeEmail,
            icon: Icon(
              Icons.edit_rounded,
              size: 18.w,
              color: AppColors.textSecondary,
            ),
            label: Text(
              'Change Email Address',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ),

          SizedBox(height: AppDimensions.spaceM),

          // Help text
          Text(
            'Check your spam folder if you don\'t see the email',
            style: AppTextStyles.caption(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
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
