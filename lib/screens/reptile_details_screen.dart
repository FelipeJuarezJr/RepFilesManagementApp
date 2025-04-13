import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/app_state.dart';
import '../models/reptile.dart';
import '../widgets/add_file_dialog.dart';
import '../widgets/file_viewer_dialog.dart';

class ReptileDetailsScreen extends StatefulWidget {
  final Reptile reptile;

  const ReptileDetailsScreen({
    super.key,
    required this.reptile,
  });

  @override
  State<ReptileDetailsScreen> createState() => _ReptileDetailsScreenState();
}

class _ReptileDetailsScreenState extends State<ReptileDetailsScreen> {
  Reptile get reptile => widget.reptile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reptile.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Summary Card
              _buildSummaryCard(),
              const SizedBox(height: 16),
              
              // Two Column Layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      children: [
                        _buildFeedingCard(),
                        const SizedBox(height: 16),
                        _buildHistoryCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right Column
                  Expanded(
                    child: Column(
                      children: [
                        _buildNotesCard(),
                        const SizedBox(height: 16),
                        _buildPhotosCard(),
                        const SizedBox(height: 16),
                        _buildFilesCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Hero Image
            Image.asset(
              'assets/images/gecko.svg',
              height: 120,
              width: 120,
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${reptile.name} (${reptile.identifier})',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildGenderIcon(),
                    ],
                  ),
                  Text(
                    reptile.species,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            _buildStat('Age', '1 day'),
            _buildStat('Weight', '${reptile.weight} ${reptile.weightUnit}'),
            _buildStat('Length', '${reptile.length} ${reptile.lengthUnit}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label.toLowerCase(),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderIcon() {
    IconData icon;
    Color color;
    
    switch (reptile.gender.toLowerCase()) {
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
    
    return Icon(icon, color: color);
  }

  Widget _buildFeedingCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Feeding'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // TODO: Implement feeding settings
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // TODO: Implement add feeding
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No history has been added yet'),
          ),
          const Divider(height: 1),
          ListTile(
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SHOW ALL HISTORY'),
                Icon(Icons.chevron_right),
              ],
            ),
            onTap: () {
              // TODO: Show all feeding history
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('History'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // TODO: Implement history settings
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // TODO: Implement add history
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('The animal was born'),
            subtitle: const Text('Born'),
            trailing: const Text('2 days ago'),
          ),
          const Divider(height: 1),
          ListTile(
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SHOW ALL HISTORY'),
                Icon(Icons.chevron_right),
              ],
            ),
            onTap: () {
              // TODO: Show all history
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Notes'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Implement add note
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No history has been added yet'),
          ),
          const Divider(height: 1),
          ListTile(
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SHOW ALL NOTES'),
                Icon(Icons.chevron_right),
              ],
            ),
            onTap: () {
              // TODO: Show all notes
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Photos'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddFileDialog(
                        reptileName: reptile.name,
                        isPhoto: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer<AppState>(
            builder: (context, appState, child) {
              final photos = appState.getPhotosForReptile(reptile.name);
              
              if (photos.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("You haven't uploaded any photos yet"),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => FileViewerDialog(
                          entry: photo,
                          onDelete: () {
                            appState.deletePhoto(photo);
                          },
                        ),
                      );
                    },
                    child: Image.file(
                      File(photo.path),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilesCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Files'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddFileDialog(
                    reptileName: reptile.name,
                    isPhoto: false,
                  ),
                );
              },
            ),
          ),
          Consumer<AppState>(
            builder: (context, appState, child) {
              final files = appState.getFilesForReptile(reptile.name);
              
              if (files.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("You haven't uploaded any files yet"),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return ListTile(
                    leading: const Icon(Icons.file_present),
                    title: Text(file.fileName),
                    subtitle: Text(file.description ?? ''),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => FileViewerDialog(
                          entry: file,
                          onDelete: () {
                            appState.deleteFile(file);
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
} 