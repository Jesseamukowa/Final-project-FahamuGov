import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Appearance'),
                    _buildAppearanceCard(),

                    SizedBox(height: 24),

                    _buildSectionTitle('Notifications'),
                    _buildNotificationsCard(),

                    SizedBox(height: 24),

                    _buildSectionTitle('Content & Media'),
                    _buildContentCard(),

                    SizedBox(height: 24),

                    _buildSectionTitle('Language & Region'),
                    _buildLanguageCard(),

                    SizedBox(height: 24),

                    _buildSectionTitle('Privacy & Security'),
                    _buildPrivacyCard(),

                    SizedBox(height: 24),

                    _buildSectionTitle('About'),
                    _buildAboutCard(),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAppearanceCard() {
    return Card(
      child: Column(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  themeProvider.isDarkMode
                      ? 'Dark theme is enabled'
                      : 'Light theme is enabled',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                secondary: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text('Push Notifications'),
                subtitle: Text('Receive app notifications'),
                value: settingsProvider.notificationsEnabled,
                onChanged: (value) => settingsProvider.toggleNotifications(),
                secondary: _buildIconContainer(Icons.notifications),
              ),
              Divider(height: 1),
              SwitchListTile(
                title: Text('Civic Alerts'),
                subtitle: Text('Important government updates'),
                value: settingsProvider.civicAlertsEnabled,
                onChanged: settingsProvider.notificationsEnabled
                    ? (value) => settingsProvider.toggleCivicAlerts()
                    : null,
                secondary: _buildIconContainer(Icons.campaign),
              ),
              Divider(height: 1),
              SwitchListTile(
                title: Text('Discussion Notifications'),
                subtitle: Text('New messages in your discussions'),
                value: settingsProvider.discussionNotificationsEnabled,
                onChanged: settingsProvider.notificationsEnabled
                    ? (value) =>
                          settingsProvider.toggleDiscussionNotifications()
                    : null,
                secondary: _buildIconContainer(Icons.forum),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentCard() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text('Auto-play Videos'),
                subtitle: Text('Automatically play civic education videos'),
                value: settingsProvider.autoPlayVideos,
                onChanged: (value) => settingsProvider.toggleAutoPlayVideos(),
                secondary: _buildIconContainer(Icons.play_circle),
              ),
              Divider(height: 1),
              SwitchListTile(
                title: Text('Data Saver Mode'),
                subtitle: Text('Reduce data usage'),
                value: settingsProvider.dataSaverMode,
                onChanged: (value) => settingsProvider.toggleDataSaverMode(),
                secondary: _buildIconContainer(Icons.data_saver_on),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageCard() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Card(
          child: ListTile(
            title: Text('Language'),
            subtitle: Text(settingsProvider.selectedLanguage),
            leading: _buildIconContainer(Icons.language),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(settingsProvider),
          ),
        );
      },
    );
  }

  Widget _buildPrivacyCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Privacy Policy'),
            subtitle: Text('Learn about data protection'),
            leading: _buildIconContainer(Icons.privacy_tip),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showInfoDialog(
              'Privacy Policy',
              'FahamuGov is committed to protecting your privacy and personal data in accordance with Kenyan data protection laws.',
            ),
          ),
          Divider(height: 1),
          ListTile(
            title: Text('Terms of Service'),
            subtitle: Text('App usage terms and conditions'),
            leading: _buildIconContainer(Icons.description),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showInfoDialog(
              'Terms of Service',
              'By using FahamuGov, you agree to our terms of service and community guidelines for civic engagement.',
            ),
          ),
          Divider(height: 1),
          ListTile(
            title: Text('Data & Storage'),
            subtitle: Text('Manage your data preferences'),
            leading: _buildIconContainer(Icons.storage),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showInfoDialog(
              'Data & Storage',
              'Control how FahamuGov stores and uses your civic engagement data.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('About FahamuGov'),
            subtitle: Text('Version 1.0.0'),
            leading: _buildIconContainer(Icons.info),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showInfoDialog(
              'About FahamuGov',
              'FahamuGov empowers Kenyan youth to engage with civic processes, learn about government, and participate in democracy.',
            ),
          ),
          Divider(height: 1),
          ListTile(
            title: Text('Help & Support'),
            subtitle: Text('Get assistance and report issues'),
            leading: _buildIconContainer(Icons.help),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showInfoDialog(
              'Help & Support',
              'Need help? Contact our support team or visit our help center for guidance on using FahamuGov.',
            ),
          ),
          Divider(height: 1),
          ListTile(
            title: Text('Rate the App'),
            subtitle: Text('Share your feedback'),
            leading: _buildIconContainer(Icons.star),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showInfoDialog(
              'Rate FahamuGov',
              'Enjoying FahamuGov? Please rate us on the app store and help other young Kenyans discover civic engagement!',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
    );
  }

  void _showLanguageDialog(SettingsProvider settingsProvider) {
    final languages = ['English', 'Kiswahili', 'Kikuyu', 'Luo', 'Luhya'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: settingsProvider.selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    settingsProvider.setLanguage(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: Theme.of(context).colorScheme.primary,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Got it'),
            ),
          ],
        );
      },
    );
  }
}
