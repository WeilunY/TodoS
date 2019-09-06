import 'package:cloud_firestore/cloud_firestore.dart';

class User {
    String fname;
    String surname;
    String uid;
    String email;

    User({
        this.fname,
        this.surname,
        this.uid,
        this.email,
    });

    factory User.fromJson(DocumentSnapshot json) => new User(
        fname: json["fname"],
        surname: json["surname"],
        uid: json.documentID,
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "fname": fname,
        "surname": surname,
        "uid": uid,
        "email": email,
    };
}