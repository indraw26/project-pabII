class Users {
  String uid;
  String name;
  String email;
  String phone;

  Users({required this.uid, required this.name, required this.email, required this.phone});

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
