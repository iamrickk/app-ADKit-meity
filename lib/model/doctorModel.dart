class DoctorModel {
  String firstname;
  String secondname;
  String email;
  String speciality;
  String profilePic;
  String phoneNumber;
  String uid;
  String address;

  DoctorModel({
    required this.firstname,
    required this.secondname,
    required this.email,
    required this.speciality,
    required this.profilePic,
    required this.phoneNumber,
    required this.uid,
    required this.address,
  });

  // from map
  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      firstname: map['firstname'] ?? '',
      secondname: map['secondname'] ?? '',
      email: map['email'] ?? '',
      speciality: map['speciality'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePic: map['profilePic'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "firstname": firstname,
      "secondname": secondname,
      "email": email,
      "speciality": speciality,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "profilePic": profilePic,
      "address": address,
    };
  }
}
