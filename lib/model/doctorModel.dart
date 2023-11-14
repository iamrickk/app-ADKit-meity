class DoctorModel {
  String firstname;
  String secondname;
  String email;
  String speciality;
  String profilePic;
  String phoneNumber;
  String uid;
  String address;
  String pin;
  String state;
  String district;
  bool pending;

  DoctorModel({
    required this.firstname,
    required this.secondname,
    required this.email,
    required this.speciality,
    required this.profilePic,
    required this.phoneNumber,
    required this.uid,
    required this.address,
    required this.pin,
    required this.state,
    required this.district,
    required this.pending,
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
      pin: map['pin'] ?? '',
      state: map['state'] ?? '',
      district: map['district'] ?? '',
      pending: map['pending'] ?? '',
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
      "pin": pin,
      "state": state,
      "district": district,
      "pending" : pending,
    };
  }
}
