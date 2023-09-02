// class UserModel {
//   final String uid;
//   final String email;
//   final String displayName;
//   final String phone;
//   final String profileImageURL; // New field for profile image
//   final String password; // New field for password

//   UserModel({
//     required this.uid,
//     required this.email,
//     required this.displayName,
//     required this.phone,
//     required this.profileImageURL, // Default profile image URL
//     required this.password,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'email': email,
//       'displayName': displayName,
//       'phone': phone,
//       'profileImageURL': profileImageURL,
//       'password': password,
//       // Add more fields as needed
//     };
//   }

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'],
//       email: map['email'],
//       displayName: map['displayName'],
//       phone: map['phone'],
//       profileImageURL: map['profileImageURL'],
//       password: map['password'],
//     );
//   }
// }
