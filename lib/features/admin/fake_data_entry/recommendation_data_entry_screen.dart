// Path: lib/features/admin/fake_data_entry/recommendation_data_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taleem_ai/core/di/injection_container.dart';
import 'package:taleem_ai/core/domain/entities/recommendation_item.dart';

class RecommendationDataEntryScreen extends ConsumerStatefulWidget {
  const RecommendationDataEntryScreen({super.key});

  @override
  ConsumerState<RecommendationDataEntryScreen> createState() =>
      _RecommendationDataEntryScreenState();
}

class _RecommendationDataEntryScreenState
    extends ConsumerState<RecommendationDataEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _itemIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _priorityController = TextEditingController(text: 'high'); // Default

  Future<void> _pushRecommendationData() async {
    if (_formKey.currentState!.validate()) {
      final item = RecommendationItem(
        reason: "",
        reasonUrdu: "",
        targetConceptId: "",
        targetLessonId: "",
        type: "",
        expiresAt: DateTime.now(), // Expires in 30 days
        id: _itemIdController.text,
        priority: _priorityController.text,
        dismissed: false, // Default for fake data
        createdAt: DateTime.now(),
      );
      final repo = ref.read(recommendationsRepositoryProvider);
      final success = await repo.addRecommendationItem(
        _userIdController.text,
        item,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recommendation item added successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add recommendation item')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fake Recommendation Data Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                validator: (value) => value!.isEmpty ? 'Enter User ID' : null,
              ),
              TextFormField(
                controller: _itemIdController,
                decoration: const InputDecoration(labelText: 'Item ID'),
                validator: (value) => value!.isEmpty ? 'Enter Item ID' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter Title' : null,
              ),
              TextFormField(
                controller: _priorityController,
                decoration: const InputDecoration(
                  labelText: 'Priority (high/low)',
                ),
                validator:
                    (value) =>
                        value!.isEmpty || !['high', 'low'].contains(value)
                            ? 'Enter high or low'
                            : null,
              ),
              ElevatedButton(
                onPressed: _pushRecommendationData,
                child: const Text('Add Fake Recommendation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _itemIdController.dispose();
    _titleController.dispose();
    _priorityController.dispose();
    super.dispose();
  }
}
