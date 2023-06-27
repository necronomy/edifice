class MyUser {
  final String uid;
  final String? email;
  MyUser({required this.uid, required this.email});
}

class UserModel {
  final String uid;
  final String name;
  final String type;
  final String login;
  final String password;
  final String firmauid;
  final List obyektlar;

  UserModel(
      {required this.uid,
      required this.name,
      required this.type,
      required this.login,
      required this.password,
      required this.firmauid,
      required this.obyektlar});

  factory UserModel.fromDocument(Map<String, dynamic> documentSnapshot) {
    return UserModel(
      uid: documentSnapshot['uid'],
      name: documentSnapshot['name'],
      type: documentSnapshot['type'],
      login: documentSnapshot['login'],
      password: documentSnapshot['password'],
      firmauid: documentSnapshot['firmauid'],
      obyektlar: documentSnapshot['obyektlar'],
    );
  }
}
