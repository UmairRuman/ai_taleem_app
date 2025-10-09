// // Path: lib/features/admin/fake_data_entry/user_data_entry_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:taleem_ai/core/di/injection_container.dart';
// import 'package:taleem_ai/core/domain/entities/lesson_progress.dart';
// import 'package:taleem_ai/core/domain/entities/quiz_attempt.dart';
// import 'package:taleem_ai/core/domain/entities/user.dart';

// class UserDataEntryScreen extends ConsumerStatefulWidget {
//   const UserDataEntryScreen({super.key});

//   @override
//   ConsumerState<UserDataEntryScreen> createState() =>
//       _UserDataEntryScreenState();
// }

// class _UserDataEntryScreenState extends ConsumerState<UserDataEntryScreen> {
//   final _userFormKey = GlobalKey<FormState>();
//   final _lessonProgressFormKey = GlobalKey<FormState>();
//   final _quizAttemptFormKey = GlobalKey<FormState>();
//   // User info
//   final _userIdController = TextEditingController();
//   final _userNameController = TextEditingController();
//   final _userRoleController = TextEditingController();

//   final _lessonIdController = TextEditingController();
//   final _progressPercentageController = TextEditingController();
//   final _quizIdController = TextEditingController();
//   final _scoreController = TextEditingController();

//   Future<void> _pushUserData() async {
//     if (_userFormKey.currentState!.validate()) {
//       final user = User(
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         lastLoginAt: DateTime.now(),
//         grade: 8,
//         institutionCode: "XYZ123",
//         institutionId: "",
//         ownedInstitutionId: "",
//         profilePicture: "",
//         language: "en",
//         id: _userIdController.text,
//         name: _userNameController.text,
//         email: 'ahmedIsmail@gmail.com', // Optional, add if needed
//         role: _userRoleController.text, // Default for fake data
//       );
//       final repo = ref.read(userRepositoryProvider);
//       final success = await repo.addUser(user);
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User added successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Failed to add user')));
//       }
//     }
//   }

//   Future<void> _pushLessonProgress(String userId) async {
//     if (_lessonProgressFormKey.currentState!.validate()) {
//       final progress = LessonProgress(
//         conceptId: "",
//         lastAccessedAt: DateTime.now(),
//         status: "",
//         completedAt: DateTime.now(),
//         startedAt: DateTime.now(),
//         timeSpentSeconds: 2,
//         lessonId: _lessonIdController.text,
//       );
//       final repo = ref.read(progressRepositoryProvider);
//       final success = await repo.addLessonProgress(userId, progress);
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Lesson progress added successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to add lesson progress')),
//         );
//       }
//     }
//   }

//   Future<void> _pushQuizAttempt(String userId) async {
//     if (_quizAttemptFormKey.currentState!.validate()) {
//       final attempt = QuizAttempt(
//         answers: {},
//         conceptId: "",
//         passed: false,
//         percentage: 23,
//         startedAt: DateTime.now(),
//         timeSpentSeconds: 200,
//         id: '${userId}_${_quizIdController.text}',
//         userId: userId,
//         quizId: _quizIdController.text,
//         score: int.parse(_scoreController.text),
//         completedAt: DateTime.now(),
//       );
//       final repo = ref.read(quizAttemptsRepositoryProvider);
//       final success = await repo.addQuizAttempt(attempt);
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Quiz attempt added successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to add quiz attempt')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Fake User Data Entry')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Form(
//               key: _userFormKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _userIdController,
//                     decoration: const InputDecoration(labelText: 'User ID'),
//                     validator:
//                         (value) => value!.isEmpty ? 'Enter User ID' : null,
//                   ),
//                   TextFormField(
//                     controller: _userRoleController,
//                     decoration: const InputDecoration(labelText: 'User Role'),
//                     validator:
//                         (value) =>
//                             value!.isEmpty
//                                 ? 'Enter User Role(Teacher or Student)'
//                                 : null,
//                   ),
//                   TextFormField(
//                     controller: _userNameController,
//                     decoration: const InputDecoration(labelText: 'User Name'),
//                     validator:
//                         (value) => value!.isEmpty ? 'Enter User Name' : null,
//                   ),
//                   ElevatedButton(
//                     onPressed: _pushUserData,
//                     child: const Text('Add Fake User'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _lessonProgressFormKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _lessonIdController,
//                     decoration: const InputDecoration(labelText: 'Lesson ID'),
//                     validator:
//                         (value) => value!.isEmpty ? 'Enter Lesson ID' : null,
//                   ),
//                   TextFormField(
//                     controller: _progressPercentageController,
//                     decoration: const InputDecoration(
//                       labelText: 'Progress % (0-100)',
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value!.isEmpty) return 'Enter Progress %';
//                       final percent = double.tryParse(value);
//                       return percent == null || percent < 0 || percent > 100
//                           ? 'Enter 0-100'
//                           : null;
//                     },
//                   ),
//                   ElevatedButton(
//                     onPressed:
//                         () => _pushLessonProgress(_userIdController.text),
//                     child: const Text('Add Lesson Progress'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _quizAttemptFormKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _quizIdController,
//                     decoration: const InputDecoration(labelText: 'Quiz ID'),
//                     validator:
//                         (value) => value!.isEmpty ? 'Enter Quiz ID' : null,
//                   ),
//                   TextFormField(
//                     controller: _scoreController,
//                     decoration: const InputDecoration(
//                       labelText: 'Score (0-100)',
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value!.isEmpty) return 'Enter Score';
//                       final score = double.tryParse(value);
//                       return score == null || score < 0 || score > 100
//                           ? 'Enter 0-100'
//                           : null;
//                     },
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _pushQuizAttempt(_userIdController.text),
//                     child: const Text('Add Quiz Attempt'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _userIdController.dispose();
//     _userNameController.dispose();
//     _lessonIdController.dispose();
//     _progressPercentageController.dispose();
//     _quizIdController.dispose();
//     _scoreController.dispose();
//     super.dispose();
//   }
// }
