// lib/features/learning/presentation/screens/urdu_translation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class UrduTranslationScreen extends StatefulWidget {
  final String conceptTitle;
  final Color gradeColor;

  const UrduTranslationScreen({
    super.key,
    required this.conceptTitle,
    required this.gradeColor,
  });

  @override
  State<UrduTranslationScreen> createState() => _UrduTranslationScreenState();
}

class _UrduTranslationScreenState extends State<UrduTranslationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample bilingual content
  final List<Map<String, String>> _bilingualContent = [
    {
      'english':
          'A set is a collection of objects that has three key properties: Well-Defined, Distinct, and Unordered.',
      'urdu':
          'سیٹ (Set) اشیاء کا ایک مجموعہ ہے جس کی تین اہم خصوصیات ہیں: واضح طور پر بیان شدہ (Well-Defined)، منفرد (Distinct)، اور غیر ترتیب شدہ (Unordered)۔',
    },
    {
      'english':
          'Well-Defined means the rule for membership is perfectly clear, with no opinions.',
      'urdu':
          'واضح طور پر بیان شدہ (Well-Defined) کا مطلب ہے کہ رکنیت کا اصول بالکل واضح ہے، جس میں کسی قسم کی کوئی رائے شامل نہیں۔',
    },
    {
      'english':
          'A set can be described in Tabular, Descriptive, or Set-Builder form.',
      'urdu':
          'سیٹ کو اندراجی طریقہ (Tabular Form)، بیانیہ طریقہ (Descriptive Form)، یا سیٹ ساز طریقہ (Set-Builder Form) میں بیان کیا جا سکتا ہے۔',
    },
    {
      'english': 'The symbol ∈ means \'is an element of\'.',
      'urdu': 'علامت ∈ کا مطلب ہے \'کا رکن ہے\'۔',
    },
    {
      'english':
          'The number of distinct elements in a set is called its cardinal number, n(A).',
      'urdu':
          'کسی سیٹ میں منفرد ارکان کی تعداد کو اس کی عددی قوت (Cardinality) کہا جاتا ہے، جسے n(A) سے ظاہر کیا جاتا ہے۔',
    },
    {
      'english':
          'Equal sets have the exact same elements, while equivalent sets have the same number of elements.',
      'urdu':
          'مساوی سیٹ (Equal Sets) میں بالکل وہی ارکان ہوتے ہیں، جبکہ مساوی سیٹ (Equivalent Sets) میں ارکان کی تعداد برابر ہوتی ہے۔',
    },
    {
      'english':
          'A set \'A\' is a subset of set \'B\' if every element of A is also found in B.',
      'urdu':
          'ایک سیٹ \'A\' دوسرے سیٹ \'B\' کا ذیلی سیٹ (Subset) کہلاتا ہے اگر A کا ہر رکن B میں بھی موجود ہو۔',
    },
    {
      'english': 'A proper subset is truly smaller than the superset.',
      'urdu':
          'ایک واجب ذیلی سیٹ (Proper Subset) ہمیشہ اپنے بالائی سیٹ سے چھوٹا ہوتا ہے۔',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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
              AppColors.success.withOpacity(0.05),
              AppColors.background,
              widget.gradeColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(AppDimensions.paddingL),
                      child: Column(
                        children: [
                          // Feature Banner
                          _buildFeatureBanner(),

                          SizedBox(height: AppDimensions.spaceXL),

                          // Language Toggle Info
                          _buildLanguageToggle(),

                          SizedBox(height: AppDimensions.spaceXL),

                          // Bilingual Content
                          _buildBilingualContent(),

                          SizedBox(height: AppDimensions.spaceXL),

                          // Coming Soon Section
                          _buildComingSoonSection(),

                          SizedBox(height: AppDimensions.spaceXXL),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success, AppColors.success.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                child: InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingS),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.translate_rounded,
                          color: Colors.white,
                          size: 28.w,
                        ),
                        SizedBox(width: AppDimensions.spaceS),
                        Flexible(
                          child: Text(
                            'Urdu Translation',
                            style: AppTextStyles.h4(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      'English to Urdu • اردو ترجمہ',
                      style: AppTextStyles.caption(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBanner() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.gradeColor.withOpacity(0.1),
            AppColors.success.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              color: AppColors.success,
              size: 32.w,
            ),
          ),
          SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview Feature',
                  style: AppTextStyles.h5(color: AppColors.success),
                ),
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'This is a demonstration of our upcoming multilingual support',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLanguageChip('English', Icons.language_rounded, true),
          SizedBox(width: AppDimensions.spaceM),
          Icon(
            Icons.compare_arrows_rounded,
            color: AppColors.success,
            size: 24.w,
          ),
          SizedBox(width: AppDimensions.spaceM),
          _buildLanguageChip('اردو', Icons.translate_rounded, false),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(String label, IconData icon, bool isEnglish) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isEnglish
                ? widget.gradeColor.withOpacity(0.2)
                : AppColors.success.withOpacity(0.2),
            isEnglish
                ? widget.gradeColor.withOpacity(0.1)
                : AppColors.success.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color:
              isEnglish
                  ? widget.gradeColor.withOpacity(0.4)
                  : AppColors.success.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18.w,
            color: isEnglish ? widget.gradeColor : AppColors.success,
          ),
          SizedBox(width: AppDimensions.spaceXS),
          Text(
            label,
            style: AppTextStyles.label(
              color: isEnglish ? widget.gradeColor : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBilingualContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.spaceL),
          child: Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: widget.gradeColor,
                size: 24.w,
              ),
              SizedBox(width: AppDimensions.spaceS),
              Text('Content Preview', style: AppTextStyles.h4()),
            ],
          ),
        ),
        ...List.generate(_bilingualContent.length, (index) {
          return _buildBilingualCard(
            index + 1,
            _bilingualContent[index]['english']!,
            _bilingualContent[index]['urdu']!,
            index,
          );
        }),
      ],
    );
  }

  Widget _buildBilingualCard(
    int number,
    String englishText,
    String urduText,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number Badge
            Container(
              margin: EdgeInsets.all(AppDimensions.paddingL),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.gradeColor,
                    widget.gradeColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Text(
                '$number',
                style: AppTextStyles.caption(
                  color: Colors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            // English Text
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              decoration: BoxDecoration(
                color: widget.gradeColor.withOpacity(0.05),
                border: Border(
                  top: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingXS),
                    decoration: BoxDecoration(
                      color: widget.gradeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusS,
                      ),
                    ),
                    child: Icon(
                      Icons.language_rounded,
                      size: 16.w,
                      color: widget.gradeColor,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceS),
                  Expanded(
                    child: Text(englishText, style: AppTextStyles.bodyMedium()),
                  ),
                ],
              ),
            ),

            // Urdu Text
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimensions.paddingXS),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusS,
                      ),
                    ),
                    child: Icon(
                      Icons.translate_rounded,
                      size: 16.w,
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceS),
                  Expanded(
                    child: Text(
                      urduText,
                      style: AppTextStyles.bodyMedium().copyWith(
                        height: 1.8,
                        fontFamily: 'Noto Nastaliq Urdu',
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonSection() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            widget.gradeColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(color: AppColors.success.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.construction_rounded,
              size: 48.w,
              color: AppColors.success,
            ),
          ),
          SizedBox(height: AppDimensions.spaceL),
          Text(
            'Coming Soon',
            style: AppTextStyles.h3(color: AppColors.success),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            'Full Urdu translation feature will be available in the next version',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spaceL),
          Wrap(
            spacing: AppDimensions.spaceM,
            runSpacing: AppDimensions.spaceS,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureChip(
                'Complete Translation',
                Icons.check_circle_rounded,
              ),
              _buildFeatureChip('Audio Support', Icons.volume_up_rounded),
              _buildFeatureChip('Offline Mode', Icons.cloud_off_rounded),
              _buildFeatureChip('Real-time Switch', Icons.sync_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: AppColors.success),
          SizedBox(width: AppDimensions.spaceXS),
          Text(
            label,
            style: AppTextStyles.caption(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
