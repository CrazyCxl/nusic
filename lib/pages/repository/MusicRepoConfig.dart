import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../base/repoinfo.dart';

class MusicRepoConfig extends StatefulWidget {
  MusicRepoConfig({Key? key}) : super(key: key);

  @override
  _MusicRepoConfigState createState() => _MusicRepoConfigState();
}

class _MusicRepoConfigState extends State<MusicRepoConfig> {
  String _selectedType = 'SMB';
  String _name = '';
  String _ipAddress = '';
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.musicResConfig),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              items: ['SMB', 'Local']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Music Library Type',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            if (_selectedType == 'SMB') ...[
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _ipAddress = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'IP Address',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add your action here
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
