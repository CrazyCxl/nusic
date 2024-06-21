import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'repository/MusicRepoList.dart';
import './StorageConfigPage.dart'; // Import the storage configuration page

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: <Widget>[
          _buildSettingItem(context, Icons.add_home_outlined,
              AppLocalizations.of(context)!.musicresource, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MusicRepoList()),
            );
          }),
          _buildSettingItem(context, Icons.store_outlined,
              AppLocalizations.of(context)!.store, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StorageConfigPage()),
            );
          }),
          _buildSettingItem(context, Icons.language, "Language"),
          _buildGroupDivider(),
          _buildSettingItem(context, Icons.person, "Profile"),
          _buildSettingItem(context, Icons.security, "Security"),
          _buildGroupDivider(),
          // _buildGroupTitle(context, "About"),
          _buildSettingItem(context, Icons.info, "About Us"),
          _buildSettingItem(context, Icons.help, "Help & Support"),
        ],
      ),
    );
  }

  Widget _buildGroupTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title,
      {IconData trailingIcon = Icons.arrow_forward_ios, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(trailingIcon),
      onTap: onTap,
    );
  }

  Widget _buildGroupDivider() {
    return Divider();
  }
}
