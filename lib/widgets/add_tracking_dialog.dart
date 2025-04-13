import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/tracking_entry.dart';

class AddTrackingDialog extends StatefulWidget {
  final String reptileName;

  const AddTrackingDialog({
    super.key,
    required this.reptileName,
  });

  @override
  State<AddTrackingDialog> createState() => _AddTrackingDialogState();
}

class _AddTrackingDialogState extends State<AddTrackingDialog> {
  DateTime? _selectedDate;
  final Set<String> _selectedActivities = {};
  final _remarksController = TextEditingController();

  final List<String> _activities = [
    'Took a bath',
    'Breeding observed',
    'Cleaned (spot)',
    'Cleaned (deep)',
    'Defecated',
    'Handled',
    'Shed',
    'Water changed',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Add tracking',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Cancel',
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _saveTracking,
                    tooltip: 'Save',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Picker
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
                                  : 'DD-MM-YYYY',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Activities List
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _activities.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final activity = _activities[index];
                          final isSelected = _selectedActivities.contains(activity);
                          
                          return ListTile(
                            title: Text(activity),
                            trailing: Icon(
                              Icons.check_circle,
                              color: isSelected ? Colors.green : Colors.grey.shade300,
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedActivities.remove(activity);
                                } else {
                                  _selectedActivities.add(activity);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Remarks
                    TextField(
                      controller: _remarksController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter remarks if you have them...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
                    onPressed: _saveTracking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
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

  void _saveTracking() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    if (_selectedActivities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one activity')),
      );
      return;
    }

    final entry = TrackingEntry(
      reptileName: widget.reptileName,
      date: _selectedDate!,
      activities: _selectedActivities.toList(),
      remarks: _remarksController.text.isNotEmpty ? _remarksController.text : null,
    );

    Provider.of<AppState>(context, listen: false).addTrackingEntry(entry);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tracking entry added successfully')),
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }
} 