import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repfiles/models/app_state.dart';
import 'package:repfiles/models/reptile.dart';
import '../styles/app_theme.dart';
import '../models/morph.dart';
import '../widgets/add_tracking_dialog.dart';

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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  const Text('No reptiles added yet. Tap + to add one!'),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 400, // Responsive grid
                childAspectRatio: 1.5, // More horizontal
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: appState.reptiles.length,
              itemBuilder: (context, index) {
                final reptile = appState.reptiles[index];
                return ReptileCard(reptile: reptile);
              },
            ),
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

class ReptileCard extends StatelessWidget {
  final Reptile reptile;

  const ReptileCard({
    super.key,
    required this.reptile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          // Hero Image and Info Section
          Expanded(
            child: Row(
              children: [
                // Left side - Image
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.pets,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                // Right side - Info
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reptile.name,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  if (reptile.identifier != null)
                                    Text(
                                      '(${reptile.identifier})',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            _buildGenderIcon(),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            if (reptile.weight != null) ...[
                              _buildInfoColumn(
                                '${reptile.weight} ${reptile.weightUnit}',
                                'Weight',
                              ),
                              const SizedBox(width: 24),
                            ],
                            _buildInfoColumn(
                              _calculateAge(reptile.dateOfBirth),
                              'Age',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Footer Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  icon: Icons.timer,
                  tooltip: 'Add tracking',
                  context: context,
                ),
                _buildActionButton(
                  icon: Icons.note_add,
                  tooltip: 'Add note',
                  context: context,
                ),
                _buildActionButton(
                  icon: Icons.straighten,
                  tooltip: 'Add measurement',
                  context: context,
                ),
                _buildActionButton(
                  icon: Icons.restaurant,
                  tooltip: 'Feeding',
                  context: context,
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to details
                  },
                  child: const Text('Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderIcon() {
    IconData icon;
    Color color;
    switch (reptile.sex.toLowerCase()) {
      case 'male':
        icon = Icons.male;
        color = Colors.blue;
        break;
      case 'female':
        icon = Icons.female;
        color = Colors.pink;
        break;
      default:
        icon = Icons.question_mark;
        color = Colors.grey;
    }
    return Icon(icon, color: color, size: 24);
  }

  Widget _buildInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required BuildContext context,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: () {
        if (tooltip == 'Add tracking') {
          showDialog(
            context: context,
            builder: (context) => AddTrackingDialog(
              reptileName: reptile.name,
            ),
          );
        }
      },
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
        Consumer<AppState>(
          builder: (context, appState, child) {
            return ElevatedButton(
              onPressed: appState.isLoading ? null : _saveReptile,
              child: appState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Save'),
            );
          },
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

  Future<void> _saveReptile() async {
    if (_formKey.currentState!.validate()) {
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name is required')),
        );
        return;
      }

      final reptile = Reptile(
        name: _nameController.text,
        identifier: _identifierController.text,
        species: 'Ball Python', // TODO: Add species selection
        dateOfBirth: _birthdate ?? DateTime.now(),
        sex: _sex,
        group: _group == 'No group selected' ? null : _group,
        morph: _selectedMorphs.isNotEmpty ? _selectedMorphs.join(', ') : null,
        length: double.tryParse(_lengthController.text),
        lengthUnit: _lengthUnit,
        weight: double.tryParse(_weightController.text),
        weightUnit: _weightUnit,
        breeder: _breederController.text,
        remarks: _remarksController.text,
      );

      try {
        await context.read<AppState>().addReptile(reptile);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reptile added successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding reptile: $e')),
          );
        }
      }
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