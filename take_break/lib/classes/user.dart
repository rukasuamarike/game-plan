import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String id;
  String email;
  String firstname;
  String lastname;
  UserData({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
  });
  static UserData fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    UserData res = UserData(
      id: snap.id,
      email: data['email'],
      firstname: data['firstname'] ?? false,
      lastname: data['lastname'],
    );
    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
    };
  }
}
