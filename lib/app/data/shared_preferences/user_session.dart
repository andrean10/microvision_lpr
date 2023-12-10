class UserSession {
  final String id;
  final String userID;
  final String password;

  UserSession({
    required this.id,
    required this.userID,
    required this.password,
  });

  @override
  String toString() {
    return 'UserSession(id: $id, userId: $userID, password: $password)';
  }
}
