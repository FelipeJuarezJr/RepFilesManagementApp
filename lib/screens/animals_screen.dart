import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repfiles/models/app_state.dart';
import 'package:repfiles/models/reptile.dart';
import '../styles/app_theme.dart';
import '../models/morph.dart';

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
  final _identifierController = TextEditingController();
  final _breederController = TextEditingController();
  final _remarksController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _sex = 'Unknown';
  String _group = 'No group selected';
  String _lengthUnit = 'cm';
  String _weightUnit = 'gr';
  DateTime? _birthdate;
  List<String> _selectedMorphs = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Reptile'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter a name or an identifier, or both if you want to',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _identifierController,
                      decoration: const InputDecoration(
                        labelText: 'Identifier',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Group'),
                        const SizedBox(height: 8),
                        InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(_group),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  // TODO: Implement group selection
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sex'),
                        const SizedBox(height: 8),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'Female',
                              icon: Icon(Icons.female),
                            ),
                            ButtonSegment(
                              value: 'Male',
                              icon: Icon(Icons.male),
                            ),
                            ButtonSegment(
                              value: 'Unknown',
                              icon: Icon(Icons.question_mark),
                            ),
                          ],
                          selected: {_sex},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              _sex = newSelection.first;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Morphs'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Select Morphs'),
                        onPressed: _showMorphSelectionDialog,
                      ),
                    ],
                  ),
                  if (_selectedMorphs.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _selectedMorphs.map((morph) {
                        return Chip(
                          label: Text(morph),
                          onDeleted: () {
                            setState(() {
                              _selectedMorphs.remove(morph);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Length'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _lengthController,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: _lengthUnit,
                              items: ['cm', 'mm', 'inch', 'ft']
                                  .map((unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _lengthUnit = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weight'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _weightController,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: _weightUnit,
                              items: ['gr', 'kg', 'oz', 'lbs']
                                  .map((unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Text(unit),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _weightUnit = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Birthdate'),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _birthdate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  setState(() => _birthdate = date);
                                }
                              },
                            ),
                          ),
                          controller: TextEditingController(
                            text: _birthdate != null
                                ? '${_birthdate!.day}-${_birthdate!.month}-${_birthdate!.year}'
                                : '',
                          ),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _breederController,
                      decoration: const InputDecoration(
                        labelText: 'Breeder',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                  hintText: 'add your remarks here...',
                ),
                maxLines: 5,
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO: Save reptile data
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _showMorphSelectionDialog() async {
    final List<Morph> availableMorphs = [
      const Morph(
        name: 'Normal',
        traits: ['Wild Type'],
      ),
      const Morph(
        name: 'Albino',
        description: 'Lacks melanin pigment',
        traits: ['Recessive'],
      ),
      const Morph(
        name: 'Piebald',
        description: 'White patches on body',
        traits: ['Recessive'],
      ),
      const Morph(
        name: 'Spider',
        description: 'Reduced pattern with web-like markings',
        traits: ['Dominant'],
      ),
      // Add more morphs as needed
    ];

    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelection = List.from(_selectedMorphs);
        
        return AlertDialog(
          title: const Text('Select Morphs'),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setState) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableMorphs.length,
                  itemBuilder: (context, index) {
                    final morph = availableMorphs[index];
                    return CheckboxListTile(
                      title: Text(morph.name),
                      subtitle: morph.description != null
                          ? Text(
                              '${morph.description}\nTraits: ${morph.traits.join(", ")}',
                            )
                          : Text('Traits: ${morph.traits.join(", ")}'),
                      value: tempSelection.contains(morph.name),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelection.add(morph.name);
                          } else {
                            tempSelection.remove(morph.name);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, tempSelection),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedMorphs = result;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _breederController.dispose();
    _remarksController.dispose();
    _lengthController.dispose();
    _weightController.dispose();
    super.dispose();
  }
} 