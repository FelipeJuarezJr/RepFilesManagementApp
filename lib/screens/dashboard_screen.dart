import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repfiles/models/app_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            context,
            icon: Icons.pets,
            title: 'Animals',
            subtitle: '0 reptiles',
            onTap: () => Navigator.pushNamed(context, '/animals'),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.favorite,
            title: 'Breeding',
            subtitle: '0 projects',
            onTap: () => Navigator.pushNamed(context, '/breeding'),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.calendar_today,
            title: 'Schedule',
            subtitle: '0 tasks today',
            onTap: () => Navigator.pushNamed(context, '/schedule'),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.restaurant,
            title: 'Food Supply',
            subtitle: 'Check inventory',
            onTap: () => Navigator.pushNamed(context, '/food-supply'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 