class Usuario {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  Usuario({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });

  factory Usuario.fromFirebase(Map<String, dynamic> data, String uid) {
    return Usuario(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
