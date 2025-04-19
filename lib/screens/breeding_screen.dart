import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/reptile.dart';
import '../widgets/select_reptile_dialog.dart';

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
  final _identifierController = TextEditingController();
  DateTime? _startDate;
  bool _isFinished = false;
  bool _hasMultipleClutches = false;
  Reptile? _selectedMale;
  Reptile? _selectedFemale;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'New Breeding Project',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Body
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Reptile Selection
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _selectMale(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Add male'),
                              ),
                              if (_selectedMale != null)
                                Card(
                                  child: ListTile(
                                    title: Text(_selectedMale!.name),
                                    subtitle: Text(_selectedMale!.species),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() => _selectedMale = null);
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.heart_broken, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _selectFemale(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Add female'),
                              ),
                              if (_selectedFemale != null)
                                Card(
                                  child: ListTile(
                                    title: Text(_selectedFemale!.name),
                                    subtitle: Text(_selectedFemale!.species),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() => _selectedFemale = null);
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Project Information Section
                    const Text(
                      'Project Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Identifier Field
                    TextFormField(
                      controller: _identifierController,
                      decoration: const InputDecoration(
                        labelText: 'Identifier',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an identifier';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Start Date Picker
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _startDate == null
                                  ? 'Select Date'
                                  : '${_startDate!.day}-${_startDate!.month}-${_startDate!.year}',
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Checkboxes
                    CheckboxListTile(
                      title: const Text('Project is finished'),
                      value: _isFinished,
                      onChanged: (value) {
                        setState(() => _isFinished = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Multiple clutches'),
                      value: _hasMultipleClutches,
                      onChanged: (value) {
                        setState(() => _hasMultipleClutches = value ?? false);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Add Clutch Button
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement add clutch functionality
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add a clutch'),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() => _startDate = picked);
    }
  }

  void _selectMale(BuildContext context) async {
    final result = await showDialog<Reptile>(
      context: context,
      builder: (context) => const SelectReptileDialog(
        title: 'Select Male',
        gender: 'male',
      ),
    );
    
    if (result != null) {
      setState(() {
        _selectedMale = result;
      });
    }
  }

  void _selectFemale(BuildContext context) async {
    final result = await showDialog<Reptile>(
      context: context,
      builder: (context) => const SelectReptileDialog(
        title: 'Select Female',
        gender: 'female',
      ),
    );
    
    if (result != null) {
      setState(() {
        _selectedFemale = result;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement project creation
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }
} 