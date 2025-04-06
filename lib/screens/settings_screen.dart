import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repfiles/models/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SettingsSection(
            title: 'Account',
            children: [
              _SettingsItem(
                icon: Icons.person,
                title: 'Profile',
                subtitle: 'Manage your account information',
              ),
              _SettingsItem(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Configure notification preferences',
              ),
            ],
          ),
          const _SettingsSection(
            title: 'App Settings',
            children: [
              _ThemeSettingItem(),
              _SettingsItem(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
              ),
              _SettingsItem(
                icon: Icons.scale,
                title: 'Units',
                subtitle: 'Imperial (lbs, inches)',
              ),
            ],
          ),
          const _SettingsSection(
            title: 'Data',
            children: [
              _SettingsItem(
                icon: Icons.backup,
                title: 'Backup',
                subtitle: 'Manage your data backup',
              ),
              _SettingsItem(
                icon: Icons.import_export,
                title: 'Export Data',
                subtitle: 'Export your data to CSV',
              ),
            ],
          ),
          const _SettingsSection(
            title: 'About',
            children: [
              _SettingsItem(
                icon: Icons.info,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _SettingsItem(
                icon: Icons.policy,
                title: 'Privacy Policy',
              ),
              _SettingsItem(
                icon: Icons.description,
                title: 'Terms of Service',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Log Out'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap ?? () {
        // TODO: Implement navigation to respective settings pages
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title settings coming soon!'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}

class _ThemeSettingItem extends StatelessWidget {
  const _ThemeSettingItem();

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.dark_mode),
      title: const Text('Dark Mode'),
      subtitle: const Text('Toggle dark/light theme'),
      value: Theme.of(context).brightness == Brightness.dark,
      onChanged: (bool value) {
        // TODO: Implement theme switching
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Theme switching coming soon!'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }
} 