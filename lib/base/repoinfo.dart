enum RepoType { SMB, LOCAL }

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
    this.type = RepoType.LOCAL, // Default value for enum
  });
}
