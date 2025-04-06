import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repfiles/models/app_state.dart';
import 'package:repfiles/models/reptile.dart';

class BreedingScreen extends StatelessWidget {
  const BreedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breeding Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProjectDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 0, // TODO: Replace with actual breeding projects
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return const BreedingProjectCard();
        },
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddBreedingProjectDialog(),
    );
  }
}

class BreedingProjectCard extends StatelessWidget {
  const BreedingProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Project Name',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                ),
              ],
            ),
            const Divider(),
            const Row(
              children: [
                Icon(Icons.male, size: 20),
                SizedBox(width: 8),
                Text('Male: Not selected'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.female, size: 20),
                SizedBox(width: 8),
                Text('Female: Not selected'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Implement view details
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddBreedingProjectDialog extends StatefulWidget {
  const AddBreedingProjectDialog({super.key});

  @override
  State<AddBreedingProjectDialog> createState() => _AddBreedingProjectDialogState();
}

class _AddBreedingProjectDialogState extends State<AddBreedingProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Reptile? _selectedMale;
  Reptile? _selectedFemale;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Breeding Project'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Project Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // TODO: Add reptile selection dropdowns
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement project creation
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
} 