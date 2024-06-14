import 'dart:convert';

class Repoinfo {
  String name;
  String url;
  String username;
  String password;
  String path;
  String ip;
  RepoType type;

  Repoinfo({
    this.name = '',
    this.url = '',
    this.username = '',
    this.password = '',
    this.path = '',
    this.ip = '',
    required this.type,
  });

  factory Repoinfo.fromJson(dynamic json) {
    if (json is String) {
      // Decode the JSON string to a map if it's a string
      Map<String, dynamic> map = jsonDecode(json);
      return Repoinfo(
        name: map['name'],
        url: map['url'],
        username: map['username'],
        password: map['password'],
        path: map['path'],
        ip: map['ip'],
        type: RepoType.values[map['type']],
      );
    } else if (json is Map<String, dynamic>) {
      // If json is already a map, parse it directly
      return Repoinfo(
        name: json['name'],
        url: json['url'],
        username: json['username'],
        password: json['password'],
        path: json['path'],
        ip: json['ip'],
        type: RepoType.values[json['type']],
      );
    } else {
      throw ArgumentError('Invalid JSON format for Repoinfo');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'username': username,
      'password': password,
      'path': path,
      'ip': ip,
      'type': type.index,
    };
  }
}

enum RepoType { SMB, LOCAL }
