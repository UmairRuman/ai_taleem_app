// lib/features/auth/presentation/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int? _hoveredIndex;
  int? _selectedIndex;

  final List<RoleOption> _roles = [
    RoleOption(
      title: 'I am a Student',
      titleUrdu: 'میں طالب علم ہوں',
      description: 'Access personalized lessons and track your progress',
      descriptionUrdu: 'ذاتی سبق تک رسائی اور اپنی ترقی کو ٹریک کریں',
      icon: Icons.school_rounded,
      role: 'student',
      color: AppColors.grade6,
      gradient: LinearGradient(
        colors: [AppColors.grade6, AppColors.grade6.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    RoleOption(
      title: 'I am a Teacher',
      titleUrdu: 'میں استاد ہوں',
      description: 'Manage classes and monitor student performance',
      descriptionUrdu: 'کلاسز کا نظم کریں اور طلباء کی کارکردگی دیکھیں',
      icon: Icons.person_rounded,
      role: 'teacher',
      color: AppColors.grade7,
      gradient: LinearGradient(
        colors: [AppColors.grade7, AppColors.grade7.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    RoleOption(
      title: 'I am a Parent',
      titleUrdu: 'میں والدین ہوں',
      description: 'Monitor your child\'s learning journey and achievements',
      descriptionUrdu: 'اپنے بچے کے سیکھنے کے سفر اور کامیابیوں کو دیکھیں',
      icon: Icons.family_restroom_rounded,
      role: 'parent',
      color: AppColors.grade8,
      gradient: LinearGradient(
        colors: [AppColors.grade8, AppColors.grade8.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _navigateToLogin(String role, int index) {
    setState(() {
      _selectedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.push('${RouteNames.login}?role=$role');
      }
    });
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
              AppColors.primaryLight.withOpacity(0.08),
              AppColors.background,
              AppColors.accent.withOpacity(0.05),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: AppDimensions.spaceXL),

                              // Header Section
                              _buildHeader(),

                              SizedBox(height: AppDimensions.spaceXL),

                              // Role Cards
                              SlideTransition(
                                position: _slideAnimation,
                                child: Column(
                                  children: List.generate(
                                    _roles.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: AppDimensions.spaceL,
                                      ),
                                      child: _buildRoleCard(
                                        _roles[index],
                                        index,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: AppDimensions.spaceL),

                              // Footer info
                              _buildFooterInfo(),

                              SizedBox(height: AppDimensions.spaceXL),
                            ],
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
          top: -80,
          right: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
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
              Icons.psychology_rounded,
              size: 50.w,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon with neumorphic effect
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.7),
                offset: const Offset(-6, -6),
                blurRadius: 12,
              ),
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(0.5),
                offset: const Offset(6, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.people_alt_rounded,
                size: 40.w,
                color: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(height: AppDimensions.spaceL),

        // Title
        Text('Select Your Role', style: AppTextStyles.display2()),

        SizedBox(height: AppDimensions.spaceS),

        // Urdu Title
        Text(
          'اپنا کردار منتخب کریں',
          style: AppTextStyles.h3(color: AppColors.textSecondary, isUrdu: true),
        ),

        SizedBox(height: AppDimensions.spaceM),

        // Subtitle
        Text(
          'Choose how you want to experience personalized learning',
          style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRoleCard(RoleOption role, int index) {
    final isHovered = _hoveredIndex == index;
    final isSelected = _selectedIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () => _navigateToLogin(role.role, index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform:
              Matrix4.identity()
                ..scale(isHovered ? 1.02 : 1.0)
                ..translate(0.0, isHovered ? -4.0 : 0.0),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(
                color:
                    isSelected
                        ? role.color
                        : isHovered
                        ? role.color.withOpacity(0.3)
                        : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isHovered
                          ? role.color.withOpacity(0.2)
                          : Colors.black.withOpacity(0.05),
                  offset: Offset(0, isHovered ? 8 : 4),
                  blurRadius: isHovered ? 20 : 12,
                  spreadRadius: 0,
                ),
                if (isHovered)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                  ),
              ],
            ),
            child: Row(
              children: [
                // Icon container with gradient
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    gradient: role.gradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: role.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(role.icon, color: Colors.white, size: 32.w),
                ),

                SizedBox(width: AppDimensions.spaceM),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(role.title, style: AppTextStyles.h4()),
                      SizedBox(height: 4.h),
                      Text(
                        role.titleUrdu,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textSecondary,
                          isUrdu: true,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spaceS),
                      Text(
                        role.description,
                        style: AppTextStyles.bodySmall(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isHovered ? 0.0 : -0.25,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: role.color,
                    size: 24.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: AppDimensions.spaceS),
            Flexible(
              child: Text(
                'Select your role to get started with personalized experience',
                style: AppTextStyles.caption(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleOption {
  final String title;
  final String titleUrdu;
  final String description;
  final String descriptionUrdu;
  final IconData icon;
  final String role;
  final Color color;
  final LinearGradient gradient;

  RoleOption({
    required this.title,
    required this.titleUrdu,
    required this.description,
    required this.descriptionUrdu,
    required this.icon,
    required this.role,
    required this.color,
    required this.gradient,
  });
}
