// // Path: lib/features/admin/fake_data_entry/institution_data_entry_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:taleem_ai/core/di/injection_container.dart';
// import 'package:taleem_ai/core/domain/entities/institution.dart';

// class InstitutionDataEntryScreen extends ConsumerStatefulWidget {
//   const InstitutionDataEntryScreen({super.key});

//   @override
//   ConsumerState<InstitutionDataEntryScreen> createState() =>
//       _InstitutionDataEntryScreenState();
// }

// class _InstitutionDataEntryScreenState
//     extends ConsumerState<InstitutionDataEntryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _institutionIdController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _codeController = TextEditingController();

//   Future<void> _pushInstitutionData() async {
//     if (_formKey.currentState!.validate()) {
//       final institution = Institution(
//         type: "private",
//         city: "Bahawalpur",
//         ownerId: "admin1",
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         id: _institutionIdController.text,
//         name: _nameController.text,
//         code: _codeController.text,
//         studentIds: [], // Empty for fake data, add later if needed
//       );
//       final repo = ref.read(institutionsRepositoryProvider);
//       final success = await repo.addInstitution(institution);
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Institution added successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to add institution')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Fake Institution Data Entry')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _institutionIdController,
//                 decoration: const InputDecoration(labelText: 'Institution ID'),
//                 validator:
//                     (value) => value!.isEmpty ? 'Enter Institution ID' : null,
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Institution Name',
//                 ),
//                 validator:
//                     (value) => value!.isEmpty ? 'Enter Institution Name' : null,
//               ),
//               TextFormField(
//                 controller: _codeController,
//                 decoration: const InputDecoration(
//                   labelText: 'Institution Code',
//                 ),
//                 validator:
//                     (value) => value!.isEmpty ? 'Enter Institution Code' : null,
//               ),
//               ElevatedButton(
//                 onPressed: _pushInstitutionData,
//                 child: const Text('Add Fake Institution'),
//               ),
//             ],
//           ),
//         ),a
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _institutionIdController.dispose();
//     _nameController.dispose();
//     _codeController.dispose();
//     super.dispose();
//   }
// }
