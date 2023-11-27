// import 'package:provider/provider.dart';
// import 'package:thefirstone/resources/auth_provider.dart';


// class DoctorDataUpdater {
//   static void updateDoctorInfoInProvider(
//     BuildContext context, {
//     String? firstName,
//     String? secondName,
//     String? email,
//     String? speciality,
//     String? address,
//     String? state,
//     String? pinCode,
//     String? district,
//     String? profilePicPath,
//   }) {
//     final ap = Provider.of<AuthProvider>(context, listen: false);

//     // Update the doctor model in AuthProvider
//     if (firstName != null) ap.doctorModel.firstname = firstName;
//     if (secondName != null) ap.doctorModel.secondname = secondName;
//     if (email != null) ap.doctorModel.email = email;
//     if (speciality != null) ap.doctorModel.speciality = speciality;
//     if (address != null) ap.doctorModel.address = address;
//     if (state != null) ap.doctorModel.state = state;
//     if (pinCode != null) ap.doctorModel.pin = pinCode;
//     if (district != null) ap.doctorModel.district = district;
//     if (profilePicPath != null) ap.doctorModel.profilePic = profilePicPath;

//     // Optionally, you can call notifyListeners if AuthProvider extends ChangeNotifier
//     // ignore: invalid_use_of_protected_member
//     ap.notifyListeners();
//   }
// }
