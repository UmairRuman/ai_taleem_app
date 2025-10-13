// lib/features/admin/presentation/screens/admin_panel_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taleem_ai/core/routes/route_names.dart';

import '../../../../core/domain/entities/concept.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  static const routeName = RouteNames.adminPanel;
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  final TextEditingController _jsonController = TextEditingController();
  bool _isLoading = false;
  bool _isValidJson = true;
  String _statusMessage = '';
  List<Concept>? _parsedConcepts;
  int _uploadedCount = 0;
  bool _isSidebarOpen = false;

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  void _validateAndParseJson() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Upcoming Feature!")));
    // setState(() {
    //   _isValidJson = true;
    //   _statusMessage = '';
    //   _parsedConcepts = null;
    // });

    // final jsonText = _jsonController.text.trim();
    // if (jsonText.isEmpty) {
    //   setState(() {
    //     _isValidJson = false;
    //     _statusMessage = 'Please paste JSON data';
    //   });
    //   return;
    // }

    // try {
    //   final Map<String, dynamic> jsonData = json.decode(jsonText);

    //   // Validate structure
    //   if (!jsonData.containsKey('concepts')) {
    //     throw Exception('JSON must contain "concepts" array');
    //   }

    //   final List<dynamic> conceptsJson = jsonData['concepts'] as List<dynamic>;
    //   final List<Concept> concepts =
    //       conceptsJson
    //           .map((e) => Concept.fromMap(e as Map<String, dynamic>))
    //           .toList();

    //   setState(() {
    //     _parsedConcepts = concepts;
    //     _statusMessage = '✅ Valid JSON! Found ${concepts.length} concepts';
    //   });
    // } catch (e) {
    //   setState(() {
    //     _isValidJson = false;
    //     _statusMessage = '❌ Invalid JSON: ${e.toString()}';
    //   });
    // }
  }

  Future<void> _uploadToFirestore() async {
    if (_parsedConcepts == null || _parsedConcepts!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid concepts to upload')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadedCount = 0;
      _statusMessage = 'Uploading...';
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      for (var concept in _parsedConcepts!) {
        final docRef = firestore.collection('concepts').doc(concept.conceptId);
        batch.set(docRef, concept.toFirestore());
      }

      await batch.commit();

      setState(() {
        _uploadedCount = _parsedConcepts!.length;
        _statusMessage = '🎉 Successfully uploaded $_uploadedCount concepts!';
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Uploaded $_uploadedCount concepts'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ Upload failed: ${e.toString()}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Upload failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _clearAll() {
    setState(() {
      _jsonController.clear();
      _parsedConcepts = null;
      _statusMessage = '';
      _isValidJson = true;
      _uploadedCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: AppTextStyles.h4(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => setState(() => _isSidebarOpen = true),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            _buildMainContent(),

            // Sidebar Overlay (for mobile)
            if (_isSidebarOpen)
              GestureDetector(
                onTap: () => setState(() => _isSidebarOpen = false),
                child: Container(color: Colors.black54),
              ),

            // Sidebar
            if (_isSidebarOpen) _buildSidebar(),
          ],
        ),
      ),
      floatingActionButton:
          _uploadedCount > 0
              ? FloatingActionButton.extended(
                onPressed: () {},
                backgroundColor: AppColors.success,
                icon: const Icon(Icons.check_circle_rounded),
                label: Text('$_uploadedCount Uploaded'),
              )
              : null,
    );
  }

  Widget _buildSidebar() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Material(
        elevation: 8,
        child: Container(
          width: 280.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => setState(() => _isSidebarOpen = false),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 32.w,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceM),
                    Text(
                      'TaleemIE AI',
                      style: AppTextStyles.h3(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Admin Panel',
                      style: AppTextStyles.bodyMedium(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spaceL),
              Divider(color: Colors.white.withOpacity(0.2)),

              // Menu Items
              _buildMenuItem(
                icon: Icons.upload_file_rounded,
                title: 'JSON Import',
                isActive: true,
              ),
              _buildMenuItem(
                icon: Icons.school_rounded,
                title: 'Concepts',
                isActive: false,
              ),
              _buildMenuItem(
                icon: Icons.quiz_rounded,
                title: 'Quizzes',
                isActive: false,
              ),
              _buildMenuItem(
                icon: Icons.people_rounded,
                title: 'Users',
                isActive: false,
              ),
              _buildMenuItem(
                icon: Icons.analytics_rounded,
                title: 'Analytics',
                isActive: false,
              ),

              const Spacer(),

              // Stats
              if (_uploadedCount > 0)
                Container(
                  margin: EdgeInsets.all(AppDimensions.paddingM),
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 40.w,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$_uploadedCount',
                        style: AppTextStyles.h2(color: Colors.white),
                      ),
                      Text(
                        'Concepts Uploaded',
                        style: AppTextStyles.bodySmall(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isActive,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 24.w),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium(color: Colors.white),
        ),
        dense: true,
        onTap: () => setState(() => _isSidebarOpen = false),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Import Curriculum Data', style: AppTextStyles.h3()),
                    SizedBox(height: 8.h),
                    Text(
                      'Paste your Knowledge Graph JSON below',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spaceXL),

          // JSON Input Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: _isValidJson ? AppColors.border : AppColors.error,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Card Header
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusL),
                      topRight: Radius.circular(AppDimensions.radiusL),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.code_rounded,
                        color: AppColors.primary,
                        size: 24.w,
                      ),
                      SizedBox(width: AppDimensions.spaceM),
                      Text('JSON Input', style: AppTextStyles.h5()),
                      const Spacer(),
                      if (_jsonController.text.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            _jsonController.clear();
                            setState(() {
                              _parsedConcepts = null;
                              _statusMessage = '';
                            });
                          },
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          label: const Text('Clear'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Text Field
                Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: TextField(
                    controller: _jsonController,
                    maxLines: 15,
                    style: TextStyle(fontFamily: 'Courier', fontSize: 12.sp),
                    decoration: InputDecoration(
                      hintText:
                          'Paste your JSON here...\n\nExample:\n{\n  "knowledge_graph_topic": "Sets",\n  "concepts": [...]\n}',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.textDisabled,
                        fontFamily: 'Courier',
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppDimensions.spaceL),

          // Action Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Validate JSON',
                  onPressed: _validateAndParseJson,
                  icon: Icons.check_circle_outline_rounded,
                  isOutlined: true,
                ),
              ),
              SizedBox(height: AppDimensions.spaceM),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Upload to Firestore',
                  onPressed:
                      _parsedConcepts != null ? _uploadToFirestore : null,
                  icon: Icons.cloud_upload_rounded,
                  isLoading: _isLoading,
                  backgroundColor: AppColors.success,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spaceL),

          // Status Message
          if (_statusMessage.isNotEmpty)
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color:
                    _isValidJson
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: _isValidJson ? AppColors.success : AppColors.error,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isValidJson
                        ? Icons.check_circle_rounded
                        : Icons.error_rounded,
                    color: _isValidJson ? AppColors.success : AppColors.error,
                    size: 24.w,
                  ),
                  SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Text(
                      _statusMessage,
                      style: AppTextStyles.bodyMedium(
                        color:
                            _isValidJson
                                ? AppColors.successDark
                                : AppColors.errorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Preview Parsed Concepts
          if (_parsedConcepts != null && _parsedConcepts!.isNotEmpty) ...[
            SizedBox(height: AppDimensions.spaceXL),
            Text(
              'Preview (${_parsedConcepts!.length} concepts)',
              style: AppTextStyles.h4(),
            ),
            SizedBox(height: AppDimensions.spaceM),
            ..._parsedConcepts!.map((concept) => _buildConceptCard(concept)),
          ],
        ],
      ),
    );
  }

  Widget _buildConceptCard(Concept concept) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getGradeColor(concept.gradeLevel).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Grade ${concept.gradeLevel}',
                  style: AppTextStyles.bodySmall(
                    color: _getGradeColor(concept.gradeLevel),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(
                    concept.difficulty,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  concept.difficulty.toUpperCase(),
                  style: AppTextStyles.bodySmall(
                    color: _getDifficultyColor(concept.difficulty),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(concept.title, style: AppTextStyles.h5()),
          SizedBox(height: 4.h),
          Text(
            'ID: ${concept.conceptId}',
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
          ),
          if (concept.prerequisites.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children:
                  concept.prerequisites
                      .map(
                        (p) => Chip(
                          label: Text(p, style: TextStyle(fontSize: 10.sp)),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Color _getGradeColor(int grade) {
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.easy;
      case 'medium':
        return AppColors.medium;
      case 'hard':
        return AppColors.hard;
      default:
        return AppColors.medium;
    }
  }
}
