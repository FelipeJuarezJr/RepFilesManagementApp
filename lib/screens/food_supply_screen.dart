import 'package:flutter/material.dart';

class FoodSupplyScreen extends StatelessWidget {
  const FoodSupplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Supply'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFoodDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FoodSupplyCard(
            foodType: 'Crickets',
            quantity: 100,
            unit: 'pieces',
            lastRestocked: 'Yesterday',
          ),
          FoodSupplyCard(
            foodType: 'Mealworms',
            quantity: 200,
            unit: 'grams',
            lastRestocked: '3 days ago',
          ),
        ],
      ),
    );
  }

  void _showAddFoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddFoodDialog(),
    );
  }
}

class FoodSupplyCard extends StatelessWidget {
  final String foodType;
  final int quantity;
  final String unit;
  final String lastRestocked;

  const FoodSupplyCard({
    super.key,
    required this.foodType,
    required this.quantity,
    required this.unit,
    required this.lastRestocked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  foodType,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: $quantity $unit',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Last restocked: $lastRestocked',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Implement restock functionality
                  },
                  child: const Text('Restock'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Implement use functionality
                  },
                  child: const Text('Use'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddFoodDialog extends StatefulWidget {
  const AddFoodDialog({super.key});

  @override
  State<AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _foodTypeController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedUnit = 'pieces';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Food Supply'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _foodTypeController,
              decoration: const InputDecoration(labelText: 'Food Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a food type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    items: ['pieces', 'grams', 'kg', 'oz', 'lbs']
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedUnit = value);
                      }
                    },
                  ),
                ),
              ],
            ),
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
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement food supply creation
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _foodTypeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
} 