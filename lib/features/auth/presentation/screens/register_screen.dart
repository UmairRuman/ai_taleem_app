// lib/features/auth/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String role; // 'student' | 'teacher' | 'parent'

  const RegisterScreen({super.key, required this.role});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Common controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Student-specific
  final TextEditingController _institutionCodeController =
      TextEditingController();
  int? _selectedGrade;

  // Teacher/Parent-specific
  final TextEditingController _institutionNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _institutionCodeController.dispose();
    _institutionNameController.dispose();
    _emailController.dispose();
    super.dispose();
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

  String _getRoleTitle() {
    switch (widget.role) {
      case 'teacher':
        return 'Teacher Registration';
      case 'parent':
        return 'Parent Registration';
      default:
        return 'Student Registration';
    }
  }

  String _getRoleTitleUrdu() {
    switch (widget.role) {
      case 'teacher':
        return 'استاد کی رجسٹریشن';
      case 'parent':
        return 'والدین کی رجسٹریشن';
      default:
        return 'طالب علم کی رجسٹریشن';
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateInstitutionCode(String? value) {
    if (widget.role == 'student') {
      if (value == null || value.isEmpty) {
        return 'Institution code is required';
      }
      if (value.length != 6) {
        return 'Code must be 6 characters';
      }
    }
    return null;
  }

  String? _validateInstitutionName(String? value) {
    if (widget.role == 'teacher' || widget.role == 'parent') {
      if (value == null || value.trim().isEmpty) {
        return 'Institution name is required';
      }
    }
    return null;
  }

  String? _validateGrade() {
    if (widget.role == 'student' && _selectedGrade == null) {
      return 'Please select a grade';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final gradeError = _validateGrade();
    if (gradeError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(gradeError), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (widget.role == 'teacher') {
      context.go(RouteNames.teacherDashboard);
    } else if (widget.role == 'parent') {
      context.go('/parent/dashboard');
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTeacherOrParent =
        widget.role == 'teacher' || widget.role == 'parent';
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
                      isTabletOrDesktop ? 600.0 : constraints.maxWidth;

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

                                  // Registration form card
                                  _buildRegistrationCard(
                                    isStudent,
                                    isTeacherOrParent,
                                  ),

                                  SizedBox(height: AppDimensions.spaceL),

                                  // Login link
                                  _buildLoginLink(),

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
          top: 200,
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
        Text(_getRoleTitle(), style: AppTextStyles.display2()),

        SizedBox(height: AppDimensions.spaceS),

        // Urdu Title
        Text(
          _getRoleTitleUrdu(),
          style: AppTextStyles.h4(color: AppColors.textSecondary, isUrdu: true),
        ),

        SizedBox(height: AppDimensions.spaceM),

        // Subtitle
        Text(
          'Create your account to get started',
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRegistrationCard(bool isStudent, bool isTeacherOrParent) {
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
          // Student-specific fields
          if (isStudent) ...[
            CustomTextField(
              label: 'Institution Code',
              hint: 'Enter 6-digit code from teacher/parent',
              controller: _institutionCodeController,
              validator: _validateInstitutionCode,
              prefixIcon: Icon(Icons.school_outlined, color: _roleColor),
            ),
            SizedBox(height: AppDimensions.spaceL),
            Text(
              'Select Grade',
              style: AppTextStyles.label(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppDimensions.spaceM),
            _buildGradeSelector(),
            SizedBox(height: AppDimensions.spaceL),
          ],

          // Teacher/Parent-specific fields
          if (isTeacherOrParent) ...[
            CustomTextField(
              label: 'Institution Name',
              hint: 'Enter your institution name',
              controller: _institutionNameController,
              validator: _validateInstitutionName,
              prefixIcon: Icon(Icons.apartment_outlined, color: _roleColor),
            ),
            SizedBox(height: AppDimensions.spaceL),
            CustomTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
              prefixIcon: Icon(Icons.email_outlined, color: _roleColor),
            ),
            SizedBox(height: AppDimensions.spaceL),
          ],

          // Full name (all roles)
          CustomTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _nameController,
            validator: Validators.validateName,
            prefixIcon: Icon(Icons.person_outline_rounded, color: _roleColor),
          ),
          SizedBox(height: AppDimensions.spaceL),

          // Password
          CustomTextField(
            label: 'Password',
            hint: 'Create a password (min 8 characters)',
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: Validators.validatePassword,
            prefixIcon: Icon(Icons.lock_outline_rounded, color: _roleColor),
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
          ),
          SizedBox(height: AppDimensions.spaceL),

          // Confirm Password
          CustomTextField(
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            validator: _validateConfirmPassword,
            prefixIcon: Icon(Icons.lock_outline_rounded, color: _roleColor),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
            ),
          ),

          // Teacher info box
          if (widget.role == 'teacher') ...[
            SizedBox(height: AppDimensions.spaceL),
            _buildInfoBox(),
          ],

          SizedBox(height: AppDimensions.spaceXL),

          // Register button
          _isLoading
              ? Center(child: CircularProgressIndicator(color: _roleColor))
              : CustomButton(
                text: 'Create Account',
                onPressed: _handleRegister,
                icon: Icons.arrow_forward_rounded,
                backgroundColor: _roleColor,
              ),
        ],
      ),
    );
  }

  Widget _buildGradeSelector() {
    return Row(
      children: [
        Expanded(
          child: _GradeChip(
            grade: 6,
            isSelected: _selectedGrade == 6,
            onTap: () => setState(() => _selectedGrade = 6),
          ),
        ),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: _GradeChip(
            grade: 7,
            isSelected: _selectedGrade == 7,
            onTap: () => setState(() => _selectedGrade = 7),
          ),
        ),
        SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: _GradeChip(
            grade: 8,
            isSelected: _selectedGrade == 8,
            onTap: () => setState(() => _selectedGrade = 8),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: _roleColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: _roleColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: _roleColor, size: 20.w),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(
              'After registration, you can create your institution and generate a 6-digit code for students and parents.',
              style: AppTextStyles.bodySmall(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
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
              'Already have an account?',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
            SizedBox(width: AppDimensions.spaceS),
            GestureDetector(
              onTap:
                  () => context.go('${RouteNames.login}?role=${widget.role}'),
              child: Text(
                'Login',
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

class _GradeChip extends StatelessWidget {
  final int grade;
  final bool isSelected;
  final VoidCallback onTap;

  const _GradeChip({
    required this.grade,
    required this.isSelected,
    required this.onTap,
  });

  Color _getGradeColor() {
    switch (grade) {
      case 6:
        return AppColors.grade6;
      case 7:
        return AppColors.grade7;
      case 8:
        return AppColors.grade8;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getGradeColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: color, width: 2),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Center(
          child: Text(
            'Grade $grade',
            style: AppTextStyles.button(
              color: isSelected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}
