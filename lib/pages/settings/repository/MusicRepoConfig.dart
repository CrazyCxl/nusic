import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../base/repoinfo.dart';

class MusicRepoConfig extends StatefulWidget {
  final Repoinfo? initialRepo;

  MusicRepoConfig({Key? key, this.initialRepo}) : super(key: key);

  @override
  _MusicRepoConfigState createState() => _MusicRepoConfigState();
}

class _MusicRepoConfigState extends State<MusicRepoConfig> {
  late TextEditingController nameController;
  late TextEditingController pathController;
  late TextEditingController ipController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  late Repoinfo _repoinfo;

  @override
  void initState() {
    super.initState();
    _repoinfo = widget.initialRepo ?? Repoinfo(type: RepoType.SMB);
    nameController = TextEditingController(text: _repoinfo.name);
    pathController = TextEditingController(text: _repoinfo.path);
    ipController = TextEditingController(text: _repoinfo.ip);
    usernameController = TextEditingController(text: _repoinfo.username);
    passwordController = TextEditingController(text: _repoinfo.password);
  }

  @override
  void dispose() {
    nameController.dispose();
    pathController.dispose();
    ipController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.musicResConfig),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _repoinfo.type == RepoType.SMB ? 'SMB' : 'Local',
              onChanged: (value) {
                setState(() {
                  if (value == "SMB") {
                    _repoinfo.type = RepoType.SMB;
                  } else {
                    _repoinfo.type = RepoType.LOCAL;
                  }
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
              controller: nameController,
              onChanged: (value) {
                setState(() {
                  _repoinfo.name = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: pathController,
              onChanged: (value) {
                setState(() {
                  _repoinfo.path = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Path',
              ),
            ),
            if (_repoinfo.type == RepoType.SMB) ...[
              SizedBox(height: 16.0),
              TextFormField(
                controller: ipController,
                onChanged: (value) {
                  setState(() {
                    _repoinfo.ip = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'IP Address',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: usernameController,
                onChanged: (value) {
                  setState(() {
                    _repoinfo.username = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                onChanged: (value) {
                  setState(() {
                    _repoinfo.password = value;
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
                Navigator.pop(context, _repoinfo);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
