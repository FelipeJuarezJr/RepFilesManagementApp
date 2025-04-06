import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repfiles/models/app_state.dart';
import 'package:repfiles/models/reptile.dart';

class AnimalsScreen extends StatelessWidget {
  const AnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reptiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddReptileDialog(context),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (appState.error != null) {
            return Center(child: Text('Error: ${appState.error}'));
          }

          if (appState.reptiles.isEmpty) {
            return const Center(
              child: Text('No reptiles added yet. Tap + to add one!'),
            );
          }

          return ListView.builder(
            itemCount: appState.reptiles.length,
            itemBuilder: (context, index) {
              final reptile = appState.reptiles[index];
              return ReptileListItem(reptile: reptile);
            },
          );
        },
      ),
    );
  }

  void _showAddReptileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddReptileDialog(),
    );
  }
}

class ReptileListItem extends StatelessWidget {
  final Reptile reptile;

  const ReptileListItem({
    super.key,
    required this.reptile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            reptile.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(reptile.name),
        subtitle: Text('${reptile.species} • ${_calculateAge(reptile.dateOfBirth)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to reptile details
        },
      ),
    );
  }

  String _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    final age = now.difference(dateOfBirth);
    if (age.inDays < 30) {
      return '${age.inDays} days';
    } else if (age.inDays < 365) {
      return '${(age.inDays / 30).floor()} months';
    } else {
      return '${(age.inDays / 365).floor()} years';
    }
  }
}

class AddReptileDialog extends StatefulWidget {
  const AddReptileDialog({super.key});

  @override
  State<AddReptileDialog> createState() => _AddReptileDialogState();
}

class _AddReptileDialogState extends State<AddReptileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  DateTime _dateOfBirth = DateTime.now();
  String _sex = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Reptile'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _speciesController,
                decoration: const InputDecoration(labelText: 'Species'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a species';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sex,
                decoration: const InputDecoration(labelText: 'Sex'),
                items: ['Unknown', 'Male', 'Female']
                    .map((sex) => DropdownMenuItem(
                          value: sex,
                          child: Text(sex),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _sex = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date of Birth'),
                subtitle: Text(
                  '${_dateOfBirth.day}/${_dateOfBirth.month}/${_dateOfBirth.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dateOfBirth,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _dateOfBirth = date);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final reptile = Reptile(
        id: DateTime.now().toString(), // TODO: Replace with proper ID generation
        name: _nameController.text,
        species: _speciesController.text,
        dateOfBirth: _dateOfBirth,
        sex: _sex,
      );

      context.read<AppState>().addReptile(reptile);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }
} 