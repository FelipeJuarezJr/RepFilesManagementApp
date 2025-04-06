import 'package:flutter/material.dart';
import 'package:repfiles/screens/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RepFiles'),
      ),
      drawer: NavigationDrawer(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Center(
              child: Text(
                'RepFiles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          _buildNavItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          _buildNavItem(
            icon: Icons.pets,
            label: 'Animals',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/animals');
            },
          ),
          _buildNavItem(
            icon: Icons.favorite,
            label: 'Breeding Projects',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/breeding');
            },
          ),
          _buildNavItem(
            icon: Icons.calculate,
            label: 'Genetics Calculator',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/calculator');
            },
          ),
          _buildNavItem(
            icon: Icons.calendar_today,
            label: 'Schedule',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/schedule');
            },
          ),
          _buildNavItem(
            icon: Icons.restaurant,
            label: 'Food Supply',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/food-supply');
            },
          ),
          _buildNavItem(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: const DashboardScreen(),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }
} 