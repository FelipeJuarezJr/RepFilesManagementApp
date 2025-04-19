import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/reptile.dart';

class SelectReptileDialog extends StatelessWidget {
  final String title;
  final String gender;

  const SelectReptileDialog({
    super.key,
    required this.title,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Consumer<AppState>(
            builder: (context, appState, child) {
              final reptiles = appState.reptiles
                  .where((r) => r.gender.toLowerCase() == gender.toLowerCase())
                  .toList();

              if (reptiles.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('No reptiles found'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Navigate to add reptile screen
                        },
                        child: const Text('Add New Reptile'),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: reptiles.map((reptile) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.pets),
                        ),
                        title: Text(reptile.name),
                        subtitle: Text(reptile.species),
                        onTap: () {
                          Navigator.pop(context, reptile);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 